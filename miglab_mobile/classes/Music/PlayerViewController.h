//
//  PlayerViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "MusicPlayerMenuView.h"

@interface PlayerViewController : BaseViewController

@property (nonatomic, retain) MusicPlayerMenuView *playerMenuView;

-(IBAction)doPlayerAvatar:(id)sender;
-(IBAction)doDelete:(id)sender;
-(IBAction)doCollect:(id)sender;
-(IBAction)doPlayOrPause:(id)sender;
-(IBAction)doNext:(id)sender;

@end
