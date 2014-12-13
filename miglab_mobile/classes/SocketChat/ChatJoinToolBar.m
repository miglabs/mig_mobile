//
//  ChatJoinToolBar.m
//  miglab_mobile
//
//  Created by kerry on 14/12/12.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "ChatJoinToolBar.h"
#define kFaceBoardBarHeight 216
#import "ChatDef.h"
#import "ChatNotification.h"
@interface CharJoinToolBar ()
{
    ChatNotificationCenter      *m_chatNotification;
    UIButton                    *m_joinButton;
    UILabel                     *m_joinUILabel;
    UIImageView                 *m_bg;
}
@end

@implementation CharJoinToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        m_bg = [[UIImageView alloc] initWithImage:
                           [UIImage imageNamed:@""]];
        m_bg.frame = CGRectMake(0, 0, frame.size.width, frame.size.height + 2);
        [self addSubview:m_bg];
        
        UIImage* joinImage = [UIImage imageNamed:@"intalk_ico"];
        m_joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSInteger height = frame.size.height - 30;
        NSInteger width =joinImage.size.width * height/joinImage.size.height;
        
        m_joinButton.frame = CGRectMake(frame.size.width/2 - joinImage.size.width,
                                        15, width, height);
        [m_joinButton setImage:joinImage forState:UIControlStateNormal];
        
        m_joinUILabel = [[UILabel alloc] init];
        m_joinUILabel.frame = CGRectMake(joinImage.size.width/2, 0, 140, 21);
        m_joinUILabel.backgroundColor = [UIColor clearColor];
        m_joinUILabel.font = [UIFont systemFontOfSize:16.0f];
        m_joinUILabel.text = @"加入讨论";
        m_joinUILabel.textAlignment = kTextAlignmentLeft;
        m_joinUILabel.textColor = [UIColor grayColor];
        [m_joinButton addTarget:self action:@selector(joinChat:) forControlEvents:UIControlEventTouchUpInside];
        
       [m_joinButton addSubview:m_joinUILabel];
        
        [self addSubview:m_joinButton];
    }
    return self;
}

-(void)dealloc
{
    m_chatNotification = nil;
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}

-(IBAction)joinChat:(id)sender{
    PLog(@"joinChat");
    //通知主界面切换
    @synchronized(self)
    {
        [ChatNotificationCenter postNotification:CHATSERVER_JOIN obj:nil];
    }
}

@end
