//
//  MusicViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicPlayerNavigationView.h"
#import "MusicPlayerMenuView.h"

@interface MusicViewController : UIViewController

@property (nonatomic, retain) MusicPlayerNavigationView *navigationView;


@property (nonatomic, retain) MusicPlayerMenuView *playerMenuView;


-(IBAction)doNavigationAvatar:(id)sender;
-(IBAction)doNavigationFirst:(id)sender;
-(IBAction)doNavigationSecond:(id)sender;


-(IBAction)doPlayerAvatar:(id)sender;
-(IBAction)doDelete:(id)sender;
-(IBAction)doCollect:(id)sender;
-(IBAction)doPlayOrPause:(id)sender;
-(IBAction)doNext:(id)sender;

@end
