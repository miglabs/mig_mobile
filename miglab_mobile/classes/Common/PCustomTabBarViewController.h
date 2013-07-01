//
//  PCustomTabBarViewController.h
//  itime
//
//  Created by pig on 13-1-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomTabBarView.h"

@interface PCustomTabBarViewController : UITabBarController<PCustomTabBarViewDelegate>{
    
    NSArray *titleList;
    NSArray *normalIconList;
    NSArray *selectedIconList;
    PCustomTabBarView *pCustomTabBarView;
    
}

@property (nonatomic, retain) NSArray *titleList;
@property (nonatomic, retain) NSArray *normalIconList;
@property (nonatomic, retain) NSArray *selectedIconList;
@property (nonatomic, retain) PCustomTabBarView *pCustomTabBarView;

-(void)initCustomTabBar;
-(void)hideRealTabBar;
-(void)hideCustomTabBar;
-(void)showCustomTabBar;

@end
