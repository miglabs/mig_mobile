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

-(void)updateFriendMessageUserHead:(NearbyUser*)user {
    _userinfo = user;
    
    _lblNickName.text = _userinfo.nickname;
    _lblListening.text = _userinfo.songname;
    
    //初始化个人信息
    if (_userinfo.distance < 1000.0) {
        
        _lblUserInfo.text = [NSString stringWithFormat:@"距离您有%.0fm", (float)_userinfo.distance];
    }
    else {
        
        _lblUserInfo.text = [NSString stringWithFormat:@"距离您有%.0fkm", _userinfo.distance/1000.0];
    }
    _lblListening.text = [NSString stringWithFormat:@"正在听-%@", _userinfo.songname];
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
