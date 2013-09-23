//
//  RootNavigationMenuView.m
//  miglab_mobile
//
//  Created by apple on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RootNavigationMenuView.h"
#import "UIImage+PImageCategory.h"

@implementation RootNavigationMenuView

@synthesize bgImageView = _bgImageView;
@synthesize btnMenuFirst = _btnMenuFirst;
@synthesize btnMenuSecond = _btnMenuSecond;
@synthesize btnMenuThird = _btnMenuThird;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initRootNavigationMenuView:(CGRect)frame{
    
//    self = [super initWithFrame:CGRectMake(0, 0, 320, 45)];
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *bgImage = [UIImage imageWithName:@"home_navigation_bg" type:@"png"];
        _bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        _bgImageView.frame = CGRectMake(0, 0, 320, 45);
        [self addSubview:_bgImageView];
        
        UIImage *separatorImage = [UIImage imageWithName:@"home_navigation_separator" type:@"png"];
        UIImageView *separatorImageView01 = [[UIImageView alloc] initWithImage:separatorImage];
        separatorImageView01.frame = CGRectMake(106, 0, 1, 43);
        [self addSubview:separatorImageView01];
        
        UIImageView *separatorImageView12 = [[UIImageView alloc] initWithImage:separatorImage];
        separatorImageView12.frame = CGRectMake(213, 0, 1, 43);
        [self addSubview:separatorImageView12];
        
        UIImage *menuSelImage = [UIImage imageWithName:@"home_navigation_menu_sel" type:@"png"];
        UIColor *menuSelColor = [UIColor colorWithRed:92.0f/255.0f green:210.0f/255.0f blue:248.0f/255.0f alpha:1.0f];
        
        //first
        _btnMenuFirst = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 106, 43)];
        _btnMenuFirst.tag = 100;
        [_btnMenuFirst setBackgroundImage:menuSelImage forState:UIControlStateSelected];
        [_btnMenuFirst setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMenuFirst setTitleColor:menuSelColor forState:UIControlStateSelected];
        [_btnMenuFirst setTitle:@"音乐基因" forState:UIControlStateNormal];
        [self addSubview:_btnMenuFirst];
        
        //second
        _btnMenuSecond = [[UIButton alloc] initWithFrame:CGRectMake(107, 0, 106, 43)];
        _btnMenuSecond.tag = 101;
        [_btnMenuSecond setBackgroundImage:menuSelImage forState:UIControlStateSelected];
        [_btnMenuSecond setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMenuSecond setTitleColor:menuSelColor forState:UIControlStateSelected];
        [_btnMenuSecond setTitle:@"歌单" forState:UIControlStateNormal];
        [self addSubview:_btnMenuSecond];
        
        _btnMenuThird = [[UIButton alloc] initWithFrame:CGRectMake(214, 0,106, 43)];
        _btnMenuThird.tag = 102;
        [_btnMenuThird setBackgroundImage:menuSelImage forState:UIControlStateSelected];
        [_btnMenuThird setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btnMenuThird setTitleColor:menuSelColor forState:UIControlStateSelected];
        [_btnMenuThird setTitle:@"歌友" forState:UIControlStateNormal];
        [self addSubview:_btnMenuThird];
        
    }
    return self;
    
}

-(void)setSelectedMenu:(int)aIndex{
    
    [_btnMenuFirst setSelected:NO];
    [_btnMenuSecond setSelected:NO];
    [_btnMenuThird setSelected:NO];
    
    if (aIndex == 0) {
        [_btnMenuFirst setSelected:YES];
    } else if (aIndex == 1) {
        [_btnMenuSecond setSelected:YES];
    } else if (aIndex == 2) {
        [_btnMenuThird setSelected:YES];
    }
    
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
