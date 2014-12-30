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
#import "UserSessionManager.h"
#import "PPlayerManagerCenter.h"
#import "SVProgressHUD.h"
#import "PDatabaseManager.h"

@interface PlayerViewController : BaseViewController<EGOImageButtonDelegate>

//导航指针
@property (nonatomic, retain) UIViewController *topViewcontroller;
//底部播放器
@property (nonatomic, retain) MusicPlayerMenuView *playerMenuView;
//接口api
@property (nonatomic, retain) MigLabAPI *miglabAPI;

@property (nonatomic, assign) BOOL playerUnavailable;

-(IBAction)doPlayerAvatar:(id)sender;
-(IBAction)doDelete:(id)sender;
-(IBAction)doCollect:(id)sender;
-(IBAction)doPlayOrPause:(id)sender;
-(IBAction)doNext:(id)sender;


//根据音乐基因获取歌曲
-(void)loadTypeSongs;

-(void)hateSongFailed:(NSNotification *)tNotification;
-(void)hateSongSuccess:(NSNotification *)tNotification;
-(void)collectSongFailed:(NSNotification *)tNotification;
-(void)collectSongSuccess:(NSNotification *)tNotification;
-(void)cancelCollectedSongFailed:(NSNotification *)tNotification;
-(void)cancelCollectedSongSuccess:(NSNotification *)tNotification;
-(void)playerStart:(NSNotification *)tNotification;
-(void)playerStop:(NSNotification *)tNotification;

-(void)playerAbort:(NSNotification *)tNotification;
-(void)playerResume:(NSNotification *)tNotification;

-(void)updateSongInfo;

@end
