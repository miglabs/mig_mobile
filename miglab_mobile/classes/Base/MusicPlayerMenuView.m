//
//  MusicPlayerMenuView.m
//  miglab_mobile
//
//  Created by pig on 13-8-14.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicPlayerMenuView.h"

@implementation MusicPlayerMenuView

@synthesize menuBgImageView = _menuBgImageView;
@synthesize btnAvatar = _btnAvatar;
@synthesize lblSongInfo = _lblSongInfo;
@synthesize btnDelete = _btnDelete;
@synthesize btnCollect = _btnCollect;
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

-(id)initDefaultMenuView:(CGRect)frame{
    
    //CGRectMake(12, 0, 297, 73);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景图片
        _menuBgImageView = [[UIImageView alloc] init];
        _menuBgImageView.frame = CGRectMake(0, 0, 297, 73);
        UIImage *menuBgImage = [UIImage imageWithName:@"player_bg" type:@"png"];
        _menuBgImageView.image = menuBgImage;
        [self addSubview:_menuBgImageView];
        
        //avatar
        UIImage *avatarNorImage = [UIImage imageWithName:@"music_default_avatar" type:@"png"];
        _btnAvatar = [[EGOImageButton alloc] initWithPlaceholderImage:avatarNorImage];
        _btnAvatar.frame = CGRectMake(13, 9, 41, 41);
        _btnAvatar.layer.cornerRadius = 20;
        _btnAvatar.layer.masksToBounds = YES;
        _btnAvatar.layer.borderWidth = 2;
        _btnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        [_btnAvatar setImage:avatarNorImage forState:UIControlStateNormal];
        [self addSubview:_btnAvatar];
        
        //song info
        _lblSongInfo = [[UILabel alloc] init];
        _lblSongInfo.frame = CGRectMake(10, 50, 177, 21);
        _lblSongInfo.backgroundColor = [UIColor clearColor];
        _lblSongInfo.textColor = [UIColor whiteColor];
        _lblSongInfo.textAlignment = kTextAlignmentLeft;
        _lblSongInfo.text = @"name-artist";
//        _lblSongInfo.font = [UIFont fontName:@"MicrosoftYaHei" size:10.0f];
//        _lblSongInfo.font = [UIFont fontName:@"STHeitiTC-Light" size:10.0f];
        _lblSongInfo.font = [UIFont fontName:@"STHeitiTC-Medium" size:10.0f];
        [self addSubview:_lblSongInfo];
        
        //delete
        _btnDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnDelete.frame = CGRectMake(92, 15, 44, 44);
        UIImage *removeNorImage = [UIImage imageWithName:@"music_menu_delete_nor" type:@"png"];
        UIImage *removeSelImage = [UIImage imageWithName:@"music_menu_delete_sel" type:@"png"];
        [_btnDelete setImage:removeNorImage forState:UIControlStateNormal];
//        [_btnDelete setImage:removeSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnDelete];
        
        //collect
        _btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCollect.frame = CGRectMake(146, 15, 44, 44);
        UIImage *likeNorImage = [UIImage imageWithName:@"music_menu_dark_heart_nor" type:@"png"];
        UIImage *likeSelImage = [UIImage imageWithName:@"music_menu_dark_heart_sel" type:@"png"];
        [_btnCollect setImage:likeNorImage forState:UIControlStateNormal];
//        [_btnCollect setImage:likeSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnCollect];
        
        //播放、暂停
        _btnPlayOrPause = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlayOrPause.frame = CGRectMake(198, 15, 44, 44);
        UIImage *playNorImage = [UIImage imageWithName:@"music_menu_play_nor" type:@"png"];
        UIImage *playSelImage = [UIImage imageWithName:@"music_menu_play_sel" type:@"png"];
        [_btnPlayOrPause setImage:playNorImage forState:UIControlStateNormal];
//        [_btnPlayOrPause setImage:playSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnPlayOrPause];
        
        //下一首
        _btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNext.frame = CGRectMake(248, 15, 44, 44);
        UIImage *nextNorImage = [UIImage imageWithName:@"music_menu_next_nor" type:@"png"];
        UIImage *nextSelImage = [UIImage imageWithName:@"music_menu_next_sel" type:@"png"];
        [_btnNext setImage:nextNorImage forState:UIControlStateNormal];
//        [_btnNext setImage:nextSelImage forState:UIControlStateHighlighted];
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
