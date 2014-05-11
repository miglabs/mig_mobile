//
//  ChatContentView.h
//  miglab_chat
//
//  Created by 180 on 14-4-1.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatNetServiceDelegate.h"
#import "ChatMsgTableViewCell.h"
#import "ChatNotification.h"
#import "EGORefreshTableHeaderView.h"
#import "SVProgressHUD.h"
@interface ChatMsgContentView : UIView<UITableViewDataSource,
                                    UITableViewDelegate,
                                    ChatNetServiceDelegate,
                                    ChatNotificationDelegate,
                                    EGORefreshTableHeaderDelegate>



@property (strong, nonatomic) UINib *cellNib;
@property (strong, nonatomic) IBOutlet ChatMsgTableViewCell *customCell;
@end
