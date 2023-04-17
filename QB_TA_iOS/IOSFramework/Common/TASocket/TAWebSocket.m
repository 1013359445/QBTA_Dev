//
//  TAWebSocket.m
//  IOSFramework
//
//  Created by 白伟 on 2023/4/14.
//
#import "TAWebSocket.h"
#import "SRWebSocket.h"
#import "Reachability.h"

static int const kHeartbeatDuration = 4*60;

@interface TAWebSocket ()<SRWebSocketDelegate>
@property (nonatomic,strong) SRWebSocket *socket;
@property (strong, nonatomic) NSTimer *heatBeat;
@property (assign, nonatomic) NSTimeInterval reConnectTime;

@property (nonatomic,strong) NSString *serverIpString;

@property (nonatomic,assign) BOOL autoReconnect;
@property (nonatomic,assign) BOOL isReachable;

@end

@implementation TAWebSocket

- (instancetype)initWithServerIp:(NSString *__nullable)serverIp {
    if (self = [super init]) {
        self.serverIpString = serverIp;
        [self addNoti];

    }
    return self;
}

#pragma mark - Public -
- (void)connectWebSocket {
    self.autoReconnect = YES;
    [self initWebSocket];
}
- (void)closeWebSocket {
    self.autoReconnect = NO;
    [self close];
}

- (void)sendMsg:(NSString *)msg {
    if (self.socket && self.socket.readyState == SR_OPEN) {
        // 只有在socket状态为SR_OPEN 时，才可以发送消息
        // 在socket状态不为SR_OPEN，可以将消息放进队列里，在websocket连上时，再发送
        [self.socket sendString:msg error:nil];
    }
}

#pragma mark - Private -

#pragma mark -- WebSocket
//初始化 WebSocket
- (void)initWebSocket{
    if (_socket) {
        return;
    }
//    NSString *urlStr = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)(self.serverIpString), (CFStringRef)@"%", NULL, kCFStringEncodingUTF8));
    NSURL *url = [NSURL URLWithString:self.serverIpString];
    //请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    //初始化请求`
    _socket = [[SRWebSocket alloc] initWithURLRequest:request];
    //代理协议`
    _socket.delegate = self;
    //直接连接
    [_socket open];
}


#pragma mark - NOTI  -
- (void)addNoti {
    self.isReachable = YES;

    //开启网络状况的监听
    //来订阅实时的网络状态变化通知。导入Reachability.h头文件，然后注册一个对象来订阅网络状态变化的信息，网络状态变化的信息名称为kReachabilityChanged-Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    //通过检查某个主机能否访问来判断当前网络是否可用：
    Reachability *hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    //开始监听，会启动一个run loop
    [hostReach startNotifier];
}

// 网络变化
-(void)reachabilityChanged:(NSNotification *)note{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    self.isReachable = YES;
    // 断网时，关闭websocket
    if(status == NotReachable){
        [self close];
        self.isReachable = NO;

    }else if (status==kReachableViaWiFi||status==kReachableViaWWAN) {
        // 网络连上时，重新连接websocket
        if ((self.socket.readyState == SR_OPEN || self.socket.readyState == SR_CONNECTING) && self.socket) {
            return;
        }
        [self reConnect];
    }
}

#pragma mark - Heart Timer -
//保活机制 探测包
- (void)startHeartbeat {
    self.heatBeat = [NSTimer scheduledTimerWithTimeInterval:kHeartbeatDuration target:self selector:@selector(heartbeatAction) userInfo:nil repeats:YES];
    [self.heatBeat setFireDate:[NSDate distantPast]];
    [[NSRunLoop currentRunLoop] addTimer:_heatBeat forMode:NSRunLoopCommonModes];
}


//断开连接时销毁心跳
- (void)destoryHeartbeat{
    [self.heatBeat invalidate];
    self.heatBeat = nil;
}

// 发送心跳
- (void)heartbeatAction {
    if (self.socket.readyState == SR_OPEN) {
        [self.socket sendString:@"heart" error:nil];
    }
}


//重连机制
- (void)reConnect{
    if (!self.autoReconnect) {
        return;
    }
    
    //每隔一段时间重连一次
    // 重连间隔时间 可以根据业务调整
    if (_reConnectTime > 60) {
        _reConnectTime = 60;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_reConnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self initWebSocket];
    });
    
    if (_reConnectTime == 0) {
        _reConnectTime = 2;
    }else{
        _reConnectTime *= 2;
    }
}

- (void)resetConnectTime {
    self.reConnectTime = 0;
}

// 关闭Socket
- (void)close {
    [self destoryHeartbeat];
    [self.socket close];
    self.socket = nil;
    [self resetConnectTime];
}

#pragma mark -- SRWebSocketDelegate
//收到服务器消息是回调
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    if ([message isKindOfClass:[NSString class]]) {
        NSString *msg = (NSString *)message;
        if ([self.delegate respondsToSelector:@selector(TAWebSocketDidReceiveMessage:)]) {
            [self.delegate TAWebSocketDidReceiveMessage:msg];
        }
    }
}

//连接成功
- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    [self resetConnectTime];
    [self startHeartbeat];

    if (self.socket != nil) {
        // 只有 SR_OPEN 开启状态才能调 send 方法啊，不然要崩
        if (_socket.readyState == SR_OPEN) {
            if ([self.delegate respondsToSelector:@selector(TAWebSocketDidOpen)]) {
                [self.delegate TAWebSocketDidOpen];
            }
        } else if (_socket.readyState == SR_CONNECTING) {
            //NSLog(@"正在连接中，重连后其他方法会去自动同步数据");
        } else if (_socket.readyState == SR_CLOSING || _socket.readyState == SR_CLOSED) {
            // websocket 断开了，重连
            [self reConnect];
        }
    }
}

//连接失败的回调
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    // 1.判断当前网络环境，如果断网了就不要连了，等待网络到来，在发起重连
    // 2.判断调用层是否需要连接，例如用户都没在聊天界面，连接上去浪费流量
    
    if (error.code == 50 || !self.isReachable) {
        // 网络异常不重连
        return;
    }
    [self reConnect];
}

//连接断开的回调
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    // 连接断开时，自动重连
    if (!self.isReachable) {
        return;
    }
    [self reConnect];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
}

#pragma mark - 其他 -
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
