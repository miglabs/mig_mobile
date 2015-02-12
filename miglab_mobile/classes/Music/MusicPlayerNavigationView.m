//
//  MusicPlayerNavigationView.m
//  miglab_mobile
//
//  Created by pig on 13-8-14.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicPlayerNavigationView.h"
#import "UIImage+PImageCategory.h"
#import <QuartzCore/QuartzCore.h>

@implementation MusicPlayerNavigationView

@synthesize topBgImageView = _topBgImageView;
@synthesize btnAvatar = _btnAvatar;
@synthesize lblNickName = _lblNickName;
@synthesize btnFirstMenu = _btnFirstMenu;
@synthesize btnSecondMenu = _btnSecondMenu;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initMusicNavigationView:(CGRect)frame{
    
    //0,0,320,45
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //bg
        _topBgImageView = [[UIImageView alloc] init];
        _topBgImageView.frame = CGRectMake(0, 0, 320, 45);
        UIImage *topBgImage = [UIImage imageWithName:@"top_bg_0" type:@"jpg"];
        _topBgImageView.image = topBgImage;
        [self addSubview:_topBgImageView];
        
        //avatar
        UIImage *avatarNorImage = [UIImage imageWithName:@"music_default_avatar" type:@"png"];
        _btnAvatar = [[EGOImageButton alloc] initWithPlaceholderImage:avatarNorImage];
        _btnAvatar.frame = CGRectMake(10, 4, 36, 36);
        _btnAvatar.layer.cornerRadius = 18;
        _btnAvatar.layer.masksToBounds = YES;
        _btnAvatar.layer.borderWidth = 2;
        _btnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
        [_btnAvatar setImage:avatarNorImage forState:UIControlStateNormal];
        [self addSubview:_btnAvatar];
        
        //nickname
        _lblNickName = [[UILabel alloc] init];
        _lblNickName.frame = CGRectMake(54, 11, 123, 21);
        _lblNickName.backgroundColor = [UIColor clearColor];
        _lblNickName.textColor = [UIColor whiteColor];
        _lblNickName.textAlignment = kTextAlignmentLeft;
        _lblNickName.text = @"nickname";
        _lblNickName.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:_lblNickName];
        
        //first
        _btnFirstMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnFirstMenu.frame = CGRectMake(190, 0, 60, 44);
        [_btnFirstMenu setTitle:@"first" forState:UIControlStateNormal];
        [self addSubview:_btnFirstMenu];
        
        //second
        _btnSecondMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnSecondMenu.frame = CGRectMake(258, 0, 60, 44);
        [_btnSecondMenu setTitle:@"second" forState:UIControlStateNormal];
        [self addSubview:_btnSecondMenu];
        
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
