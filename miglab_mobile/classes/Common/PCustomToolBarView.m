//
//  PCustomToolBarView.m
//  HelloWorld
//
//  Created by Ming Jianhua on 13-1-30.
//  Copyright (c) 2013年 9158.com. All rights reserved.
//

#import "PCustomToolBarView.h"
#import "UIImage+PImageCategory.h"
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"

@implementation PCustomToolBarView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithNavToolBar
{
    
    self = [super initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-68, 320, 48)];
    if (self) {
        // Initialization code
        
        //background
        UIImage *backgroundImage = [UIImage imageWithName:@"toolbar_bg" type:@"png"];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:backgroundImage];
        [self addSubview:bgImageView];
        [bgImageView release];
        
        //left
        UIImage *leftNormalImage = [UIImage imageWithName:@"toolbar_icon_menu" type:@"png"];
        UIImage *leftHighlightedImage = [UIImage imageWithName:@"toolbar_icon_menu_h" type:@"png"];
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setFrame:CGRectMake(3, 3, 46, 44)];
        [leftButton setBackgroundImage:leftNormalImage forState:UIControlStateNormal];
        [leftButton setBackgroundImage:leftHighlightedImage forState:UIControlStateHighlighted];
        [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftButton];
        
        //middle
        UIImage *middleNormalImage = [UIImage imageWithName:@"toolbar_icon_photo" type:@"png"];
        UIImage *middleHighlightedImage = [UIImage imageWithName:@"toolbar_icon_photo_h" type:@"png"];
        UIButton *middleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [middleButton setFrame:CGRectMake(91, -10, 136, 58)];
        [middleButton setBackgroundImage:middleNormalImage forState:UIControlStateNormal];
        [middleButton setBackgroundImage:middleHighlightedImage forState:UIControlStateHighlighted];
        [middleButton addTarget:self action:@selector(middleAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:middleButton];
        
        //right
        UIImage *rightNormalImage = [UIImage imageWithName:@"toolbar_icon_friends" type:@"png"];
        UIImage *rightHighlightedImage = [UIImage imageWithName:@"toolbar_icon_friends_h" type:@"png"];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setFrame:CGRectMake(271, 3, 46, 44)];
        [rightButton setBackgroundImage:rightNormalImage forState:UIControlStateNormal];
        [rightButton setBackgroundImage:rightHighlightedImage forState:UIControlStateHighlighted];
        [rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightButton];
        
    }
    return self;
}

//底部左中右菜单委托
-(void)leftAction{
    if (delegate && [delegate respondsToSelector:@selector(doLeftAction)]) {
        [delegate doLeftAction];
    }
}

-(void)middleAction{
    if (delegate && [delegate respondsToSelector:@selector(doMiddleAction)]) {
        [delegate doMiddleAction];
    }
}

-(void)rightAction{
    if (delegate && [delegate respondsToSelector:@selector(doRightAction)]) {
        [delegate doRightAction];
    }
}

-(id)initWithCustomButtonBar{
    
    self = [super initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - 68, 320, 48)];
    if (self) {
        
        //显示左边菜单
        UIGlossyButton *first = [[UIGlossyButton alloc] init];
        [first setFrame:CGRectMake(-10, -15, 68, 68)];
        first.tintColor = [UIColor whiteColor];
        [first useWhiteLabel: YES];
        [first setTitle:@"菜单" forState:UIControlStateNormal];
        first.buttonBorderWidth = 0.0f;
        first.buttonCornerRadius = 50.0f;
        first.backgroundOpacity = 0.5;
        [first setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        [first addTarget:self action:@selector(firstAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:first];
        [first release];
        
        //文字便笺
        UIGlossyButton *second = [[UIGlossyButton alloc] init];
        [second setFrame:CGRectMake(80, 5, 40, 40)];
        second.tintColor = [UIColor whiteColor];
        [second useWhiteLabel: YES];
        [second setTitle:@"便签" forState:UIControlStateNormal];
        second.buttonBorderWidth = 0.0f;
        second.buttonCornerRadius = 40.0f;
        second.backgroundOpacity = 0.5;
        [second setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        [second addTarget:self action:@selector(secondAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:second];
        [second release];
        
        //记忆语音
        UIGlossyButton *third = [[UIGlossyButton alloc] init];
        [third setFrame:CGRectMake(140, -25, 70, 70)];
        third.tintColor = [UIColor whiteColor];
        [third useWhiteLabel: YES];
        [third setTitle:@"录音" forState:UIControlStateNormal];
        third.buttonBorderWidth = 0.0f;
        third.buttonCornerRadius = 40.0f;
        third.backgroundOpacity = 0.5;
        [third setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        [third addTarget:self action:@selector(thirdAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:third];
        [third release];
        
        //个性照片
        UIGlossyButton *four = [[UIGlossyButton alloc] init];
        [four setFrame:CGRectMake(210, 10, 40, 40)];
        four.tintColor = [UIColor whiteColor];
        [four useWhiteLabel: YES];
        [four setTitle:@"拍照" forState:UIControlStateNormal];
        four.buttonBorderWidth = 0.0f;
        four.buttonCornerRadius = 40.0f;
        four.backgroundOpacity = 0.5;
        [four setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        [four addTarget:self action:@selector(fourAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:four];
        [four release];
        
        //魅力视频
        UIGlossyButton *five = [[UIGlossyButton alloc] init];
        [five setFrame:CGRectMake(270, -5, 50, 50)];
        five.tintColor = [UIColor whiteColor];
        [five useWhiteLabel: YES];
        [five setTitle:@"视频" forState:UIControlStateNormal];
        five.buttonBorderWidth = 0.0f;
        five.buttonCornerRadius = 40.0f;
        five.backgroundOpacity = 0.5;
        [five setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        [five addTarget:self action:@selector(fiveAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:five];
        [five release];
        
    }
    return self;
}

//底部无规则菜单委托
-(void)firstAction{
    if (delegate && [delegate respondsToSelector:@selector(doFirstAction)]) {
        [delegate doFirstAction];
    }
}

-(void)secondAction{
    if (delegate && [delegate respondsToSelector:@selector(doSecondAction)]) {
        [delegate doSecondAction];
    }
}

-(void)thirdAction{
    if (delegate && [delegate respondsToSelector:@selector(doThirdAction)]) {
        [delegate doThirdAction];
    }
}

-(void)fourAction{
    if (delegate && [delegate respondsToSelector:@selector(doFourAction)]) {
        [delegate doFourAction];
    }
}

-(void)fiveAction{
    if (delegate && [delegate respondsToSelector:@selector(doFiveAction)]) {
        [delegate doFiveAction];
    }
}

-(void)dealloc{
    [self setDelegate:nil];
    [super dealloc];
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
