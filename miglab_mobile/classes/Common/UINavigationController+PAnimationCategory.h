//
//  UINavigationController+PAnimationCategory.h
//  miglab_mobile
//
//  Created by apple on 13-7-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (PAnimationCategory)

-(void)pushAnimationDidStop;
-(void)pushViewController: (UIViewController*)controller animatedWithTransition: (UIViewAnimationTransition)transition;
-(UIViewController*)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition;

@end
