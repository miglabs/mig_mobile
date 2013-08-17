//
//  GeneViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"

@interface GeneViewController : PlayerViewController

@property (nonatomic, retain) UIViewController *topViewcontroller;

@property (nonatomic, retain) EGOImageButton *btnAvatar;

-(IBAction)doAvatar:(id)sender;

@end
