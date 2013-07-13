//
//  PCustomPageControl.m
//  miglab_mobile
//
//  Created by apple on 13-7-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PCustomPageControl.h"

@interface PCustomPageControl ()

-(void)updateDots;

@end

@implementation PCustomPageControl

@synthesize imagePageStateNormal = _imagePageStateNormal;
@synthesize imagePageStateHighlighted = _imagePageStateHighlighted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// 初始化
-(id)initCustomViewWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        
    }
    return self;
}

// 设置正常状态点按钮的图片
-(void)setImagePageStateNormal:(UIImage *)imagePageStateNormal{
    
    _imagePageStateNormal = imagePageStateNormal;
    [self updateDots];
    
}

// 设置高亮状态点按钮图片
-(void)setImagePageStateHighlighted:(UIImage *)imagePageStateHighlighted{
    
    _imagePageStateHighlighted = imagePageStateHighlighted;
    [self updateDots];
    
}

// 点击事件
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    [super endTrackingWithTouch:touch withEvent:event];
    [self updateDots];
    
}

-(void)setCurrentPage:(NSInteger)currentPage{
    
    [super setCurrentPage:currentPage];
    [self updateDots];
    
}

// 更新显示所有的点按钮
-(void)updateDots{
    
    if (_imagePageStateNormal || _imagePageStateHighlighted) {
        
        // 获取所有子视图
        NSArray *subview = self.subviews;
        int subviewcount = [subview count];
        for (int i=0; i<subviewcount; i++) {
            
            UIImageView *dot = [subview objectAtIndex:i];
            CGSize size = CGSizeMake(18, 18);
            [dot setFrame:CGRectMake(dot.frame.origin.x, dot.frame.origin.y, size.width, size.height)];
            dot.image = (self.currentPage == i) ? _imagePageStateHighlighted : _imagePageStateNormal;
            
        }
        
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
