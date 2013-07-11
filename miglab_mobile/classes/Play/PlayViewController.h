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
#import "EGOImageButton.h"
#import "PMusicPlayerDelegate.h"
#import "PAAMusicPlayer.h"
#import "PAMusicPlayer.h"
#import "PPlayerManaerCenter.h"

@interface PlayViewController : UIViewController<UIScrollViewDelegate, EGOImageViewDelegate, EGOImageButtonDelegate, PMusicPlayerDelegate>

@property (nonatomic, retain) EGOImageView *backgroundEGOImageView;
@property (nonatomic, retain) PCustomPlayerNavigationView *topPlayerInfoView;
@property (nonatomic, retain) UIScrollView *songInfoScrollView;
@property (nonatomic, retain) UIPageControl *showInfoPageControl;

@property (nonatomic, retain) IBOutlet UIView *cdOfSongView;
@property (nonatomic, retain) IBOutlet UILabel *lblSongInfo;
@property (nonatomic, retain) IBOutlet UIImageView *ivCircleProcess;
@property (nonatomic, retain) IBOutlet UIImageView *ivPlayProcessPoint;
@property (nonatomic, retain) IBOutlet EGOImageButton *cdOfSongEGOImageButton;

@property (nonatomic, retain) PAAMusicPlayer *aaMusicPlayer;
@property (nonatomic, retain) PAMusicPlayer *aMusicPlayer;

@property (nonatomic, retain) PCustomPlayerMenuView *bottomPlayerMenuView;

-(IBAction)doShowLeftViewAction:(id)sender;
-(IBAction)doShareAction:(id)sender;

//下载歌曲
-(void)downloadFailed:(NSNotification *)tNotification;
-(void)downloadProcess:(NSNotification *)tNotification;
-(void)downloadSuccess:(NSNotification *)tNotification;

-(IBAction)doPlayOrPause:(id)sender;
//刷新圆盘进度
-(void)updatePlayingProcess:(float)playRate;

-(IBAction)doRemoveAction:(id)sender;
-(IBAction)doLikeAction:(id)sender;
-(IBAction)doNextAction:(id)sender;

@end
