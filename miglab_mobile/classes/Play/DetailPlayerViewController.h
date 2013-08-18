//
//  DetailPlayerViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"
#import "EGOImageView.h"
#import "EGOImageButton.h"
#import "PCustomPlayerNavigationView.h"
#import "PCustomPageControl.h"
#import "PlayBodyView.h"
#import "PCustomPlayerMenuView.h"

#import "MigLabAPI.h"

@interface DetailPlayerViewController : BaseViewController<UIScrollViewDelegate, EGOImageViewDelegate, EGOImageButtonDelegate>

@property (nonatomic, retain) PCustomPlayerNavigationView *topPlayerInfoView;

@property (nonatomic, retain) UILabel *lblSongInfo;
@property (nonatomic, retain) PCustomPageControl *showInfoPageControl;

@property (nonatomic, retain) UIScrollView *songInfoScrollView;

@property (nonatomic, retain) PlayBodyView *cdOfSongView;

@property (nonatomic, retain) PCustomPlayerMenuView *bottomPlayerMenuView;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(IBAction)doShowMenuViewAction:(id)sender;
-(IBAction)doShareAction:(id)sender;

-(IBAction)doDeleteAction:(id)sender;
-(IBAction)doCollectAction:(id)sender;
-(IBAction)doPlayOrPauseAction:(id)sender;
-(IBAction)doNextAction:(id)sender;

-(void)hateSongFailed:(NSNotification *)tNotification;
-(void)hateSongSuccess:(NSNotification *)tNotification;
-(void)collectSongFailed:(NSNotification *)tNotification;
-(void)collectSongSuccess:(NSNotification *)tNotification;

-(void)initSongInfo;
-(void)configNowPlayingInfoCenter;               //锁屏封面

@end
