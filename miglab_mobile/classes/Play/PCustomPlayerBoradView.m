//
//  PCustomPlayerBoradView.m
//  miglab_mobile
//
//  Created by pig on 13-7-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomPlayerBoradView.h"
#import "UIImage+PImageCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation PCustomPlayerBoradView

@synthesize playerBoradBgImageView = _playerBoradBgImageView;
@synthesize btnAvatar = _btnAvatar;
@synthesize lblSongName = _lblSongName;
@synthesize lblArtist = _lblArtist;
@synthesize btnRemove = _btnRemove;
@synthesize btnLike = _btnLike;
@synthesize btnPlayOrPause = _btnPlayOrPause;
@synthesize btnNext = _btnNext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initPlayerBoradView:(CGRect)frame
{
    //CGRectMake(0, 0, 320, 90);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景图片
        _playerBoradBgImageView = [[UIImageView alloc] init];
        _playerBoradBgImageView.frame = CGRectMake(0, 0, 320, 60);
        UIImage *playerBoradBgImage = [UIImage imageWithName:@"player_borad_bg" type:@"png"];
        _playerBoradBgImageView.image = playerBoradBgImage;
        [self addSubview:_playerBoradBgImageView];
        
        
        UIImage *avatarNorImage = [UIImage imageWithName:@"borad_default_avatar" type:@"png"];
        _btnAvatar = [[EGOImageButton alloc] initWithPlaceholderImage:avatarNorImage];
        _btnAvatar.frame = CGRectMake(9, 10, 44, 44);
        _btnAvatar.layer.cornerRadius = 22;
        _btnAvatar.layer.masksToBounds = YES;
        _btnAvatar.layer.borderWidth = 2;
        _btnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        [_btnAvatar setImage:avatarNorImage forState:UIControlStateNormal];
        [self addSubview:_btnAvatar];
        
        _lblSongName = [[UILabel alloc] init];
        _lblSongName.frame = CGRectMake(56, 14, 79, 21);
        _lblSongName.backgroundColor = [UIColor clearColor];
        _lblSongName.textColor = [UIColor whiteColor];
        _lblSongName.textAlignment = kTextAlignmentLeft;
        _lblSongName.text = @"SongName";
        _lblSongName.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_lblSongName];
        
        _lblArtist = [[UILabel alloc] init];
        _lblArtist.frame = CGRectMake(56, 33, 79, 21);
        _lblArtist.backgroundColor = [UIColor clearColor];
        _lblArtist.textColor = [UIColor whiteColor];
        _lblArtist.textAlignment = kTextAlignmentLeft;
        _lblArtist.text = @"Artist";
        _lblArtist.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_lblArtist];
        
        //移除按钮
        _btnRemove = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRemove.frame = CGRectMake(136, 12, 44, 44);
        UIImage *removeNorImage = [UIImage imageWithName:@"borad_menu_delete_nor" type:@"png"];
        UIImage *removeSelImage = [UIImage imageWithName:@"borad_menu_delete_sel" type:@"png"];
        [_btnRemove setImage:removeNorImage forState:UIControlStateNormal];
        [_btnRemove setImage:removeSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnRemove];
        
        //喜欢
        _btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLike.frame = CGRectMake(182, 12, 44, 44);
        UIImage *likeNorImage = [UIImage imageWithName:@"borad_menu_light_heart_nor" type:@"png"];
        UIImage *likeSelImage = [UIImage imageWithName:@"borad_menu_light_heart_sel" type:@"png"];
        [_btnLike setImage:likeNorImage forState:UIControlStateNormal];
        [_btnLike setImage:likeSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnLike];
        
        //播放、暂停
        _btnPlayOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlayOrPause.frame = CGRectMake(228, 12, 44, 44);
        UIImage *playNorImage = [UIImage imageWithName:@"borad_menu_play_nor" type:@"png"];
        UIImage *playSelImage = [UIImage imageWithName:@"borad_menu_play_sel" type:@"png"];
        [_btnPlayOrPause setImage:playNorImage forState:UIControlStateNormal];
        [_btnPlayOrPause setImage:playSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnPlayOrPause];
        
        //下一首
        _btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNext.frame = CGRectMake(270, 12, 44, 44);
        UIImage *nextNorImage = [UIImage imageWithName:@"borad_menu_next_nor" type:@"png"];
        UIImage *nextSelImage = [UIImage imageWithName:@"borad_menu_next_sel" type:@"png"];
        [_btnNext setImage:nextNorImage forState:UIControlStateNormal];
        [_btnNext setImage:nextSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnNext];
        
        
    }
    
    return self;
}

-(id)initPlayerBoradMenuView:(CGRect)frame
{
    //CGRectMake(0, 0, 320, 90);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景图片
        _playerBoradBgImageView = [[UIImageView alloc] init];
        _playerBoradBgImageView.frame = CGRectMake(0, 0, 320, 60);
        UIImage *playerBoradBgImage = [UIImage imageWithName:@"player_borad_bg" type:@"png"];
        _playerBoradBgImageView.image = playerBoradBgImage;
        [self addSubview:_playerBoradBgImageView];
        
        
        UIImage *avatarNorImage = [UIImage imageWithName:@"borad_default_avatar" type:@"png"];
        _btnAvatar = [[EGOImageButton alloc] initWithPlaceholderImage:avatarNorImage];
        _btnAvatar.frame = CGRectMake(9, 10, 44, 44);
        _btnAvatar.layer.cornerRadius = 22;
        _btnAvatar.layer.masksToBounds = YES;
        _btnAvatar.layer.borderWidth = 2;
        _btnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        [_btnAvatar setImage:avatarNorImage forState:UIControlStateNormal];
        [self addSubview:_btnAvatar];
        
        _lblSongName = [[UILabel alloc] init];
        _lblSongName.frame = CGRectMake(56, 14, 79, 21);
        _lblSongName.backgroundColor = [UIColor clearColor];
        _lblSongName.textColor = [UIColor whiteColor];
        _lblSongName.textAlignment = kTextAlignmentLeft;
        _lblSongName.text = @"SongName";
        _lblSongName.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_lblSongName];
        
        _lblArtist = [[UILabel alloc] init];
        _lblArtist.frame = CGRectMake(56, 33, 79, 21);
        _lblArtist.backgroundColor = [UIColor clearColor];
        _lblArtist.textColor = [UIColor whiteColor];
        _lblArtist.textAlignment = kTextAlignmentLeft;
        _lblArtist.text = @"Artist";
        _lblArtist.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_lblArtist];
        
        //移除按钮
        _btnRemove = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRemove.frame = CGRectMake(148, 23, 20, 20);
        UIImage *removeNorImage = [UIImage imageWithName:@"borad_menu_delete_nor" type:@"png"];
        [_btnRemove setImage:removeNorImage forState:UIControlStateNormal];
        [self addSubview:_btnRemove];
        
        //喜欢
        _btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLike.frame = CGRectMake(193, 25, 22, 19);
        UIImage *likeNorImage = [UIImage imageWithName:@"borad_menu_like_nor" type:@"png"];
        UIImage *likeSelImage = [UIImage imageWithName:@"borad_menu_like_sel" type:@"png"];
        [_btnLike setImage:likeNorImage forState:UIControlStateNormal];
        [_btnLike setImage:likeSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnLike];
        
        //播放、暂停
        _btnPlayOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlayOrPause.frame = CGRectMake(243, 26, 15, 18);
        UIImage *playOrPauseImage = [UIImage imageWithName:@"borad_menu_play" type:@"png"];
        [_btnPlayOrPause setImage:playOrPauseImage forState:UIControlStateNormal];
        [self addSubview:_btnPlayOrPause];
        
        //下一首
        _btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNext.frame = CGRectMake(286, 26, 19, 17);
        UIImage *nextNorImage = [UIImage imageWithName:@"borad_menu_next" type:@"png"];
        [_btnNext setImage:nextNorImage forState:UIControlStateNormal];
        [self addSubview:_btnNext];
        
        
    }
    
    return self;
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
