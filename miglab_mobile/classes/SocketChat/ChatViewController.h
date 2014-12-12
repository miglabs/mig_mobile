//
//  ChatViewController.h
//  miglab_chat
//
//  Created by 180 on 14-4-1.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ChatNotification.h"
@interface ChatViewController : BaseViewController<ChatNotificationDelegate>
//新增单聊
//群聊
- (id)   init:(NSString*) token uid:(int64_t)uid
          tid: (int64_t) tid;

- (id)  init:(NSString*) token uid:(int64_t) uid  name:(NSString*) name
         tid: (int64_t) tid;
@end
