//
//  GeneViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"
#import "CurrentGeneView.h"
#import "ModifyGeneView.h"
#import "XmlParserUtil.h"
#import "Channel.h"
#import "Type.h"
#import "Mood.h"
#import "Scene.h"
#import "GeneGuideView.h"

@interface GeneViewController : PlayerViewController<UIScrollViewDelegate, PPlayerManagerCenterDelegate>

//当前基因信息
@property (nonatomic, retain) CurrentGeneView *currentGeneView;
@property (nonatomic, retain) NSArray *monthlist;
@property (nonatomic, retain) UIButton *btnType;
@property (nonatomic, retain) UIButton *btnMood;
@property (nonatomic, retain) UIButton *btnScene;

@property (nonatomic, retain) UIButton *btnCurrentGene;
@property (nonatomic, assign) CGRect oldGeneFrame;

//音乐基因
@property (nonatomic, assign) BOOL isChannelLock;
@property (nonatomic, retain) ModifyGeneView *modifyGeneView;

@property (nonatomic, retain) XmlParserUtil *xmlParserUtil;
@property (nonatomic, retain) Channel *currentChannel;
@property (nonatomic, retain) Type *currentType;
@property (nonatomic, retain) Mood *currentMood;
@property (nonatomic, retain) Scene *currentScene;

@property (nonatomic, retain) UIImageView* focusImageView;

@property (nonatomic, assign) BOOL isUpdatedList;

//基因界面帮助显示
@property (nonatomic, retain) UIScrollView* mainGuideScrollView;
@property (nonatomic, retain) UIPageControl* mainGuidePageControl;
@property (nonatomic, retain) UIImageView* imgGeneView;

//弹幕
@property (nonatomic, retain) UIImageView *bgBarrageImageView;
@property (nonatomic, retain) UIButton *btnBarrage;

//引导
@property (nonatomic, strong) GeneGuideView *geneGuideView;

-(IBAction)doAvatar:(id)sender;

-(IBAction)doGotoGene:(id)sender;
-(IBAction)doBackFromGene:(id)sender;
//频道锁定开关
-(IBAction)doSwitchLockAction:(id)sender;
-(void)doResetChannelLockView;

-(IBAction)doUpdatePlayList:(id)sender;

//更新日期显示
-(void)updateDate;

//解析音乐基因数据
-(void)initGeneDataFromFile;
-(void)initGeneDataByCache;
-(void)initGeneByUserGene:(UserGene *)usergene;
-(void)initGene:(Channel *)tchannel typeIndex:(int)ttypeindex moodIndex:(int)tmoodindex sceneIndex:(int)tsceneindex;
-(void)loadSongsByGene;   //根据音乐基因获取歌曲
-(void)checkGeneConfigfile;
-(void)updateGeneDisplay:(Song*)song;

-(void)getUpdateConfigFailed:(NSNotification *)tNotification;
-(void)getUpdateConfigSuccess:(NSNotification *)tNotification;

-(void)getTypeSongsFailed:(NSNotification *)tNotification;
-(void)getTypeSongsSuccess:(NSNotification *)tNotification;

//获取天气和城市
-(void)getLocationnInfoSuccess:(NSNotification *)tNotification;
-(void)getLocationnInfoFailed:(NSNotification *)tNotification;


//引导界面
-(void)finishCurrentGuide;
-(void)pageTurn:(UIPageControl*)sender;

// 新增消息
-(void)getNewMsgCount:(NSString*)userid token:(NSString*)ttoken radius:(NSString*)tradius location:(NSString*)tlocation;
-(void)getNewMsgCountSucceed:(NSNotification *)tNotification;
-(void)getNewMsgCountFailed:(NSNotification *)tNotification;

@end
