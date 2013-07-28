//
//  MainMenuViewController.h
//  miglab_mobile
//
//  Created by apple on 13-7-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"
#import "EGOImageView.h"
#import "PCustomPlayerNavigationView.h"
#import "PCustomPlayerMenuView.h"
#import "PCustomPageControl.h"
#import "PlayBodyView.h"

#import "PCustomPlayerBoradView.h"

#import "PHttpDownloader.h"

#import "PAAMusicPlayer.h"
#import "PAMusicPlayer.h"
#import "Song.h"
#import "PMusicPlayerDelegate.h"

#import "MigLabAPI.h"

@interface MainMenuViewController : UIViewController<UIScrollViewDelegate, EGOImageViewDelegate, EGOImageButtonDelegate, PMusicPlayerDelegate, AVAudioPlayerDelegate, PHttpDownloaderDelegate>

//播放页面
@property (nonatomic, retain) UIView *playView;
@property (nonatomic, retain) EGOImageView *backgroundEGOImageView;
@property (nonatomic, retain) PCustomPlayerNavigationView *topPlayerInfoView;
@property (nonatomic, retain) UILabel *lblSongInfo;
@property (nonatomic, retain) PCustomPageControl *showInfoPageControl;
@property (nonatomic, retain) UIScrollView *songInfoScrollView;
@property (nonatomic, retain) PlayBodyView *cdOfSongView;
@property (nonatomic, retain) PCustomPlayerMenuView *bottomPlayerMenuView;

@property (nonatomic, retain) EGOImageView *cdEGOImageView;                         //光盘旋转动画

/*
 使用播放计时器控制统一控制刷新，预留后续的歌词刷新
 */
@property (nonatomic, retain) NSTimer *playerTimer;
@property (nonatomic, assign) int checkUpdatePlayProcess;

//歌曲场景切换页面
@property (nonatomic, retain) PCustomPlayerBoradView *playerBoradView;

@property (nonatomic, assign) BOOL isPlayViewShowing;                               //当前是否显示播放页面

@property (nonatomic, retain) NSMutableArray *songList;
@property (nonatomic, assign) int currentSongIndex;
@property (nonatomic, retain) Song *currentSong;
@property BOOL shouldStartPlayAfterDownloaded;

@property (nonatomic, retain) MigLabAPI *miglabAPI;

-(void)initMenuView;

-(IBAction)doAvatarAction:(id)sender;
-(IBAction)doRemoveAction:(id)sender;
-(IBAction)doLikeAction:(id)sender;
-(IBAction)doPlayOrPause:(id)sender;                                                //播放、暂停歌曲
-(void)playCurrentSong;
-(IBAction)doNextAction:(id)sender;

//播放页面方法
-(void)initPlayView;
-(IBAction)doShowMenuViewAction:(id)sender;
-(IBAction)doShareAction:(id)sender;

//登录，获取用户资料
-(void)initUserData;
-(void)getGuestInfoFailed:(NSNotification *)tNotification;
-(void)getGuestInfoSuccess:(NSNotification *)tNotification;
-(void)loginFailed:(NSNotification *)tNotification;
-(void)loginSuccess:(NSNotification *)tNotification;
-(void)getUserInfoFailed:(NSNotification *)tNotification;
-(void)getUserInfoSuccess:(NSNotification *)tNotification;
-(void)getChannelFailed:(NSNotification *)tNotification;
-(void)getChannelSuccess:(NSNotification *)tNotification;
-(void)getMusicFromChannelFailed:(NSNotification *)tNotification;
-(void)getMusicFromChannelSuccess:(NSNotification *)tNotification;
-(void)getModeMusicFailed:(NSNotification *)tNotification;
-(void)getModeMusicSuccess:(NSNotification *)tNotification;
-(void)addBlacklistFailed:(NSNotification *)tNotification;
-(void)addBlacklistSuccess:(NSNotification *)tNotification;
-(void)addFavoriteFailed:(NSNotification *)tNotification;
-(void)addFavoriteSuccess:(NSNotification *)tNotification;

//下载歌曲
-(void)downloadFailed:(NSNotification *)tNotification;
-(void)downloadProcess:(NSNotification *)tNotification;
-(void)downloadSuccess:(NSNotification *)tNotification;

-(void)stopDownload;
-(void)initSongInfo;
-(void)downloadSong;
-(void)initAndStartPlayer;

-(void)timerStop;
-(void)timerStart;
-(void)playerTimerFunction;

@end
