//
//  GeneViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "GeneViewController.h"
#import "LoginChooseViewController.h"
#import "PDatabaseManager.h"
#import "ConfigFileInfo.h"
#import "SettingViewController.h"

static int PAGE_WIDTH = 81;

@interface GeneViewController ()

@end

@implementation GeneViewController

//当前基因信息
@synthesize currentGeneView = _currentGeneView;
@synthesize btnType = _btnType;
@synthesize btnMood = _btnMood;
@synthesize btnScene = _btnScene;

@synthesize btnCurrentGene = _btnCurrentGene;
@synthesize oldGeneFrame = _oldGeneFrame;

//音乐基因
@synthesize modifyGeneView = _modifyGeneView;

@synthesize xmlParserUtil = _xmlParserUtil;
@synthesize currentChannel = _currentChannel;
@synthesize currentType = _currentType;
@synthesize currentMood = _currentMood;
@synthesize currentScene = _currentScene;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //getUpdateConfig
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUpdateConfigFailed:) name:NotificationNameUpdateConfigFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUpdateConfigSuccess:) name:NotificationNameUpdateConfigSuccess object:nil];
        
        //getTypeSongs
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTypeSongsFailed:) name:NotificationNameGetTypeSongsFailed object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTypeSongsSuccess:) name:NotificationNameGetTypeSongsSuccess object:nil];
        
    }
    return self;
}

-(void)dealloc{
    
    //getUpdateConfig
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameUpdateConfigFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameUpdateConfigSuccess object:nil];
    
    //getTypeSongs
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetTypeSongsFailed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameGetTypeSongsSuccess object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //当前基因信息
    NSArray *currentNib = [[NSBundle mainBundle] loadNibNamed:@"CurrentGeneView" owner:self options:nil];
    for (id oneObject in currentNib){
        if ([oneObject isKindOfClass:[CurrentGeneView class]]){
            _currentGeneView = (CurrentGeneView *)oneObject;
        }//if
    }//for
    _currentGeneView.frame = CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 -10);
    //date
    NSArray *monthlist = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    //year
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger uitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *comps = [calendar components:uitFlags fromDate:nowDate];
    _currentGeneView.lblYear.text = [NSString stringWithFormat:@"%d", comps.year];
    _currentGeneView.lblMonthAndDay.text = [NSString stringWithFormat:@"%@ %d", [monthlist objectAtIndex:comps.month - 1], comps.day];
    
    //avatar
    _currentGeneView.egoBtnAvatar.layer.cornerRadius = 22;
    _currentGeneView.egoBtnAvatar.layer.masksToBounds = YES;
    _currentGeneView.egoBtnAvatar.layer.borderWidth = 2;
    _currentGeneView.egoBtnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    [_currentGeneView.egoBtnAvatar addTarget:self action:@selector(doAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_currentGeneView];
    
    //类型
    _btnType = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnType.frame = CGRectMake(11.5 + 20, 45 + 10 + 100, 31, 31);
    _btnType.tag = 100;
    UIImage *typeimage = [UIImage imageWithName:@"gene_type" type:@"png"];
    [_btnType setImage:typeimage forState:UIControlStateNormal];
    [_btnType addTarget:self action:@selector(doGotoGene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnType];
    
    //心情
    _btnMood = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMood.frame = CGRectMake(11.5 + 246, 45 + 10 + 170, 31, 31);
    _btnMood.tag = 200;
    UIImage *moodimage = [UIImage imageWithName:@"gene_type" type:@"png"];
    [_btnMood setImage:moodimage forState:UIControlStateNormal];
    [_btnMood addTarget:self action:@selector(doGotoGene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnMood];
    
    //场景
    _btnScene = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnScene.frame = CGRectMake(11.5 + 20, 45 + 10 + 240, 31, 31);
    _btnScene.tag = 300;
    UIImage *sceneimage = [UIImage imageWithName:@"gene_type" type:@"png"];
    [_btnScene setImage:sceneimage forState:UIControlStateNormal];
    [_btnScene addTarget:self action:@selector(doGotoGene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnScene];
    
    //音乐基因
    NSArray *modifyNib = [[NSBundle mainBundle] loadNibNamed:@"ModifyGeneView" owner:self options:nil];
    for (id oneObject in modifyNib){
        if ([oneObject isKindOfClass:[ModifyGeneView class]]){
            _modifyGeneView = (ModifyGeneView *)oneObject;
        }//if
    }//for
    _modifyGeneView.frame = CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 -10);
    _modifyGeneView.bodyBgImageView.frame = CGRectMake(0, 0, 297, kMainScreenHeight - 45 - 10 - 10 - 73 -10);
    //返回播放信息页面
    [_modifyGeneView.btnBack addTarget:self action:@selector(doBackFromGene:) forControlEvents:UIControlEventTouchUpInside];
    
    //解析音乐基因
    [self initGeneDataFromFile];
    
    //频道
    //44 44 244 58
    int channelCount = [_xmlParserUtil.channelList count];
    _modifyGeneView.channelScrollView.backgroundColor = [UIColor clearColor];
    _modifyGeneView.channelScrollView.scrollEnabled = YES;
    _modifyGeneView.channelScrollView.showsHorizontalScrollIndicator = NO;
    _modifyGeneView.channelScrollView.showsVerticalScrollIndicator = NO;
    _modifyGeneView.channelScrollView.delegate = self;
    _modifyGeneView.channelScrollView.contentSize = CGSizeMake(PAGE_WIDTH * (channelCount+2), 50);
    _modifyGeneView.channelScrollView.tag = 200;
    
    for (int i=0; i<channelCount; i++) {
        
        Channel *tempchannel = [_xmlParserUtil.channelList objectAtIndex:i];
        
        UILabel *lblChannel = [[UILabel alloc] init];
        lblChannel.frame = CGRectMake(PAGE_WIDTH*(i+1), 8, PAGE_WIDTH, 50);
        lblChannel.backgroundColor = [UIColor clearColor];
        lblChannel.text = tempchannel.channelName;
        lblChannel.textAlignment = kTextAlignmentCenter;
        lblChannel.textColor = [UIColor whiteColor];
        lblChannel.font = [UIFont systemFontOfSize:15.0f];
        [_modifyGeneView.channelScrollView addSubview:lblChannel];
    }
    
    //类别
    int typeCount = [_xmlParserUtil.typeList count];
    _modifyGeneView.typeScrollView.backgroundColor = [UIColor clearColor];
    _modifyGeneView.typeScrollView.scrollEnabled = YES;
    _modifyGeneView.typeScrollView.showsHorizontalScrollIndicator = NO;
    _modifyGeneView.typeScrollView.showsVerticalScrollIndicator = NO;
    _modifyGeneView.typeScrollView.delegate = self;
    _modifyGeneView.typeScrollView.contentSize = CGSizeMake(PAGE_WIDTH * (typeCount+2), 50);
    _modifyGeneView.typeScrollView.tag = 201;
    
    for (int i=0; i<typeCount; i++) {
        
        Type *temptype = [_xmlParserUtil.typeList objectAtIndex:i];
        
        UILabel *lblType = [[UILabel alloc] init];
        lblType.frame = CGRectMake(PAGE_WIDTH*(i+1), 8, PAGE_WIDTH, 50);
        lblType.backgroundColor = [UIColor clearColor];
        lblType.text = temptype.name;
        lblType.textAlignment = kTextAlignmentCenter;
        lblType.textColor = [UIColor whiteColor];
        lblType.font = [UIFont systemFontOfSize:15.0f];
        [_modifyGeneView.typeScrollView addSubview:lblType];
    }
    
    //心情
    int moodCount = [_xmlParserUtil.moodList count];
    _modifyGeneView.moodScrollView.backgroundColor = [UIColor clearColor];
    _modifyGeneView.moodScrollView.scrollEnabled = YES;
    _modifyGeneView.moodScrollView.showsHorizontalScrollIndicator = NO;
    _modifyGeneView.moodScrollView.showsVerticalScrollIndicator = NO;
    _modifyGeneView.moodScrollView.delegate = self;
    _modifyGeneView.moodScrollView.contentSize = CGSizeMake(PAGE_WIDTH * (moodCount+2), 50);
    _modifyGeneView.moodScrollView.tag = 202;
    
    for (int i=0; i<moodCount; i++) {
        
        Mood *tempmood = [_xmlParserUtil.moodList objectAtIndex:i];
        
        UILabel *lblMood = [[UILabel alloc] init];
        lblMood.frame = CGRectMake(PAGE_WIDTH*(i+1), 8, PAGE_WIDTH, 50);
        lblMood.backgroundColor = [UIColor clearColor];
        lblMood.text = tempmood.name;
        lblMood.textAlignment = kTextAlignmentCenter;
        lblMood.textColor = [UIColor whiteColor];
        lblMood.font = [UIFont systemFontOfSize:15.0f];
        [_modifyGeneView.moodScrollView addSubview:lblMood];
    }
    
    //场景
    int sceneCount = [_xmlParserUtil.sceneList count];
    _modifyGeneView.sceneScrollView.backgroundColor = [UIColor clearColor];
    _modifyGeneView.sceneScrollView.scrollEnabled = YES;
    _modifyGeneView.sceneScrollView.showsHorizontalScrollIndicator = NO;
    _modifyGeneView.sceneScrollView.showsVerticalScrollIndicator = NO;
    _modifyGeneView.sceneScrollView.delegate = self;
    _modifyGeneView.sceneScrollView.contentSize = CGSizeMake(PAGE_WIDTH * (sceneCount+2), 50);
    _modifyGeneView.sceneScrollView.tag = 203;
    
    for (int i=0; i<sceneCount; i++) {
        
        Scene *tempscene = [_xmlParserUtil.sceneList objectAtIndex:i];
        
        UILabel *lblScene = [[UILabel alloc] init];
        lblScene.frame = CGRectMake(PAGE_WIDTH*(i+1), 8, PAGE_WIDTH, 50);
        lblScene.backgroundColor = [UIColor clearColor];
        lblScene.text = tempscene.name;
        lblScene.textAlignment = kTextAlignmentCenter;
        lblScene.textColor = [UIColor whiteColor];
        lblScene.font = [UIFont systemFontOfSize:15.0f];
        [_modifyGeneView.sceneScrollView addSubview:lblScene];
    }
    
    [self.view addSubview:_modifyGeneView];
    _modifyGeneView.hidden = YES;
    
    //init gene 4 show
    [self initGeneDataByCache];
    
    //加载歌曲
    [self loadTypeSongs];
    
    //检查更新
    [self checkGeneConfigfile];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//解析音乐基因数据
-(void)initGeneDataFromFile{
    
    PLog(@"initGeneDataFromFile...");
    
    NSString *channelInfoXmlPath = [[NSBundle mainBundle] pathForResource:@"channelinfo" ofType:@"xml"];
    NSLog(@"channelInfoXmlPath: %@", channelInfoXmlPath);
    
    NSData *channelInfoXmlData = [[NSData alloc] initWithContentsOfFile:channelInfoXmlPath];
    
    _xmlParserUtil = [[XmlParserUtil alloc] initWithParserDefaultElement];
    [_xmlParserUtil parserXml:channelInfoXmlData];
    
}

-(void)initGeneDataByCache{
    
    PLog(@"initGeneDataByCache...");
    
    @try {
        
        UserGene *tempusergene = [[PDatabaseManager GetInstance] getUserGeneByUserId:[UserSessionManager GetInstance].userid];
        if (tempusergene) {
            
            tempusergene.channel = [_xmlParserUtil.channelList objectAtIndex:tempusergene.channel.channelIndex];
            tempusergene.type = [_xmlParserUtil.typeList objectAtIndex:tempusergene.type.typeIndex];
            tempusergene.mood = [_xmlParserUtil.moodList objectAtIndex:tempusergene.mood.moodIndex];
            tempusergene.scene = [_xmlParserUtil.sceneList objectAtIndex:tempusergene.scene.sceneIndex];
            
            [UserSessionManager GetInstance].currentUserGene = tempusergene;
            
        } else {
            
            tempusergene = [UserSessionManager GetInstance].currentUserGene;
            tempusergene.channel = [_xmlParserUtil.channelList objectAtIndex:3];
            tempusergene.type = [_xmlParserUtil.typeList objectAtIndex:tempusergene.channel.typeindex];
            tempusergene.mood = [_xmlParserUtil.moodList objectAtIndex:tempusergene.channel.moodindex];
            tempusergene.scene = [_xmlParserUtil.sceneList objectAtIndex:tempusergene.channel.sceneindex];
            
        }
        
        [self initGeneByUserGene:tempusergene];
        
    }
    @catch (NSException *exception) {
        PLog(@"initGeneDataByCache failed...please check");
        [SVProgressHUD showErrorWithStatus:@"初始化音乐基因出错:("];
    }
    
}

-(void)initGeneByUserGene:(UserGene *)usergene{
    
    [self initGene:usergene.channel typeIndex:usergene.type.typeIndex moodIndex:usergene.mood.moodIndex sceneIndex:usergene.scene.sceneIndex];
    
}

-(void)initGene:(Channel *)tchannel typeIndex:(int)ttypeindex moodIndex:(int)tmoodindex sceneIndex:(int)tsceneindex{
    
    [tchannel log];
    PLog(@"tchannel.channelId(%@), tchannel.channelName(%@), tchannel.channelIndex(%d), ttypeindex(%d), tmoodindex(%d), tsceneindex(%d)", tchannel.channelId, tchannel.channelName, tchannel.channelIndex, ttypeindex, tmoodindex, tsceneindex);
    
    int currentchannelindex = tchannel.channelIndex;
    if (currentchannelindex >= 0) {
        
        int currentChannelPosition = currentchannelindex;
        [_modifyGeneView.channelScrollView setContentOffset:CGPointMake(currentChannelPosition*PAGE_WIDTH, 0) animated:YES];
        
        int currentTypePosition = tchannel.typeindex;
        [_modifyGeneView.typeScrollView setContentOffset:CGPointMake(currentTypePosition*PAGE_WIDTH, 0) animated:YES];
        
        int currentMoodPosition = tchannel.moodindex;
        [_modifyGeneView.moodScrollView setContentOffset:CGPointMake(currentMoodPosition*PAGE_WIDTH, 0) animated:YES];
        
        int currentScenePosition = tchannel.sceneindex;
        [_modifyGeneView.sceneScrollView setContentOffset:CGPointMake(currentScenePosition*PAGE_WIDTH, 0) animated:YES];
        
    } else {
        
        int currentTypePosition = ttypeindex;
        [_modifyGeneView.typeScrollView setContentOffset:CGPointMake(currentTypePosition*PAGE_WIDTH, 0) animated:YES];
        
        int currentMoodPosition = tmoodindex;
        [_modifyGeneView.moodScrollView setContentOffset:CGPointMake(currentMoodPosition*PAGE_WIDTH, 0) animated:YES];
        
        int currentScenePosition = tsceneindex;
        [_modifyGeneView.sceneScrollView setContentOffset:CGPointMake(currentScenePosition*PAGE_WIDTH, 0) animated:YES];
        
    }
    
}

//根据音乐基因获取歌曲
-(void)loadTypeSongs{
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
        NSString *tmoodid = [NSString stringWithFormat:@"%d", usergene.mood.typeid];
        NSString *tmoodnum = [NSString stringWithFormat:@"%d", usergene.mood.changenum];
        NSString *tsceneid = [NSString stringWithFormat:@"%d", usergene.scene.typeid];
        NSString *tscenenum = [NSString stringWithFormat:@"%d", usergene.scene.changenum];
        NSString *tchannelid = [NSString stringWithFormat:@"%@", usergene.channel.channelId];
        NSString *tchannelnum = [NSString stringWithFormat:@"%d", usergene.channel.changenum];
        
        //type
        UIImage *typeimage = [UIImage imageNamed:usergene.type.picname];
        [_btnType setImage:typeimage forState:UIControlStateNormal];
        _currentGeneView.typeImageView.image = typeimage;
        _currentGeneView.lblTypeDesc.text = usergene.type.desc;
        
        //mood
        UIImage *moodimage = [UIImage imageNamed:usergene.mood.picname];
        [_btnMood setImage:moodimage forState:UIControlStateNormal];
        _currentGeneView.moodImageView.image = moodimage;
        _currentGeneView.lblMoodDesc.text = usergene.mood.desc;
        
        //scene
        UIImage *sceneimage = [UIImage imageNamed:usergene.scene.picname];
        [_btnScene setImage:sceneimage forState:UIControlStateNormal];
        _currentGeneView.sceneImageView.image = sceneimage;
        _currentGeneView.lblSceneDesc.text = usergene.scene.desc;
        
        //记录音乐基因
        [[PDatabaseManager GetInstance] insertUserGene:usergene userId:userid];
        
        [self.miglabAPI doGetTypeSongs:userid token:accesstoken moodid:tmoodid moodindex:tmoodnum sceneid:tsceneid sceneindex:tscenenum channelid:tchannelid channelindex:tchannelnum num:@"5"];
        
    } else {
        [SVProgressHUD showErrorWithStatus:@"您还未登陆哦～"];
    }
    
}

-(void)checkGeneConfigfile{
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        NSString *userid = [UserSessionManager GetInstance].userid;
        NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
        
        [self.miglabAPI doUpdateConfigfile:userid token:accesstoken version:[NSString stringWithFormat:@"%lld", _xmlParserUtil.version]];
    }

    
}

-(IBAction)doAvatar:(id)sender{
    
    PLog(@"gene doAvatar...");
    
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:settingViewController animated:YES];
        
    } else {
        
        LoginChooseViewController *loginChooseViewController = [[LoginChooseViewController alloc] initWithNibName:@"LoginChooseViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:loginChooseViewController animated:YES];
        
    }
    
    
}

-(IBAction)doGotoGene:(id)sender{
    
    PLog(@"doGotoGene...");
    
    UserGene *currentUserGene = [UserSessionManager GetInstance].currentUserGene;
    currentUserGene.type.changenum = 0;
    currentUserGene.mood.changenum = 0;
    currentUserGene.scene.changenum = 0;
    
    //
//    [self initGeneByUserGene:currentUserGene];
    
    _btnCurrentGene = sender;
    _oldGeneFrame = _btnCurrentGene.frame;
    
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        _btnCurrentGene.frame = _modifyGeneView.frame;
        _btnCurrentGene.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        _btnType.hidden = YES;
        _btnMood.hidden = YES;
        _btnScene.hidden = YES;
        _currentGeneView.hidden = YES;
        
        _btnCurrentGene.hidden = YES;
        _modifyGeneView.hidden = NO;
        
    }];
    
    /*
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        _btnCurrentGene.frame = _modifyGeneView.frame;
        _btnCurrentGene.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        _btnType.hidden = YES;
        _btnMood.hidden = YES;
        _btnScene.hidden = YES;
        _currentGeneView.hidden = YES;
        
        _btnCurrentGene.hidden = YES;
        _modifyGeneView.hidden = NO;
        _modifyGeneView.alpha = 0.0f;
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
            
            _modifyGeneView.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    */
    
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    NSInteger first = [[self.view subviews] indexOfObject:_currentGeneView];
    NSInteger seconde = [[self.view subviews] indexOfObject:_modifyGeneView];
    
    [self.view exchangeSubviewAtIndex:first withSubviewAtIndex:seconde];
    
    
    _currentGeneView.hidden = YES;
    _modifyGeneView.hidden = NO;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    */
    
}

-(IBAction)doBackFromGene:(id)sender{
    
    PLog(@"doBackFromGene...");
    
    _modifyGeneView.hidden = YES;
    
    _btnType.hidden = NO;
    _btnMood.hidden = NO;
    _btnScene.hidden = NO;
    _currentGeneView.hidden = NO;
    _btnCurrentGene.hidden = NO;
    _btnCurrentGene.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        _btnCurrentGene.frame = _oldGeneFrame;
        _btnCurrentGene.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        
    }];
    
    //
    [self loadTypeSongs];
    
    /*
    NSString *userid = [UserSessionManager GetInstance].userid;
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
    NSString *tmoodid = [NSString stringWithFormat:@"%d", usergene.mood.typeid];
    NSString *tmoodindex = [NSString stringWithFormat:@"%d", usergene.mood.moodIndex];
    NSString *tsceneid = [NSString stringWithFormat:@"%d", usergene.scene.typeid];
    NSString *tsceneindex = [NSString stringWithFormat:@"%d", usergene.scene.sceneIndex];
    NSString *tchannelid = [NSString stringWithFormat:@"%@", usergene.channel.channelId];
    NSString *tchannelindex = [NSString stringWithFormat:@"%d", usergene.channel.channelIndex];
    
    [self.miglabAPI doGetTypeSongs:userid token:accesstoken moodid:tmoodid moodindex:tmoodindex sceneid:tsceneid sceneindex:tsceneindex channelid:tchannelid channelindex:tchannelindex num:@"5"];
    */
    
    /*
    _modifyGeneView.alpha = 1.0f;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
        
        _modifyGeneView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        _modifyGeneView.hidden = YES;
        _btnCurrentGene.hidden = NO;
        _btnCurrentGene.alpha = 0.0f;
        //
        _btnType.hidden = NO;
        _btnMood.hidden = NO;
        _btnScene.hidden = NO;
        _currentGeneView.hidden = NO;
        
        [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
            
            _btnCurrentGene.frame = _oldGeneFrame;
            _btnCurrentGene.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
            _btnCurrentGene.hidden = NO;
            
        }];
        
    }];
    */
    
    /*
    _modifyGeneView.alpha = 1.0f;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
        
        _modifyGeneView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        _modifyGeneView.hidden = YES;
        _btnType.hidden = NO;
        _btnType.alpha = 0.0f;
        
        [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
            
            _btnType.frame = CGRectMake(31, 133, 73, 44);
            _btnType.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
            _btnType.hidden = NO;
            
        }];
        
    }];
    */
    
    /*
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    _currentGeneView.hidden = NO;
    _modifyGeneView.hidden = YES;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    */
    
}

#pragma UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (!decelerate) {
        int x = scrollView.contentOffset.x;
        int pageIndex = x / PAGE_WIDTH;
        
        if ((x % PAGE_WIDTH) > PAGE_WIDTH / 2) {
            pageIndex++;
        }
        [scrollView setContentOffset:CGPointMake(pageIndex*PAGE_WIDTH, 0) animated:YES];
        
        int channelCount = [_xmlParserUtil.channelList count];
        if (scrollView.tag == 200 && pageIndex < channelCount) {
            
            Channel *tempchannel = [_xmlParserUtil.channelList objectAtIndex:pageIndex];
            [tempchannel log];
            
            UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
            usergene.channel = tempchannel;
            usergene.channel.changenum++;
            usergene.type = [_xmlParserUtil.typeList objectAtIndex:tempchannel.typeindex];
            usergene.mood = [_xmlParserUtil.moodList objectAtIndex:tempchannel.moodindex];
            usergene.scene = [_xmlParserUtil.sceneList objectAtIndex:tempchannel.sceneindex];
            [self initGeneByUserGene:usergene];
            
        } else if (scrollView.tag == 201) {
            
            Type *temptype = [_xmlParserUtil.typeList objectAtIndex:pageIndex];
            [temptype log];
            
            UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
            usergene.type = temptype;
            usergene.type.changenum++;
            
        } else if (scrollView.tag == 202) {
            
            Mood *tempmood = [_xmlParserUtil.moodList objectAtIndex:pageIndex];
            [tempmood log];
            
            UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
            usergene.mood = tempmood;
            usergene.mood.changenum++;
            
        } else if (scrollView.tag == 203) {
            
            Scene *tempscene = [_xmlParserUtil.sceneList objectAtIndex:pageIndex];
            [tempscene log];
            
            UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
            usergene.scene = tempscene;
            usergene.scene.changenum++;
            
        }
        
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int x = scrollView.contentOffset.x;
    int pageIndex = x / PAGE_WIDTH;
    
    if ((x % PAGE_WIDTH) > PAGE_WIDTH / 2) {
        pageIndex++;
    }
    [scrollView setContentOffset:CGPointMake(pageIndex*PAGE_WIDTH, 0) animated:YES];
    
    int channelCount = [_xmlParserUtil.channelList count];
    if (scrollView.tag == 200 && pageIndex < channelCount) {
        
        Channel *tempchannel = [_xmlParserUtil.channelList objectAtIndex:pageIndex];
        [tempchannel log];
        
        UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
        usergene.channel = tempchannel;
        usergene.type = [_xmlParserUtil.typeList objectAtIndex:tempchannel.typeindex];
        usergene.mood = [_xmlParserUtil.moodList objectAtIndex:tempchannel.moodindex];
        usergene.scene = [_xmlParserUtil.sceneList objectAtIndex:tempchannel.sceneindex];
        [self initGeneByUserGene:usergene];
        
    } else if (scrollView.tag == 201) {
        
        Type *temptype = [_xmlParserUtil.typeList objectAtIndex:pageIndex];
        [temptype log];
        
        UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
        usergene.type = temptype;
        
    } else if (scrollView.tag == 202) {
        
        Mood *tempmood = [_xmlParserUtil.moodList objectAtIndex:pageIndex];
        [tempmood log];
        
        UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
        usergene.mood = tempmood;
        
    } else if (scrollView.tag == 203) {
        
        Scene *tempscene = [_xmlParserUtil.sceneList objectAtIndex:pageIndex];
        [tempscene log];
        
        UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
        usergene.scene = tempscene;
        
    }
    
}

#pragma notification

-(void)getUpdateConfigFailed:(NSNotification *)tNotification{
    
    PLog(@"getUpdateConfigFailed...");
    
}

-(void)getUpdateConfigSuccess:(NSNotification *)tNotification{
    
    //todo
    /*
     * 判断是否需要更新
     * 然后下载新的数据更新
     */
    NSDictionary *result = [tNotification userInfo];
    ConfigFileInfo *configInfo = [result objectForKey:@"result"];
    
}

//getTypeSongsFailed notification
-(void)getTypeSongsFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"getTypeSongsFailed...%@", [result objectForKey:@"msg"]);
    [SVProgressHUD showErrorWithStatus:@"根据纬度获取歌曲失败:("];
    
}

-(void)getTypeSongsSuccess:(NSNotification *)tNotification{
    
    PLog(@"getModeMusicSuccess...");
    NSDictionary *result = [tNotification userInfo];
    NSMutableArray *songInfoList = [result objectForKey:@"result"];
    [[PDatabaseManager GetInstance] insertSongInfoList:songInfoList];
    
    NSMutableArray *tempsonglist = [[PDatabaseManager GetInstance] getSongInfoList:20];
    [[PPlayerManagerCenter GetInstance].songList addObjectsFromArray:tempsonglist];
    
    [SVProgressHUD showErrorWithStatus:@"根据纬度获取歌曲成功:)"];
    
}

@end
