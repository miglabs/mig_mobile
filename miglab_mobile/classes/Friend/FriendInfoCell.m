//
//  FriendInfoCell.m
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendInfoCell.h"

@implementation FriendInfoCell

@synthesize btnAvatar = _btnAvatar;
@synthesize lblNickName = _lblNickName;
@synthesize lblUserInfo = _lblUserInfo;
@synthesize genderImageView = _genderImageView;
@synthesize sinaTipImageView = _sinaTipImageView;
@synthesize tencentTipImageView = _tencentTipImageView;
@synthesize doubanTipImageView = _doubanTipImageView;
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
    
    if (!_userinfo.songname) {
        
        _lblUserInfo.text = [NSString stringWithFormat:@"%.2f km", (float)_userinfo.distance/1000];
    }
    else {
        
        _lblUserInfo.text = [NSString stringWithFormat:@"%.2f km | 正在听 - %@", (float)_userinfo.distance/1000, _userinfo.songname];
    }
    
    if ([_userinfo.sex isEqualToString:@"0"]) {
        
        _genderImageView.image = [UIImage imageNamed:@"user_gender_female"];
    }
    else {
        
        _genderImageView.image = [UIImage imageNamed:@"user_gender_male"];
    }
}

@end
