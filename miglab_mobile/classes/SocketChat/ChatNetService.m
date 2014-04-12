//
//  ChatNetService.m
//  ChatDemo
//
//  Created by 180 on 14-3-30.
//
//
#define  HTTP_API_URL  @"http://112.124.49.59/cgi-bin/"
#import "ChatNetService.h"
#import "AFNetworking.h"
#import "ChatDef.h"
#import "ChatNotification.h"
@interface ChatNetService ()
{
    int64_t                 m_uid;
    int64_t                 m_tid;
    int64_t                 m_platformid;
    int64_t                 m_session;
    int64_t                 m_minmsgid;
    AsyncSocket*            m_socket;
    NSString*               m_token;
    NSMutableData*          m_recvdata;
    NSMutableDictionary*    m_dicuserinfos;
}
@end
@implementation ChatNetService 


- (id) init:(NSString*) token uid:(int64_t)uid
              tid: (int64_t) tid
{
    self = [super init];
    m_uid   = uid;
    m_tid   = tid;
    m_token = token;
    m_platformid = 10000;
    m_recvdata = nil;
    m_session = 0;
    if( m_token == nil )
        m_token = @"11231231232132132131232132323";
    m_dicuserinfos = [[NSMutableDictionary alloc] init];
    m_minmsgid = 0;
    [self getSC];
    return self;
}

- (void)dealloc
{
    [self quitLogin];
    [m_socket disconnect];
    m_socket = nil;
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}
#define INIT_PACK_HEAD(head,packetlen,code,msgtype) {\
                       head.packet_length = packetlen;\
                       head.operate_code  = code; \
                       head.data_length  = packetlen - PACKET_HEAD_LENGTH; \
                       head.current_time  = 0 ;\
                       head.msg_type  = msgtype; \
                       head.is_zip  = 0 ;\
                       head.msg_id  = 0; \
                       head.reserverd  = 0 ;}\

-(void) getRequestJsonData:(NSString*) path success:(void (^)(id jsonResult)) success failure:(void (^)(NSError* err)) failure
{
    NSString* strurl = [[NSString alloc]initWithFormat:@"%@%@",HTTP_API_URL,path];
    NSURL* url = [NSURL URLWithString:strurl];
    NSLog(@"getRequestJsonData  %@",strurl);
    AFHTTPClient* http = [AFHTTPClient clientWithBaseURL:url];
    [http getPath:nil parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSData *jsonData=[[NSData alloc] initWithData:[[operation responseString] dataUsingEncoding:NSUTF8StringEncoding]];
        NSError* error = nil;
        id jsonObject=[NSJSONSerialization JSONObjectWithData:jsonData
                                                      options:NSJSONReadingMutableLeaves error:&error];
        if (jsonObject != nil) {
            NSInteger status = [[ (NSDictionary*)jsonObject objectForKey:@"status"] integerValue];
            if (status != 0 ) {
                 if( failure != nil)
                     failure([ (NSDictionary*)jsonObject objectForKey:@"msg"]);
            }
            else
            {
                 success([(NSDictionary*)jsonObject objectForKey:@"result"]);
            }
        }
        else
            if( failure != nil)
                failure(error);
            
       
    }
   failure:^(AFHTTPRequestOperation *operation,NSError *error){
       if( failure != nil)
           failure(error);
    }];
}

- (void)getSC
{
    NSString* path = [[NSString alloc]initWithFormat:@"getsc.fcgi?platformid=%lld&uid=%lld&tid=%lld",
                                                    m_platformid,m_uid,m_tid];
    [self getRequestJsonData:path success:^(id jsonResult) {
        if (jsonResult != nil) {
            NSString* serverIP = [jsonResult objectForKey:@"host"];
            NSInteger  serverPort = [[jsonResult objectForKey:@"port"] integerValue];
            [self connectServer:serverIP port:serverPort];
        }
    } failure:^(NSError *error) {
        if( self.delegate != nil )
            [self.delegate onError:error.description];
    }];
    
}
-(NSArray*)getHiscChat
{
    
    NSString* path = [[NSString alloc]initWithFormat:@"hischat.fcgi?platformid=%lld&uid=%lld&tid=%lld&token=%@&msgid=%lld",m_platformid,m_uid,m_tid,m_token,m_minmsgid];
    [self getRequestJsonData:path success:^(id jsonResult) {
        if (jsonResult != nil) {
            id jsonObject = [jsonResult objectForKey:@"chat"];
            if (jsonObject && [jsonObject isKindOfClass:[NSArray class]])
            {
                [self onHiscChat:(NSArray*)jsonObject];
            }
            
        }
    } failure:^(NSError *error) {
        if( self.delegate != nil )
            [self.delegate onError:error.description];
    }];
    return nil;
}

-(void) reloadHiscChat:(int64_t) minmsgid
{
    m_minmsgid = minmsgid;
    [self getHiscChat];
}
-(NSString*) getLastPackString:(const void*) pData pos:(NSInteger) pos
{
    struct PacketHead* pHead = (struct PacketHead*)pData;
    pos = PACKET_HEAD_LENGTH + pos;
    NSData* data = [NSData dataWithBytes:pData length:pHead->packet_length];
    data = [data subdataWithRange:NSMakeRange(pos, pHead->packet_length - pos)];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}


-(void) showAlert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (bool)connectServer:(NSString *)serverIP port:(NSInteger)serverPort
{
    if (m_socket == nil ) {
        m_socket = [[AsyncSocket alloc] initWithDelegate:self];
        NSError * err = nil;
        // NSLog(@"connectServer  %@:%d", serverIP,serverPort);
        if (![m_socket connectToHost:serverIP onPort:serverPort withTimeout:10 error:&err]) {
            [self showAlert:@"Connection failed to host "
                        msg:[[NSString alloc]initWithFormat:@"%@:%d %d",serverIP,serverPort,[err code]]];
            return false;
        }
    }else{
        [m_socket readDataWithTimeout:-1 tag:0];
        return false;
    }
    return true;

}

-(void)sendData:(const void*) pData len:(NSInteger) len
{
    NSData *data = [NSData dataWithBytes:(char*)pData length:len];
    [self sendData:data];
}

-(void)sendData:(NSData*) data
{
    [m_socket writeData:data withTimeout:(1) tag:0];
}

-(void) bindSendUserInfo:(ChatMsg*) msg
{
    @synchronized(self)
    {
        ChatUserInfo*  userinfo = [m_dicuserinfos valueForKey:[NSString stringWithFormat:@"%lld",msg.send_user_id]];
        if ( userinfo != nil ) {
            msg.send_user_info = userinfo;
        }
    }
}

-(void) requestTUserInfo
{
    struct ReqOppstionInfo req;
    memset(&req, 0, REQ_OPPOSITION_INFO_SIZE);
    INIT_PACK_HEAD(req.packet_head,REQ_OPPOSITION_INFO_SIZE,REQ_OPPOSITION_INFO,CHAT_TYPE);
    req.user_id = m_uid;
    req.type = 1;
    req.platform_id = m_platformid;
    req.oppostion_id = m_tid;
    memcpy(req.token,[m_token UTF8String],TOKEN_LEN);
    [self sendData:&req len:req.packet_head.packet_length];
    
}

- (void)login
{
    struct UserLogin logininfo;
    memset(&logininfo, 0, USER_LOGIN_SIZE);
    INIT_PACK_HEAD(logininfo.packet_head,USER_LOGIN_SIZE,USER_LOGIN,USER_TYPE);
    logininfo.device = 0;
    logininfo.net_type = 0;
    logininfo.platform_id = m_platformid;
    logininfo.user_id = m_uid;
    logininfo.user_type = 1;
    memcpy(logininfo.token,[m_token UTF8String],TOKEN_LEN);
    [self sendData:&logininfo len:logininfo.packet_head.packet_length];
}
- (void)quitLogin
{
    struct UserQuit info;
    memset(&info, 0, USER_QUIT_LOGIN_SIZE);
    INIT_PACK_HEAD(info.packet_head,USER_QUIT_LOGIN_SIZE,USER_QUIT,USER_TYPE);
    info.platform_id = m_platformid;
    info.session = m_session;
    info.user_id = m_uid;
    memcpy(info.token,[m_token UTF8String],TOKEN_LEN);
    [self sendData:&info len:info.packet_head.packet_length];
}

- (void)  sendChatMsg:(NSString*) content
{
    struct TextChatPrivateSend info;
    memset(&info, 0, sizeof(info));
    NSData* dataContent = [content dataUsingEncoding:NSUTF8StringEncoding];
    INIT_PACK_HEAD(info.packet_head,dataContent.length + sizeof(info),TEXT_CHAT_PRIVATE_SEND,CHAT_TYPE);
    info.platform_id = m_platformid;
    info.send_user_id = m_uid;
    info.recv_user_id = m_tid;
    info.session = m_session;
    memcpy(info.token,[m_token UTF8String],TOKEN_LEN);
    NSMutableData* data = [NSMutableData dataWithBytes:(char*)&info length:sizeof(info)];
    [data appendData:dataContent];
    [self sendData:data];
    [self onChatMsg:content
             fid:info.send_user_id
             tid:info.recv_user_id
           msgid:0];

}
-(void) replyChatPrivate:(ino64_t) msg_id
{
    struct ReplyChatPrivate info;
    memset(&info, 0, sizeof(info));
    INIT_PACK_HEAD(info.packet_head,sizeof(info),PACKET_CONFIRM,CHAT_TYPE);
    info.msg_id = msg_id;
    info.platform_id = m_platformid;
    info.send_user_id = m_uid;
    info.recv_user_id = m_tid;
    info.session = m_session;
    memcpy(info.token,[m_token UTF8String],TOKEN_LEN);
    [self sendData:&info len:sizeof(info)];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port;
{
    [sock readDataWithTimeout:-1 tag:0];
    // NSLog(@"login");
    [self login];
}

- (void) onPacket:(const struct PacketHead*) pHead
{
    switch ( pHead->operate_code) {
        case USER_LOGIN_SUCESS:
            [self onLoginSucess:pHead];
            break;
        case USER_LOGIN_FAILED:
            [self onFailed:pHead];
            break;
        case TEXT_CHAT_PRIVATE_RECV:
            [self onRecvChatMsg:pHead];
            break;
        case USER_NOTIFICATION_QUIT:
            [self onQuit:pHead];
            break;
        case HEART_PACKET:
            [self onHeart:pHead];
            break;
        case GET_OPPOSITION_INFO:
            [self onOppositionInfo:pHead];
            break;
        default:
            break;
    }
}

-(void) onQuit:(const void*) pData
{
    struct UserQuitNotification * pInfo = (struct UserQuitNotification*)pData;
    // NSLog(@"onQuit platform_id:%lld user_id:%lld",pInfo->platform_id,pInfo->user_id);
}

-(void) onOppositionInfo:(const void*) pData
{
    [self getHiscChat];
    
    struct OppositionInfo* pInfo = (struct OppositionInfo*)pData;
    m_session =  pInfo->session;
    NSInteger last = pInfo->packet_head.packet_length - OPPSITIONINFO_SIZE ;
    uint8_t*  pBuffer = (( uint8_t* )pData + OPPSITIONINFO_SIZE);
    struct Oppinfo* pOppinfo = NULL;
    while ( last >=  OPPINFO_SIZE )
    {
        pOppinfo = (struct Oppinfo*)pBuffer;
        ChatUserInfo* info = [[ChatUserInfo alloc] init];
        info.uid = pOppinfo->user_id;
        info.nicknumber = pOppinfo->user_nicknumber;
        info.nickname = [NSString stringWithUTF8String:pOppinfo->nickname];
        info.picurl = [NSString stringWithUTF8String:pOppinfo->user_head];
        @synchronized(self)
        {
            [m_dicuserinfos setObject:info forKey:[NSString stringWithFormat:@"%lld",pInfo->oppo_id]];
            [ChatNotificationCenter postNotification:CHATSERVER_ONTUSERINFO obj:info];
        }

        last -= OPPINFO_SIZE;
        pBuffer += OPPINFO_SIZE;
    }
}

-(void) onHeart:(const void*) pData
{
    struct PacketHead* pHead = (struct PacketHead*)pData;
    [self sendData:pHead len:pHead->packet_length ];
}

-(void)  onChatMsg:(NSString*) msg fid:(int64_t) fid tid:(int64_t) tid msgid:(int16_t) msgid
{
    if( self.delegate != nil)
    {
        ChatMsg* chatMsg = [[ChatMsg alloc] init:msg send_id:fid recv_id:tid msg_id:msgid];
        chatMsg.iscurrentusersend = (fid == m_uid);
        [self bindSendUserInfo:chatMsg];
        [self.delegate onChatMsg:chatMsg];
    }

}
- (void) onRecvChatMsg:(const void*) pData
{
    struct TextChatPrivateRecv* pInfo = (struct TextChatPrivateRecv* )pData;
    [self replyChatPrivate:pInfo->packet_head.msg_id];
    NSString* content = [self getLastPackString:pData pos:sizeof(int64_t)*3];
    [self onChatMsg:content
                     fid:pInfo->send_user_id
                     tid:pInfo->recv_user_id
                   msgid:pInfo->packet_head.msg_id];
   
    
    
}

- (void) onHiscChat:(NSArray*) data
{
    if( self.delegate != nil )
    {
        NSMutableArray* array =[[NSMutableArray alloc] init];
        ChatMsg* chatMsg = nil;
        for (NSInteger i = data.count - 1 ; i  >= 0 ; --i) {
            chatMsg = [[ChatMsg alloc] init:data [i]];
            chatMsg.iscurrentusersend = chatMsg.send_user_id == m_uid;
            [self bindSendUserInfo:chatMsg];
            [array addObject:chatMsg];
        }
        [self.delegate onHiscChatMsg:array];
    }
}


- (void) onLoginSucess:(const void*) pData
{
    const struct UserLoginSucess* pInfo = (struct UserLoginSucess* )pData;
    // NSLog(@"onLoginSucess ");
    ChatUserInfo* info = [[ChatUserInfo alloc] init];
    info.uid = pInfo->user_id;
    info.nicknumber = pInfo->nick_number;
    info.nickname = [NSString stringWithUTF8String:pInfo->nickname];
    info.picurl = [NSString stringWithUTF8String:pInfo->head_url];
     @synchronized(self)
    {
        [m_dicuserinfos setObject:info forKey:[NSString stringWithFormat:@"%lld",pInfo->user_id]];
    }

    [self requestTUserInfo];
}


- (void) onFailed:(const void*) pData
{
    NSString *msg = [self getLastPackString:pData pos:sizeof(uint64_t)];
    //NSLog(@"onFailed  %@",msg);
    if( self.delegate != nil )
        [self.delegate onError:msg];
}




- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if( m_recvdata == nil /*|| m_recvdata.length == 0 */
        )
    {
        m_recvdata = [NSMutableData dataWithData:data];
    }
    else
        [m_recvdata appendData:data];
    
    while ( m_recvdata != nil && m_recvdata.length > PACKET_HEAD_LENGTH) {
        
        struct PacketHead* pHead = (struct PacketHead*)[m_recvdata bytes];
        
        if( m_recvdata.length < pHead->packet_length )
            break;
        
        [self onPacket:pHead];
        
        if ( m_recvdata.length >  pHead->packet_length) {
            NSData* lastData = [m_recvdata subdataWithRange:NSMakeRange(pHead->packet_length,m_recvdata.length-pHead->packet_length)];
            [m_recvdata setData:lastData];
        }
        else
            [m_recvdata setLength:0];
    }
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    if( self.delegate != nil && err != nil)
        [self.delegate onError:err.description];
}
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    //NSLog(@"onSocketDidDisconnect ");
}
- (void)onSocket:(AsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
     
}
@end
