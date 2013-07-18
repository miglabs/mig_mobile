//
//  UINavigationController+PAnimationCategory.m
//  miglab_mobile
//
//  Created by apple on 13-7-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "UINavigationController+PAnimationCategory.h"

@implementation UINavigationController (PAnimationCategory)

-(void)pushAnimationDidStop{
    
    PLog(@"pushAnimationDidStop...");
    
}

-(void)pushViewController:(UIViewController *)controller animatedWithTransition:(UIViewAnimationTransition)transition{
    
    [self pushViewController:controller animated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
    
}

-(UIViewController *)popViewControllerAnimatedWithTransition:(UIViewAnimationTransition)transition{
    
    UIViewController *poppedController = [self popViewControllerAnimated:NO];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(pushAnimationDidStop)];
    [UIView setAnimationTransition:transition forView:self.view cache:YES];
    [UIView commitAnimations];
    
    return poppedController;
}

@end
