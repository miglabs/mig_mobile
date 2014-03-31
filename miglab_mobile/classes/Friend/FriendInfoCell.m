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

-(void)updateFriendInfoCellData:(NearbyUser*)user {
    _userinfo = user;
    
    _lblNickName.text = _userinfo.nickname;
    
    _btnAvatar.imageURL = [NSURL URLWithString:_userinfo.headurl];
    _btnAvatar.layer.cornerRadius = _btnAvatar.frame.size.width / 2;
    _btnAvatar.layer.masksToBounds = YES;
    _btnAvatar.layer.borderWidth = AVATAR_BORDER_WIDTH;
    _btnAvatar.layer.borderColor = AVATAR_BORDER_COLOR;
    
    if (!_userinfo.songname) {
        
        _lblUserInfo.text = [NSString stringWithFormat:@"%.2f km", (float)_userinfo.distance/1000.0f];
    }
    else {
        
        _lblUserInfo.text = [NSString stringWithFormat:@"%.2f km | 正在听 - %@", (float)_userinfo.distance/1000.0f, _userinfo.songname];
    }
    
    if ([_userinfo.sex isEqualToString:STR_FEMALE]) {
        
        _genderImageView.image = [UIImage imageNamed:@"user_gender_female"];
    }
    else {
        
        _genderImageView.image = [UIImage imageNamed:@"user_gender_male"];
    }
    
    NSString* plat = _userinfo.plat;
    
    if ([plat isEqualToString:STR_USER_SOURCE_SINA]) {
        
        _userSourceImageView.image = [UIImage imageNamed:@"sina_tip"];
    }
    else if([plat isEqualToString:STR_USER_SOURCE_QQ]) {
        
        _userSourceImageView.image = [UIImage imageNamed:@"tencent_tip"];
    }
    else if([plat isEqualToString:STR_USER_SOURCE_DOUBAN]) {
        
        _userSourceImageView.image = [UIImage imageNamed:@"douban_tip"];
    }
    else {
        
        _userSourceImageView.hidden = YES;
    }
}

@end
