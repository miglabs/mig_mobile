//
//  PlayerViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "MusicPlayerMenuView.h"
#import "MigLabAPI.h"

@interface PlayerViewController : BaseViewController

@property (nonatomic, retain) UIViewController *topViewcontroller;

@property (nonatomic, retain) MusicPlayerMenuView *playerMenuView;
@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(IBAction)doPlayerAvatar:(id)sender;
-(IBAction)doDelete:(id)sender;
-(IBAction)doCollect:(id)sender;
-(IBAction)doPlayOrPause:(id)sender;
-(IBAction)doNext:(id)sender;

-(void)hateSongFailed:(NSNotification *)tNotification;
-(void)hateSongSuccess:(NSNotification *)tNotification;
-(void)collectSongFailed:(NSNotification *)tNotification;
-(void)collectSongSuccess:(NSNotification *)tNotification;

@end
