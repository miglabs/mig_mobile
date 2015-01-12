//
//  ChatMsgTableViewCell.h
//  miglab_chat
//
//  Created by 180 on 14-4-2.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageView.h"
#import "ChatEntity.h"
#import "EGOImageView.h"
#import "MsgTextView.h"
#import "ChatDef.h"
#ifdef NEW_MSGVIEW
#import "MsgTextViewDelegate.h"
@interface ChatMsgTableViewCell : UITableViewCell<MsgTextViewDelegate>
#else
@interface ChatMsgTableViewCell : UITableViewCell
#endif

@property (nonatomic, retain) UIViewController *topViewcontroller; // 导航指针

@property (nonatomic, retain) IBOutlet EGOImageView *sendIconViewL;

@property (nonatomic, retain) IBOutlet EGOImageView *sendIconViewR;

@property (nonatomic, retain) IBOutlet UILabel *sendTimeLabel;

@property (nonatomic, retain) IBOutlet UILabel *sendNickLabelR;

@property (nonatomic, retain) IBOutlet UIImageView *msgBgView;
#ifdef NEW_MSGVIEW
@property (nonatomic, retain) IBOutlet MsgTextView *messageView;
#else
@property (nonatomic, retain) IBOutlet ChatMessageView *messageView;
#endif


-(void) refreshMsg:(ChatMsg*) msg withSize:(CGSize)size;
@end
