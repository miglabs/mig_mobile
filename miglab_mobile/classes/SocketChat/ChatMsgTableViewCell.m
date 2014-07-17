//
//  ChatMsgTableViewCell.m
//  miglab_chat
//
//  Created by 180 on 14-4-2.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "ChatMsgTableViewCell.h"
#import "MsgTextURLRun.h"
#import "ChatNotification.h"

@implementation ChatMsgTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void) initialize
{
    self.sendTimeLabel.textColor = [UIColor whiteColor];
    self.sendIconViewR.layer.cornerRadius = self.sendIconViewR.frame.size.width / 2;
    self.sendIconViewR.layer.masksToBounds = YES;
#ifdef NEW_MSGVIEW
    self.messageView.font        = [UIFont systemFontOfSize:16.0f];
    self.messageView.textColor   = [UIColor whiteColor];
    self.messageView.lineSpace   = 2.0f;
    self.messageView.delegage = self;
#endif

}

- (void)refreshUMsg:(ChatMsg*) msg withSize:(CGSize)size {
    
    if ( msg.send_user_info != nil) {
        [self setIconView:self.sendIconViewR imgUrl:msg.send_user_info.picurl];
    }
    self.sendIconViewL.image = nil;
    self.sendTimeLabel.text = msg.msg_time;
    
    CGRect frame = self.messageView.frame;
    frame.origin.x = MSG_VIEW_RIGHT - size.width;
    frame.size = size;
    self.messageView.frame = frame;
    
    self.msgBgView.frame = self.messageView.frame;
    self.msgBgView.image = [[UIImage imageNamed:@"chat_msg_bt_t"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake( 30, 5, 5, 30 )];
    
#ifdef NEW_MSGVIEW
    frame.origin.x -= VIEW_LEFT ;
    frame.origin.y += VIEW_TOP;
    self.messageView.frame = frame;
    frame.origin.x -= VIEW_RIGHT ;
    frame.origin.y -= VIEW_TOP;
    frame.size.width += VIEW_LEFT+VIEW_RIGHT;
    self.msgBgView.frame = frame;
    self.messageView.text = msg.msg_content;
#else
    [self.messageView showMessage:[msg getMsg]];
#endif
}

-(void) setIconView:(EGOImageView*) view imgUrl:(NSString*) url
{
    if( view != nil)
    {
        view.imageURL =  [NSURL URLWithString:url];
    }
}

- (void)refreshTMsg:(ChatMsg*) msg withSize:(CGSize)size {
    
    if ( msg.send_user_info != nil) {
        [self setIconView:self.sendIconViewL imgUrl:msg.send_user_info.picurl];
    }
    self.sendTimeLabel.text = msg.msg_time;
    self.sendIconViewR.image = nil;
    
    CGRect frame = self.messageView.frame;
    frame.origin.x = MSG_VIEW_LEFT;
    frame.size = size;
    self.messageView.frame = frame;
    
    self.msgBgView.frame = self.messageView.frame;
    self.msgBgView.image = [[UIImage imageNamed:@"chat_msg_bt_f"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake( 30, 5, 5, 5 )];
    
#ifdef NEW_MSGVIEW
    frame.origin.x += VIEW_LEFT ;
    frame.origin.y += VIEW_TOP;
    self.messageView.frame = frame;
    frame.origin.x -= VIEW_LEFT ;
    frame.origin.y -= VIEW_TOP;
    frame.size.width += VIEW_LEFT+VIEW_RIGHT;
    self.msgBgView.frame = frame;
    self.messageView.text = msg.msg_content;
#else
    [self.messageView showMessage:[msg getMsg]];
#endif
    
}


- (void)dealloc {
    
    self.sendIconViewL  = nil;
    self.sendIconViewR = nil ;
    
    self.sendTimeLabel = nil;
    
    self.messageView = nil;
    
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}

-(void) refreshMsg:(ChatMsg*) msg withSize:(CGSize)size;
{
    [self initialize];
    if ( msg.iscurrentusersend ) {
        [self refreshUMsg:msg withSize:size];
    }
    else
        [self refreshTMsg:msg withSize:size];
    //
}

#ifdef NEW_MSGVIEW
- (void)msgTextView:(MsgTextView *)view touchesEnded:(MsgTextRun *)msgText
{
    if ([msgText isKindOfClass:[MsgTextURLRun class]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:msgText.text]];
    }
}
#endif
@end
