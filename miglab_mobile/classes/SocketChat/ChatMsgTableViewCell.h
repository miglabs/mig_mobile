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
@interface ChatMsgTableViewCell : UITableViewCell


@property (nonatomic, retain) IBOutlet EGOImageView *sendIconViewL;

@property (nonatomic, retain) IBOutlet EGOImageView *sendIconViewR;

@property (nonatomic, retain) IBOutlet UILabel *sendTimeLabel;

@property (nonatomic, retain) IBOutlet UIImageView *msgBgView;

@property (nonatomic, retain) IBOutlet ChatMessageView *messageView;


-(void) refreshMsg:(ChatMsg*) msg withSize:(CGSize)size;
@end
