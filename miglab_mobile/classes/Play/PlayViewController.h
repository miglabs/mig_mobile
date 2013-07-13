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
#import "PCustomPageControl.h"
#import "EGOImageButton.h"
#import "PMusicPlayerDelegate.h"
#import "PAAMusicPlayer.h"
#import "PAMusicPlayer.h"
#import "PPlayerManaerCenter.h"

@interface PlayViewController : UIViewController<UIScrollViewDelegate, EGOImageViewDelegate, EGOImageButtonDelegate, PMusicPlayerDelegate>

@property (nonatomic, retain) EGOImageView *backgroundEGOImageView;
@property (nonatomic, retain) PCustomPlayerNavigationView *topPlayerInfoView;
@property (nonatomic, assign) int playingTipIndex;

@property (nonatomic, retain) UIScrollView *songInfoScrollView;

@property (nonatomic, retain) UILabel *lblSongInfo;
@property (nonatomic, retain) PCustomPageControl *showInfoPageControl;

@property (nonatomic, retain) IBOutlet UIView *cdOfSongView;
@property (nonatomic, retain) IBOutlet UIImageView *ivCircleProcess;
@property (nonatomic, retain) IBOutlet EGOImageView *coverOfSongEGOImageView;
@property (nonatomic, retain) IBOutlet UIImageView *cdCenterImageView;
@property (nonatomic, retain) IBOutlet EGOImageButton *cdOfSongEGOImageButton;
@property (nonatomic, retain) IBOutlet UIButton *btnPlayProcessPoint;
@property (assign) BOOL isDraging;                                          //是否在拖动进度
@property (nonatomic, assign) CGFloat lastAngle;

@property (nonatomic, retain) IBOutlet UITextView *lrcOfSongTextView;

@property (nonatomic, retain) PAAMusicPlayer *aaMusicPlayer;
@property (nonatomic, retain) PAMusicPlayer *aMusicPlayer;

@property (nonatomic, retain) PCustomPlayerMenuView *bottomPlayerMenuView;

-(IBAction)doShowLeftViewAction:(id)sender;
-(IBAction)doShareAction:(id)sender;

//下载歌曲
-(void)downloadFailed:(NSNotification *)tNotification;
-(void)downloadProcess:(NSNotification *)tNotification;
-(void)downloadSuccess:(NSNotification *)tNotification;

//播放、暂停歌曲
-(IBAction)doPlayOrPause:(id)sender;
//拖动进度按钮事件
-(IBAction)doDragBegin:(UIControl *)c withEvent:ev;
-(IBAction)doDragMoving:(UIControl *)c withEvent:ev;
-(IBAction)doDragEnd:(UIControl *)c withEvent:ev;
//播放时刷新所有对于view的数据
-(void)doUpdateForPlaying;
//显示正在播放图标
-(void)doUpdatePlayingTip;
//旋转歌曲封面
-(void)doRotateSongCover;
//根据圆圈的比率，刷新圆盘进度
-(void)doUpdateProcess;
-(void)updateProcess:(float)processRate;

-(IBAction)doRemoveAction:(id)sender;
-(IBAction)doLikeAction:(id)sender;
-(IBAction)doNextAction:(id)sender;

@end
