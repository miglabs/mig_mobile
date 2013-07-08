//
//  PlayViewController.h
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomPlayerNavigationView.h"
#import "PCustomPlayerMenuView.h"

@interface PlayViewController : UIViewController

@property (nonatomic, retain) PCustomPlayerNavigationView *topPlayerInfoView;

@property (nonatomic, retain) UIScrollView *songInfoScrollView;

@property (nonatomic, retain) PCustomPlayerMenuView *bottomPlayerMenuView;

@end
