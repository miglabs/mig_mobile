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

@interface GeneViewController : PlayerViewController<UIScrollViewDelegate>

//当前基因信息
@property (nonatomic, retain) CurrentGeneView *currentGeneView;
@property (nonatomic, retain) UIButton *btnType;
@property (nonatomic, retain) UIButton *btnMood;
@property (nonatomic, retain) UIButton *btnScene;

@property (nonatomic, retain) UIButton *btnCurrentGene;
@property (nonatomic, assign) CGRect oldGeneFrame;

//音乐基因
@property (nonatomic, retain) ModifyGeneView *modifyGeneView;

@property (nonatomic, retain) XmlParserUtil *xmlParserUtil;
@property (nonatomic, retain) Channel *currentChannel;
@property (nonatomic, retain) Type *currentType;
@property (nonatomic, retain) Mood *currentMood;
@property (nonatomic, retain) Scene *currentScene;

-(IBAction)doAvatar:(id)sender;

-(IBAction)doGotoGene:(id)sender;
-(IBAction)doBackFromGene:(id)sender;

//解析音乐基因数据
-(void)initGeneDataFromFile;
-(void)initGeneDataByCache;
-(void)initGeneByUserGene:(UserGene *)usergene;
-(void)initGene:(Channel *)tchannel typeIndex:(int)ttypeindex moodIndex:(int)tmoodindex sceneIndex:(int)tsceneindex;
-(void)loadTypeSongs;   //根据音乐基因获取歌曲
-(void)checkGeneConfigfile;

-(void)getUpdateConfigFailed:(NSNotification *)tNotification;
-(void)getUpdateConfigSuccess:(NSNotification *)tNotification;

-(void)getTypeSongsFailed:(NSNotification *)tNotification;
-(void)getTypeSongsSuccess:(NSNotification *)tNotification;

@end
