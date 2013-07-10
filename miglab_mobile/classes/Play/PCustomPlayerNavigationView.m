//
//  PCustomPlayerNavigationView.m
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomPlayerNavigationView.h"
#import "UIImage+PImageCategory.h"

@implementation PCustomPlayerNavigationView

@synthesize btnMenu = _btnMenu;
@synthesize showPlayingImageView = _showPlayingImageView;
@synthesize lblPlayingSongInfo = _lblPlayingSongInfo;
@synthesize btnShare = _btnShare;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initPlayerNavigationView:(CGRect)frame
{
    //0,0,320,63
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //左边菜单按钮
        _btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMenu.frame = CGRectMake(10, 30, 50, 50);
        UIImage *menuNorImage = [UIImage imageWithName:@"btn_menu_nor" type:@"png"];
        [_btnMenu setImage:menuNorImage forState:UIControlStateNormal];
        [self addSubview:_btnMenu];
        
        //播放中标化图表
        _showPlayingImageView = [[UIImageView alloc] init];
        _showPlayingImageView.frame = CGRectMake(52, 37, 28, 17);
        UIImage *playingTipImage = [UIImage imageWithName:@"playing_tip" type:@"png"];
        [_showPlayingImageView setImage:playingTipImage];
        [self addSubview:_showPlayingImageView];
        
        //显示歌曲信息
        _lblPlayingSongInfo = [[UILabel alloc] init];
        _lblPlayingSongInfo.frame = CGRectMake(88, 35, 125, 21);
        _lblPlayingSongInfo.text = @"聚乐音乐会";
        [self addSubview:_lblPlayingSongInfo];
        
        //分享按钮
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(250, 29, 30, 30);
        UIImage *shareNorImage = [UIImage imageWithName:@"btn_share_nor" type:@"png"];
        [_btnShare setImage:shareNorImage forState:UIControlStateNormal];
        [self addSubview:_btnShare];
        
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
