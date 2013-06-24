//
//  GuideViewController.h
//  vanke
//
//  Created by pig on 13-6-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, retain) UIScrollView *guideScrollView;
@property (nonatomic, retain) UIPageControl *guidePageControl;

-(void)gotoNextView;

@end
