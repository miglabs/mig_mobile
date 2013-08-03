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
        _btnMenu.frame = CGRectMake(3, 23, 44, 44);
        UIImage *menuNorImage = [UIImage imageWithName:@"play_btn_menu_nor" type:@"png"];
        UIImage *menuSelImage = [UIImage imageWithName:@"play_btn_menu_sel" type:@"png"];
        [_btnMenu setImage:menuNorImage forState:UIControlStateNormal];
        [_btnMenu setImage:menuSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnMenu];
        
        //播放中标化图表
        _showPlayingImageView = [[UIImageView alloc] init];
        _showPlayingImageView.frame = CGRectMake(52, 42, 28, 17);
        UIImage *playingTipImage = [UIImage imageWithName:@"playing_tip" type:@"png"];
        [_showPlayingImageView setImage:playingTipImage];
        [self addSubview:_showPlayingImageView];
        
        //显示歌曲信息
        _lblPlayingSongInfo = [[UILabel alloc] init];
        _lblPlayingSongInfo.backgroundColor = [UIColor clearColor];
        _lblPlayingSongInfo.frame = CGRectMake(88, 40, 182, 21);
        _lblPlayingSongInfo.textColor = [UIColor whiteColor];
        _lblPlayingSongInfo.shadowOffset = CGSizeMake(0, 1);
        _lblPlayingSongInfo.text = @"心情推荐-失恋疗伤";//@"聚乐音乐";
        [self addSubview:_lblPlayingSongInfo];
        
        //分享按钮
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(271, 23, 44, 44);
        UIImage *shareNorImage = [UIImage imageWithName:@"play_btn_share_nor" type:@"png"];
        UIImage *shareSelImage = [UIImage imageWithName:@"play_btn_share_sel" type:@"png"];
        [_btnShare setImage:shareNorImage forState:UIControlStateNormal];
        [_btnShare setImage:shareSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnShare];
        
        _playingTipIndex = 0;
        
    }
    
    return self;
}

//显示正在播放图标
-(void)doUpdatePlayingTip{
    
    _playingTipIndex++;
    _playingTipIndex = _playingTipIndex % 7;
    
    NSString *playingTipImageName = [NSString stringWithFormat:@"playing_tip_%d", _playingTipIndex];
    _showPlayingImageView.image = [UIImage imageWithName:playingTipImageName type:@"png"];
    
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
