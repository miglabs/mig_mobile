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
        UIImage *bgImage = [UIImage imageWithName:@"top_navigation_bg" type:@"png"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        bgImageView.frame = CGRectMake(0, 0, 320, 45);
        [self addSubview:bgImageView];
        
        _btnMenuFirst = [[UIButton alloc] initWithFrame:CGRectMake(7, 2, 97, 40)];
        _btnMenuFirst.tag = 100;
//        UIImage *firstNorImage = [UIImage imageNamed:@"pfm_recommend_nor.png"];
//        UIImage *firstSelImage = [UIImage imageNamed:@"pfm_recommend_sel.png"];
//        [_btnMenuFirst setImage:firstNorImage forState:UIControlStateNormal];
//        [_btnMenuFirst setImage:firstSelImage forState:UIControlStateHighlighted];
//        [_btnMenuFirst setImage:firstSelImage forState:UIControlStateSelected];
        [_btnMenuFirst setTitle:@"first" forState:UIControlStateNormal];
        [self addSubview:_btnMenuFirst];
        
        _btnMenuSecond = [[UIButton alloc] initWithFrame:CGRectMake(112, 2, 97, 40)];
        _btnMenuSecond.tag = 101;
//        UIImage *secondNorImage = [UIImage imageNamed:@"pfm_personal_center_nor.png"];
//        UIImage *secondSelImage = [UIImage imageNamed:@"pfm_personal_center_sel.png"];
//        [_btnMenuSecond setImage:secondNorImage forState:UIControlStateNormal];
//        [_btnMenuSecond setImage:secondSelImage forState:UIControlStateHighlighted];
//        [_btnMenuSecond setImage:secondSelImage forState:UIControlStateSelected];
        [_btnMenuSecond setTitle:@"second" forState:UIControlStateNormal];
        [self addSubview:_btnMenuSecond];
        
        _btnMenuThird = [[UIButton alloc] initWithFrame:CGRectMake(217, 2, 97, 40)];
        _btnMenuThird.tag = 102;
//        UIImage *thirdNorImage = [UIImage imageNamed:@"pfm_more_nor.png"];
//        UIImage *thirdSelImage = [UIImage imageNamed:@"pfm_more_sel.png"];
//        [_btnMenuThird setImage:thirdNorImage forState:UIControlStateNormal];
//        [_btnMenuThird setImage:thirdSelImage forState:UIControlStateHighlighted];
//        [_btnMenuThird setImage:thirdSelImage forState:UIControlStateSelected];
        [_btnMenuThird setTitle:@"third" forState:UIControlStateNormal];
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
