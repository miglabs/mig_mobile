//
//  LocalViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "MusicPlayerMenuView.h"

@interface LocalViewController : UIViewController

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) MusicPlayerMenuView *playerMenuView;

-(IBAction)doBack:(id)sender;

@end
