//
//  PCustomPlayerMenuView.m
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomPlayerMenuView.h"

@implementation PCustomPlayerMenuView

@synthesize playerMenuBgImageView = _playerMenuBgImageView;
@synthesize btnRemove = _btnRemove;
@synthesize btnCollect = _btnCollect;
@synthesize btnNext = _btnNext;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initPlayerMenuView:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景图片
        _playerMenuBgImageView = [[UIImageView alloc] init];
        _playerMenuBgImageView.frame = CGRectMake(0, 0, 320, 85);
        [self addSubview:_playerMenuBgImageView];
        
        //移除按钮
        _btnRemove = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRemove.frame = CGRectMake(0, 0, 50, 50);
        [_btnRemove setAdjustsImageWhenHighlighted:YES];
        [self addSubview:_btnRemove];
        
        //收藏
        _btnCollect = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnCollect.frame = CGRectMake(100, 0, 50, 50);
        [self addSubview:_btnCollect];
        
        //下一首
        _btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNext.frame = CGRectMake(200, 0, 50, 50);
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
