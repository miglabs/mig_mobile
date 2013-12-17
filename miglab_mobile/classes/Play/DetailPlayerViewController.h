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
#import "PlayBodyView.h"
#import "PCustomPlayerMenuView.h"

#import "MigLabAPI.h"

@interface DetailPlayerViewController : BaseViewController<EGOImageViewDelegate, EGOImageButtonDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) PCustomPlayerNavigationView *topPlayerInfoView;

@property (nonatomic, retain) UILabel *lblSongInfo;

@property (nonatomic, retain) PlayBodyView *cdOfSongView;

@property (nonatomic, retain) PCustomPlayerMenuView *bottomPlayerMenuView;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

/*
 使用播放计时器控制统一控制刷新，预留后续的歌词刷新
 */
@property (nonatomic, retain) NSTimer *playerTimer;
@property (nonatomic, assign) int checkUpdatePlayProcess;

//分享选择
@property (nonatomic, retain) UIActionSheet *shareAchtionSheet;
//截图
@property (nonatomic, retain) UIImage *screenCaptureImage;
@property (nonatomic, assign) BOOL isCurSongLike;

-(IBAction)doShowMenuViewAction:(id)sender;
-(IBAction)doShareAction:(id)sender;
-(IBAction)doGotoShareView:(id)sender;
-(void)doShare2QQZone;
-(void)doShare2SinaWeibo;
-(void)doShare2WeiXin;
-(void)doShare2TencentWeibo;
-(void)doShare2Renren;
-(void)doSHare2Sms;

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

//播放时间刷新
-(void)timerStop;
-(void)timerStart;
-(void)playerTimerFunction;

//播放时刷新所有对于view的数据
-(void)doUpdateForPlaying;

@end
