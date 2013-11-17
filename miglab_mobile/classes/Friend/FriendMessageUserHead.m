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
@synthesize btnSay = _btnSay;
@synthesize btnSendSong = _btnSendSong;
@synthesize isFriend = _isFriend;

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
    
    if (!_userinfo.songname) {
        
        _lblListening.text = @"未开启音乐之旅";
    }
    else {
        
        _lblListening.text = [NSString stringWithFormat:@"正在听-%@", _userinfo.songname];
    }
    
    [_btnSendSong setBackgroundImage:[UIImage imageNamed:@"friend_button_addblack.png"] forState:UIControlStateNormal];
    if (_isFriend) {
        
        [_btnSay setBackgroundImage:[UIImage imageNamed:@"friend_message_replay.pngfriend_button_sayhi.png"] forState:UIControlStateNormal];
    }
    else {
        
        [_btnSay setBackgroundImage:[UIImage imageNamed:@"friend_button_sayhi.png"] forState:UIControlStateNormal];
    }
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
