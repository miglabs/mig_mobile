//
//  BaseViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "PCustomNavigationBarView.h"

@interface BaseViewController : UIViewController

//适配ios7
@property (nonatomic, assign) int topDistance;
//导航
@property (nonatomic, retain) PCustomNavigationBarView *navView;
//背景图片
@property (nonatomic, retain) EGOImageView *bgImageView;

-(IBAction)doBack:(id)sender;

@end
