//
//  CustomWindow.m
//  Vgirl-XAuth2.0
//
//  Created by Ming Jianhua on 12-7-27.
//  Copyright (c) 2012年 9158.com. All rights reserved.
//

#import "CustomWindow.h"

@implementation CustomWindow

@synthesize superView;
@synthesize backgroundView;
@synthesize contentView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(CustomWindow *)initWithView:(UIView *)aView
{
    
    if (self=[super init]) {
        
        //内容view
        self.contentView = aView;
        
        //初始化主屏幕
        [self setFrame:[[UIScreen mainScreen] bounds]];
        [self setWindowLevel:UIWindowLevelStatusBar];
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1]];
        
        //添加根view，并且将背景设为透明.
        UIView *rootView = [[UIView alloc] initWithFrame:[self bounds]];
        [self setSuperView:rootView];
        [superView setAlpha:0.0f];
        [self addSubview:superView];
        [rootView release];
        
        //设置background view.
////        CGFloat offset = -6.0f;
//        //根据中心放大
//        UIView *bv = [[UIView alloc] initWithFrame:CGRectInset(CGRectMake(0,0,self.contentView.bounds.size.width,self.contentView.bounds.size.height), offset, 20)];
//        [self setBackgroundView:bv];
//        [bv release];
//        
//        [backgroundView setCenter:CGPointMake(superView.bounds.size.width/2,superView.bounds.size.height/2)];
//        [superView addSubview:backgroundView];
//        
//        CGRect frame =CGRectInset([backgroundView bounds], -1 * offset, -1 * offset);
        
        //显示内容view
//        [backgroundView addSubview:self.contentView];
//        [self.contentView setFrame:frame];

        [superView addSubview:self.contentView];
        
        closed =NO;
        
    }
    
    return self;
}


//显示弹出窗口
-(void)show
{
    [self makeKeyAndVisible];
    [superView setAlpha:1.0f]; 
    
}


-(void)dialogIsRemoved
{
    
    closed = YES;
    [contentView removeFromSuperview];
    contentView =nil;
    [backgroundView removeFromSuperview];
    backgroundView =nil;
    [superView removeFromSuperview];
    superView =nil;
    [self setAlpha:0.0f];
    [self removeFromSuperview];
    
    //    NSLog(@"===> %s, %s, %d", __FUNCTION__, __FILE__, __LINE__);
    
}


-(void)close
{
    
    [UIView setAnimationDidStopSelector:@selector(dialogIsRemoved)];
    [superView setAlpha:0.0f];
    
    //    NSLog(@"===> %s, %s, %d", __FUNCTION__, __FILE__, __LINE__);
    
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
