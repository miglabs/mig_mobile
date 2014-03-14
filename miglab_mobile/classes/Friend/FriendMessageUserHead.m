//
//  FriendMessageUserHead.m
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendMessageUserHead.h"
#import "NSString+PStringCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation FriendMessageUserHead

@synthesize userinfo = _userinfo;
@synthesize lblListening = _lblListening;
@synthesize btnAvatar = _btnAvatar;
@synthesize lblNickName = _lblNickName;
@synthesize lblUserInfo = _lblUserInfo;
@synthesize btnSay = _btnSay;
@synthesize btnSendSong = _btnSendSong;
@synthesize isFriend = _isFriend;
@synthesize imgSex = _imgSex;
@synthesize lblDistance = _lblDistance;

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
    
    CGSize nameSize = [_lblNickName.text sizeWithFont:_lblNickName.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGRect nameRect = [_lblNickName frame];
    
    CGRect sexImgRect = CGRectMake(nameRect.origin.x + nameSize.width + 8, 37, 12, 12);
    [_imgSex setFrame:sexImgRect];
    
    if ([_userinfo.sex isEqualToString:STR_MALE]) {
        
        _imgSex.image = [UIImage imageNamed:@"user_gender_male"];
    }
    else {
        
        _imgSex.image = [UIImage imageNamed:@"user_gender_female"];
    }
    
    _btnAvatar.imageURL = [NSURL URLWithString:_userinfo.headurl];
    _btnAvatar.layer.cornerRadius = _btnAvatar.frame.size.width / 2;
    _btnAvatar.layer.masksToBounds = YES;
    
    //初始化个人信息
    NSArray* birthday = [_userinfo.birthday componentsSeparatedByString:@"-"];

    if ([birthday count] == 3) {
        
        NSString* szYear = [birthday objectAtIndex:0];
        NSString* szMonth = [birthday objectAtIndex:1];
        NSString* szDay = [birthday objectAtIndex:2];
        
        int year = [szYear intValue];
        int month = [szMonth intValue];
        int day = [szDay intValue];
        
        NSDate* now = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
        NSDateComponents *dd = [cal components:unitFlags fromDate:now];
        int nowyear = [dd year];
        
        int age = nowyear - year;
        NSString* Constellation = [NSString getConstellation:month day:day];
        
        _lblUserInfo.text = [NSString stringWithFormat:@"%d岁  %@座", age, Constellation];
    }
    else {
        
        _lblUserInfo.text = @"未找到生日信息";
    }
    
    if (!_userinfo.songname) {
        
        _lblListening.text = @"未开启音乐之旅";
    }
    else {
        
        _lblListening.text = [NSString stringWithFormat:@"正在听-%@", _userinfo.songname];
    }
    
    [_btnSendSong setBackgroundImage:[UIImage imageNamed:@"friend_button_recommend.png"] forState:UIControlStateNormal];
    if (_isFriend) {
        
        [_btnSay setBackgroundImage:[UIImage imageNamed:@"friend_message_replay.png"] forState:UIControlStateNormal];
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
