//
//  FriendInfoCell.m
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendInfoCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation FriendInfoCell

@synthesize btnAvatar = _btnAvatar;
@synthesize lblNickName = _lblNickName;
@synthesize lblUserInfo = _lblUserInfo;
@synthesize genderImageView = _genderImageView;
@synthesize userSourceImageView = _userSourceImageView;
@synthesize userinfo = _userinfo;
@synthesize poi = _poi;
@synthesize song = _song;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)updateFriendInfoCellData:(MessageInfo*)msg {
    _userinfo = msg.userInfo;
    _song = msg.song;
    _poi = msg.poi;
    
    _lblNickName.text = _userinfo.nickname;
    
    _btnAvatar.placeholderImage = [UIImage imageNamed:LOCAL_DEFAULT_HEADER_IMAGE];
    if (_userinfo.headurl) {
        
        _btnAvatar.imageURL = [NSURL URLWithString:_userinfo.headurl];
    }
    _btnAvatar.layer.cornerRadius = _btnAvatar.frame.size.width / 2;
    _btnAvatar.layer.masksToBounds = YES;
    _btnAvatar.layer.borderWidth = AVATAR_BORDER_WIDTH;
    _btnAvatar.layer.borderColor = AVATAR_BORDER_COLOR;
    
    /* 显示状态 */
    NSString* disctance;
    NSString* songstatus;
    if (_poi.distance>0) {
        disctance = [NSString stringWithFormat:@"%.2f km", (float)_poi.distance/1000.0f];
    }else{
        disctance = [NSString stringWithFormat:@"未知距离"];
    }
    
    if (!_userinfo.songname) {
        
        songstatus = [NSString stringWithFormat:@"未开启音乐之旅"];
    }
    else {
        
        songstatus = [NSString stringWithFormat:@"正在听 - %@",_song.songname];
    }

    _lblUserInfo.text = [NSString stringWithFormat:@"%@ | %@",disctance,songstatus];
    /*if (!_userinfo.songname) {
        
        _lblUserInfo.text = [NSString stringWithFormat:@"%.2f km", (float)_poi.distance/1000.0f];
    }
    else {
        
        _lblUserInfo.text = [NSString stringWithFormat:@"%.2f km | 正在听 - %@", (float)_poi.distance/1000.0f, _song.songname];
    }*/
    
    /* 显示性别的图片 */
    if ([_userinfo.sex isEqual:STR_FEMALE]) {
        
        _genderImageView.image = [UIImage imageNamed:@"user_gender_female"];
    }
    else {
        
        _genderImageView.image = [UIImage imageNamed:@"user_gender_male"];
    }
    
    CGSize nameSize = [_lblNickName.text sizeWithFont:_lblNickName.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    CGRect nameRect = _lblNickName.frame;
    CGRect genderRect = _genderImageView.frame;
    genderRect.origin.x = nameRect.origin.x + nameSize.width + 5;
    _genderImageView.frame = genderRect;
    
    /* 显示用户来源 */
    NSString* plat = _userinfo.plat;
    if ([plat isEqual:STR_USER_SOURCE_SINA]) {
        
        _userSourceImageView.image = [UIImage imageNamed:@"sina_tip"];
    }
    else if([plat isEqual:STR_USER_SOURCE_QQ]) {
        
        _userSourceImageView.image = [UIImage imageNamed:@"tencent_tip"];
    }
    else if([plat isEqual:STR_USER_SOURCE_DOUBAN]) {
        
        _userSourceImageView.image = [UIImage imageNamed:@"douban_tip"];
    }
    else {
        
        //_userSourceImageView.hidden = YES;
        _userSourceImageView.image = [UIImage imageNamed:@"default_tip"];
    }
}

@end
