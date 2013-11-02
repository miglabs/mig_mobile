//
//  FriendMessageUserHead.m
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendMessageUserHead.h"

@implementation FriendMessageUserHead

@synthesize userinfo = _userinfo;
@synthesize lblListening = _lblListening;
@synthesize btnAvatar = _btnAvatar;
@synthesize lblNickName = _lblNickName;
@synthesize lblUserInfo = _lblUserInfo;
@synthesize btnSayHi = _btnSayHi;
@synthesize btnAddBlack = _btnAddBlack;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initFriendMessageUserHead {
    
    _lblNickName.text = _userinfo.nickname;
    _lblListening.text = _userinfo.songname;
    
    //TODO 初始化个人信息
    //_lblUserInfo.text = [NSString stringWithFormat:@"%@岁           %@km", ]
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
