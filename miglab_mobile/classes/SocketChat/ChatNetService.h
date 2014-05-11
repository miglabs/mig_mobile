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
#import "SVProgressHUD.h"
@interface ChatNetService : NSObject <AsyncSocketDelegate>

@property (nonatomic, assign) id<ChatNetServiceDelegate> delegate;
- (id)   init:(NSString*) token uid:(int64_t)uid
             tid: (int64_t) tid;
- (void) sendChatMsg:(NSString*) content;

-(void) bindSendUserInfo:(ChatMsg*) msg;
-(void) reloadHiscChat:(int64_t) minmsgid;
@end
