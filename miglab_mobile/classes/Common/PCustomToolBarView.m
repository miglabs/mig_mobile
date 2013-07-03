//
//  PCustomToolBarView.m
//  HelloWorld
//
//  Created by Ming Jianhua on 13-1-30.
//  Copyright (c) 2013年 9158.com. All rights reserved.
//

#import "PCustomToolBarView.h"
#import "UIImage+PImageCategory.h"

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
