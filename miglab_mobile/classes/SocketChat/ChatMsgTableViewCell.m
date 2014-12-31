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
#import "MigLabConfig.h"

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
    [self.sendNickLabelR setTextColor:[UIColor clearColor]];
    //[self.sendIconViewR initWithPlaceholderImage:[UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE]];
    //[self.sendIconViewL initWithPlaceholderImage:[UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE]];
    self.sendIconViewL.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE];
    self.sendIconViewR.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE];
    //CGFloat radius = [self.sendIconViewR frame].size.width/2;
    //修改为方头像
    CGFloat radius = 0;
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
    
    //初始化昵称样式
    [self.sendNickLabelR setTextColor:RGB(132,132,132,1)];
    //设置时间显示样式
    [self.sendTimeLabel setBackgroundColor:RGB(209, 209, 209, 1)];
    [self.sendTimeLabel setTextColor:RGB(255, 255, 255, 1)];

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
    UIImage* bgImage = [[UIImage imageNamed:@"chat_msg_bt_t2"]
                        resizableImageWithCapInsets:UIEdgeInsetsMake( 30, 5, 5, 30 )];
    [self refreshMsg:msg headPic:self.sendIconViewR msgFrame:msgFrame bgFrame:bgFrame bgImage:bgImage IsSelf:YES];
}

-(void) refreshMsg:(ChatMsg *)msg headPic:(EGOImageView*)headPic msgFrame:(CGRect) msgFrame bgFrame:(CGRect) bgFrame bgImage:(UIImage*) bgImage IsSelf:(BOOL)isself;
{
    [self.messageView setFrame:msgFrame];
    [self.msgBgView setFrame:bgFrame];
    //[self.msgBgView setBackgroundColor:RGB(255, 255, 255, 1)];
    [self.msgBgView setBackgroundColor:[UIColor clearColor]];
    [self.msgBgView setImage:bgImage];
    [self.sendTimeLabel setText:[msg msg_time]];
    
    BOOL isNeedShowTime = msg.isNeedShowTime;
    if (isNeedShowTime) {
        
        [self.sendTimeLabel setHidden:NO];
        [self.sendTimeLabel setText:[msg timeInterval]];
        self.sendTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    else {
        
        [self.sendTimeLabel setHidden:YES];
    }
    
    //NSString *nickName = msg.send_nickname;
    NSString *headurl;
    
    
    if (isself) {
        
        // 右边 //判断是否已经登录
        if(msg.send_user_info.isLogin==true){
            [self.sendNickLabelR setText:msg.send_user_info.nickname];
            self.sendIconViewR.imageURL = [NSURL URLWithString:msg.send_user_info.picurl];
            headurl = msg.send_user_info.picurl;
        }else{
            [self.sendNickLabelR setText:msg.send_nickname];
             self.sendIconViewR.imageURL = [NSURL URLWithString:msg.send_head_url];
            headurl = msg.send_head_url;
        }
        self.sendNickLabelR.textAlignment = NSTextAlignmentRight;
     
        
        [self.sendIconViewR setHidden:NO];
        [self.sendIconViewL setHidden:YES];
    }
    else {
        
        // 左边
        if (msg.send_nickname!=nil)
            [self.sendNickLabelR setText:msg.send_nickname];
        else
            [self.sendNickLabelR setText:msg.send_user_info.nickname];
        self.sendNickLabelR.textAlignment = NSTextAlignmentLeft;
        if (msg.send_head_url) {
            self.sendIconViewL.imageURL = [NSURL URLWithString:msg.send_head_url];
            headurl = msg.send_head_url;
        }else{
            self.sendIconViewL.imageURL = [NSURL URLWithString:msg.send_user_info.picurl];
            headurl = msg.send_user_info.picurl;
        }
        [self.sendIconViewL setHidden:NO];
        [self.sendIconViewR setHidden:YES];
    }
    
    //[self.sendIconViewL setImage:nil];
    //[self.sendIconViewR setImage:nil];
    
    //[headPic setImageURL:[NSURL URLWithString:[[msg send_user_info] picurl]]];
    [headPic setImageURL:[NSURL URLWithString:headurl]];

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

    UIImage* bgImage = [[UIImage imageNamed:@"chat_msg_bt_f2"]
                      resizableImageWithCapInsets:UIEdgeInsetsMake( 30, 5, 5, 5 )];
    //UIImage* bgImage = [[UIImage imageNamed:@""]
      //                  resizableImageWithCapInsets:UIEdgeInsetsMake( 30, 5, 5, 5 )];
   
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

-(void)headUserInfo{
    PLog(@"headUserInfo");
}
@end
