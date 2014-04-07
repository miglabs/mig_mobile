//
//  ChatMsgTableViewCell.m
//  miglab_chat
//
//  Created by 180 on 14-4-2.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "ChatMsgTableViewCell.h"



@implementation ChatMsgTableViewCell



- (void)refreshUMsg:(ChatMsg*) msg withSize:(CGSize)size {
    
    if ( msg.send_user_info != nil) {
        //self.sendIconViewR.image = [UIImage imageNamed:msg.send_user_info.picurl];
        self.sendIconViewR.imageURL =  [NSURL URLWithString:msg.send_user_info.picurl];
        self.sendIconViewR.layer.cornerRadius = self.sendIconViewR.frame.size.width / 2;
        self.sendIconViewR.layer.masksToBounds = YES;
        //self.sendIconViewR.layer.borderWidth = AVATAR_BORDER_WIDTH;
        //self.sendIconViewR.layer.borderColor = AVATAR_BORDER_COLOR;
    }
    
    
    self.sendIconViewL.image = nil;
    self.sendTimeLabel.text = msg.msg_time;
    self.sendTimeLabel.textColor = [UIColor whiteColor];
    
    CGRect frame = self.messageView.frame;
    frame.origin.x = MSG_VIEW_RIGHT - size.width;
    frame.size = size;
    self.messageView.frame = frame;
    
    self.msgBgView.frame = self.messageView.frame;
    self.msgBgView.image = [[UIImage imageNamed:@"chat_msg_bt_t"]
                       resizableImageWithCapInsets:UIEdgeInsetsMake( 30, 5, 5, 30 )];
    
    [self.messageView showMessage:[msg getMsg]];
}


- (void)refreshTMsg:(ChatMsg*) msg withSize:(CGSize)size {
    
    if ( msg.send_user_info != nil) {
        //self.sendIconViewL.image = [UIImage imageNamed:msg.send_user_info.picurl];
        self.sendIconViewL.imageURL =  [NSURL URLWithString:msg.send_user_info.picurl];
        self.sendIconViewL.layer.cornerRadius = self.sendIconViewR.frame.size.width / 2;
        self.sendIconViewL.layer.masksToBounds = YES;
        //self.sendIconViewR.layer.borderWidth = AVATAR_BORDER_WIDTH;
        //self.sendIconViewR.layer.borderColor = AVATAR_BORDER_COLOR;
    }
    self.sendTimeLabel.text = msg.msg_time;;
    self.sendTimeLabel.textColor = [UIColor whiteColor];
    self.sendIconViewR.image = nil;
    
    CGRect frame = self.messageView.frame;
    frame.origin.x = MSG_VIEW_LEFT;
    frame.size = size;
    self.messageView.frame = frame;
    
    self.msgBgView.frame = self.messageView.frame;
    self.msgBgView.image = [[UIImage imageNamed:@"chat_msg_bt_f"]
                       resizableImageWithCapInsets:UIEdgeInsetsMake( 30, 5, 5, 5 )];
    
    [self.messageView showMessage:[msg getMsg]];
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
   
    if ( msg.iscurrentusersend ) {
        [self refreshUMsg:msg withSize:size];
    }
    else
        [self refreshTMsg:msg withSize:size];
    
    
        //
}
@end
