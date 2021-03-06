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
#import "ShareGuideView.h"
#import "SinaWeiboHelper.h"
#import "TencentHelper.h"
#import "WXApi.h"
#import "LyricShare.h"
#import "UIImage+ext.h"

@interface DetailPlayerViewController : BaseViewController<EGOImageViewDelegate, EGOImageButtonDelegate, UIActionSheetDelegate, SinaWeiboHelperDelegate, TencentHelperDelegate, WXApiDelegate>

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

//适配IOS8的分享选择
@property (nonatomic,retain) UIAlertController * shareAlertController;

//截图
@property (nonatomic, retain) UIImage *screenCaptureImage;
@property (nonatomic, assign) BOOL isCurSongLike;

//qq zone
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@property (nonatomic, strong) NSArray *permissions;

//分享引导
@property (nonatomic, strong) ShareGuideView *shareGuideView;

-(IBAction)doShowMenuViewAction:(id)sender;
-(IBAction)doShareAction:(id)sender;
-(IBAction)doGotoShareView:(id)sender;
-(void)doShare2QQZone;
-(void)doShare2SinaWeibo;
-(IBAction)doShare2WeiXin:(id)sender;
-(IBAction)doShare2WeiXinForFriendOnly:(id)sender;
-(void)doShare2TencentWeibo;
-(void)doShare2Renren;
-(void)doSHare2Sms;

-(IBAction)doGotoShareViewWithLyric:(id)sender;
-(void)doShare2WeiXinWithLyric:(LyricShare *)ls;

-(IBAction)doDeleteAction:(id)sender;
-(IBAction)doCollectAction:(id)sender;
-(IBAction)doPlayOrPauseAction:(id)sender;
-(IBAction)doNextAction:(id)sender;

-(void)hateSongFailed:(NSNotification *)tNotification;
-(void)hateSongSuccess:(NSNotification *)tNotification;
-(void)collectSongFailed:(NSNotification *)tNotification;
-(void)collectSongSuccess:(NSNotification *)tNotification;
-(void)autoPlayerNext:(NSNotification *)tNotification;

-(void)getShareInfoSuccess:(NSNotification *)tNotification;
-(void)getShareInfoFailed:(NSNotification *)tNotification;

-(void)initSongInfo;
-(void)configNowPlayingInfoCenter;               //锁屏封面

//播放时间刷新
-(void)timerStop;
-(void)timerStart;
-(void)playerTimerFunction;

//播放时刷新所有对于view的数据
-(void)doUpdateForPlaying;

@end
