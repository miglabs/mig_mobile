//
//  RootViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "RootNavigationMenuView.h"

@interface RootViewController : BaseViewController

@property (nonatomic, retain) RootNavigationMenuView *rootNavMenuView;
@property (nonatomic, retain) NSMutableDictionary *dicViewControllerCache;
@property (nonatomic, assign) int currentShowViewTag;

-(IBAction)segmentAction:(id)sender;
-(UIViewController *)getControllerBySegIndex:(int)segindex;

@end
