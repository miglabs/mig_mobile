//
//  PlayViewController.h
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "PCustomPlayerNavigationView.h"
#import "PCustomPlayerMenuView.h"

@interface PlayViewController : UIViewController

@property (nonatomic, retain) EGOImageView *backgroundEGOImageView;
@property (nonatomic, retain) PCustomPlayerNavigationView *topPlayerInfoView;
@property (nonatomic, retain) UIScrollView *songInfoScrollView;
@property (nonatomic, retain) PCustomPlayerMenuView *bottomPlayerMenuView;

-(IBAction)doShowLeftViewAction:(id)sender;
-(IBAction)doShareAction:(id)sender;

-(IBAction)doRemoveAction:(id)sender;
-(IBAction)doLikeAction:(id)sender;
-(IBAction)doNextAction:(id)sender;

@end
