//
//  PCustomPlayerNavigationView.m
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomPlayerNavigationView.h"

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
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //左边菜单按钮
        _btnMenu = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnMenu.frame = CGRectMake(0, 0, 50, 50);
        [self addSubview:_btnMenu];
        
        //播放中标化图表
        _showPlayingImageView = [[UIImageView alloc] init];
        [self addSubview:_showPlayingImageView];
        
        //显示歌曲信息
        _lblPlayingSongInfo = [[UILabel alloc] init];
        [self addSubview:_lblPlayingSongInfo];
        
        //分享按钮
        _btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnShare.frame = CGRectMake(250, 0, 50, 50);
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
