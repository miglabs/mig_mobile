//
//  PCustomPlayerMenuView.m
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomPlayerMenuView.h"
#import "UIImage+PImageCategory.h"

@implementation PCustomPlayerMenuView

@synthesize playerMenuBgImageView = _playerMenuBgImageView;
@synthesize btnRemove = _btnRemove;
@synthesize btnLike = _btnLike;
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
    //CGRectMake(0, 0, 320, 90);
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        //背景图片
        _playerMenuBgImageView = [[UIImageView alloc] init];
        _playerMenuBgImageView.frame = CGRectMake(0, 0, 320, 90);
        UIImage *playerMenuBgImage = [UIImage imageWithName:@"bottom_control_bg" type:@"png"];
        _playerMenuBgImageView.image = playerMenuBgImage;
        [self addSubview:_playerMenuBgImageView];
        
        //移除按钮
        _btnRemove = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnRemove.frame = CGRectMake(42, 27, 48, 48);
        UIImage *removeNorImage = [UIImage imageWithName:@"btn_delete_nor" type:@"png"];
        UIImage *removeSelImage = [UIImage imageWithName:@"btn_delete_sel" type:@"png"];
        [_btnRemove setImage:removeNorImage forState:UIControlStateNormal];
        [_btnRemove setImage:removeSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnRemove];
        
        //喜欢
        _btnLike = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnLike.frame = CGRectMake(128, 16, 62, 62);
        UIImage *likeNorImage = [UIImage imageWithName:@"btn_like_nor" type:@"png"];
        UIImage *likeSelImage = [UIImage imageWithName:@"btn_like_sel" type:@"png"];
        [_btnLike setImage:likeNorImage forState:UIControlStateNormal];
        [_btnLike setImage:likeSelImage forState:UIControlStateHighlighted];
        [self addSubview:_btnLike];
        
        //下一首
        _btnNext = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNext.frame = CGRectMake(232, 27, 48, 48);
        UIImage *nextNorImage = [UIImage imageWithName:@"btn_next_nor" type:@"png"];
        UIImage *nextSelImage = [UIImage imageWithName:@"btn_next_sel" type:@"png"];
        [_btnNext setImage:nextNorImage forState:UIControlStateNormal];
        [_btnNext setImage:nextSelImage forState:UIControlStateHighlighted];
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
