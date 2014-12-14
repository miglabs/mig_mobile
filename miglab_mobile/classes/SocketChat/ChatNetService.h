//
//  ChatNetService.h
//  ChatDemo
//
//  Created by 180 on 14-3-30.
//
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "ChatNetServiceDelegate.h"
#import "ChatEntity.h"
#import "MigLabAPI.h"
#import "SVProgressHUD.h"
@interface ChatNetService : NSObject <AsyncSocketDelegate>

@property (nonatomic, assign) id<ChatNetServiceDelegate> delegate;


//新版本改变加载方式，先获取聊天记录和服务器地址在进行聊天
//单聊
-(id) init:(NSString*) token name:(NSString*) name uid:(int64_t)uid
       tid: (int64_t) tid;

//群聊
-(id) init:(NSString*) token name:(NSString*) name uid:(int64_t)uid
       gid: (int64_t) gid;


- (id) init:(NSString*) token uid:(int64_t)uid
             tid: (int64_t) tid;


- (void) loginChat;

- (void) sendChatMsg:(NSString*) content;

-(void) bindSendUserInfo:(ChatMsg*) msg;
-(void) reloadHiscChat:(int64_t) minmsgid;
@end
