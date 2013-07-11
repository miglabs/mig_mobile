//
//  PCustomPageControl.h
//  miglab_mobile
//
//  Created by apple on 13-7-11.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCustomPageControl : UIPageControl

@property (nonatomic, retain) UIImage *imagePageStateNormal;
@property (nonatomic, retain) UIImage *imagePageStateHighlighted;

-(id)initCustomViewWithFrame:(CGRect)frame;

@end
