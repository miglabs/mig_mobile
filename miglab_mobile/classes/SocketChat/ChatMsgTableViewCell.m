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
#import "UserSessionManager.h"

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
    [self.sendTimeLabel setTextColor:[UIColor whiteColor]];
    [self.sendNickLabelR setTextColor:[UIColor whiteColor]];
    //[self.sendIconViewR initWithPlaceholderImage:[UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE]];
    //[self.sendIconViewL initWithPlaceholderImage:[UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE]];
    self.sendIconViewL.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE];
    self.sendIconViewR.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE];
    CGFloat radius = [self.sendIconViewR frame].size.width/2;
    [[self.sendIconViewR layer] setCornerRadius:radius];
    [[self.sendIconViewL layer] setCornerRadius:radius];
    [[self.sendIconViewR layer] setMasksToBounds:YES];
    [[self.sendIconViewL layer] setMasksToBounds:YES];
#ifdef NEW_MSGVIEW
    self.messageView.font        = [UIFont systemFontOfSize:16.0f];
    self.messageView.textColor   = [UIColor blackColor];
    self.messageView.lineSpace   = 2.0f;
    self.messageView.delegage = self;
#endif

}

- (void)refreshUMsg:(ChatMsg*) msg withSize:(CGSize)size {
    
    
    CGRect msgFrame,bgFrame;
    
    msgFrame = [self.messageView frame];
    msgFrame.origin.x = MSG_VIEW_RIGHT - size.width;
    msgFrame.size = size;
    bgFrame = msgFrame;
    
#ifdef NEW_MSGVIEW
    msgFrame.origin.x -= VIEW_LEFT ;
    msgFrame.origin.y += VIEW_TOP;

    bgFrame.origin.x -= (VIEW_LEFT + VIEW_RIGHT);
    bgFrame.size.width += VIEW_LEFT+VIEW_RIGHT;
#endif
    UIImage* bgImage = [[UIImage imageNamed:@"chat_msg_bt_t"]
                        resizableImageWithCapInsets:UIEdgeInsetsMake( 30, 5, 5, 30 )];
    [self refreshMsg:msg headPic:self.sendIconViewR msgFrame:msgFrame bgFrame:bgFrame bgImage:bgImage IsSelf:YES];
}

-(void) refreshMsg:(ChatMsg *)msg headPic:(EGOImageView*)headPic msgFrame:(CGRect) msgFrame bgFrame:(CGRect) bgFrame bgImage:(UIImage*) bgImage IsSelf:(BOOL)isself;
{
    [self.messageView setFrame:msgFrame];
    [self.msgBgView setFrame:bgFrame];
    [self.msgBgView setImage:bgImage];
    //[self.sendTimeLabel setText:[msg msg_time]];
    
    BOOL isNeedShowTime = msg.isNeedShowTime;
    if (isNeedShowTime) {
        
        [self.sendTimeLabel setHidden:NO];
        [self.sendTimeLabel setText:msg.timeInterval];
        self.sendTimeLabel.textAlignment = NSTextAlignmentCenter;
        [self.sendTimeLabel setBackgroundColor:[UIColor darkGrayColor]];
    }
    else {
        
        [self.sendTimeLabel setHidden:YES];
    }
    
    NSString *nickName = msg.send_user_info.nickname;
    NSString *headurl = msg.send_user_info.picurl;
    nickName = @"色魔老K";
    headurl = @"http://face.miu.miyomate.com/system.jpg";
    
    [self.sendNickLabelR setText:nickName];
    if (isself) {
        
        // 右边
        self.sendNickLabelR.textAlignment = NSTextAlignmentRight;
        self.sendIconViewR.imageURL = [NSURL URLWithString:headurl];
        [self.sendIconViewR setHidden:NO];
        [self.sendIconViewL setHidden:YES];
    }
    else {
        
        // 左边
        self.sendNickLabelR.textAlignment = NSTextAlignmentLeft;
        self.sendIconViewL.imageURL = [NSURL URLWithString:headurl];
        [self.sendIconViewL setHidden:NO];
        [self.sendIconViewR setHidden:YES];
    }
    
    //[self.sendIconViewL setImage:nil];
    //[self.sendIconViewR setImage:nil];
    [headPic setImageURL:[NSURL URLWithString:[[msg send_user_info] picurl]]];

#ifdef NEW_MSGVIEW
    [self.messageView setText:[msg msg_content]];
#else
    [self.messageView showMessage:[msg getMsg]];
#endif
}

- (void)refreshTMsg:(ChatMsg*) msg withSize:(CGSize)size {
    
    CGRect msgFrame,bgFrame ;
    msgFrame = [self.messageView frame];
    msgFrame.origin.x = MSG_VIEW_LEFT;
    msgFrame.size = size;
    bgFrame = msgFrame;
    
#ifdef NEW_MSGVIEW
    msgFrame.origin.x += VIEW_LEFT ;
    msgFrame.origin.y += VIEW_TOP;
    bgFrame.size.width += VIEW_LEFT+VIEW_RIGHT;
#endif
    
    UIImage* bgImage = [[UIImage imageNamed:@"chat_msg_bt_f"]
                        resizableImageWithCapInsets:UIEdgeInsetsMake( 30, 5, 5, 5 )];
   
    [self refreshMsg:msg headPic:self.sendIconViewL msgFrame:msgFrame bgFrame:bgFrame bgImage:bgImage IsSelf:NO];
    
}


- (void)dealloc {
    [self setSendIconViewL:nil];
    [self setSendIconViewR:nil];
    [self setSendTimeLabel:nil];
    [self setSendNickLabelR:nil];
    [self setMessageView:nil];
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
        NSString* url = [[msgText text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSError*  error = nil;
        NSString* regulaStr = @"^(http[s]{0,1}|ftp)://";
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        if (error == nil)
        {
            NSArray *arrayOfAllMatches = [regex matchesInString:url
                                                        options:0
                                                          range:NSMakeRange(0, [url length])];
            if( ! ( [arrayOfAllMatches count] > 0  ) )
                url = [NSString stringWithFormat:@"http://%@",url];
        }
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
#endif

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [ChatNotificationCenter postNotification:INPUTBOARD_CLOSE obj:nil];
}

@end
