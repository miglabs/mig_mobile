//
//  GeneViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "GeneViewController.h"
#import "PDatabaseManager.h"
#import "ConfigFileInfo.h"
#import "SettingViewController.h"
#import "LoginMenuViewController.h"

static int PAGE_WIDTH = 81;

@interface GeneViewController ()

@end

@implementation GeneViewController

//当前基因信息
@synthesize currentGeneView = _currentGeneView;
@synthesize monthlist = _monthlist;
@synthesize btnType = _btnType;
@synthesize btnMood = _btnMood;
@synthesize btnScene = _btnScene;

@synthesize btnCurrentGene = _btnCurrentGene;
@synthesize oldGeneFrame = _oldGeneFrame;

//音乐基因
@synthesize isChannelLock = _isChannelLock;
@synthesize modifyGeneView = _modifyGeneView;

@synthesize xmlParserUtil = _xmlParserUtil;
@synthesize currentChannel = _currentChannel;
@synthesize currentType = _currentType;
@synthesize currentMood = _currentMood;
@synthesize currentScene = _currentScene;

@synthesize focusImageView = _focusImageView;

@synthesize isUpdatedList = _isUpdatedList;

@synthesize mainGuidePageControl = _mainGuidePageControl;
@synthesize mainGuideScrollView = _mainGuideScrollView;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doUpdatePlayList:) name:NotificationNameNeedAddList object:nil];
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NotificationNameNeedAddList object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _isUpdatedList = NO;
    
    //nav
    CGRect navViewFrame = self.navView.frame;
    float posy = navViewFrame.origin.y + navViewFrame.size.height;//ios6-44, ios7-64
    
    //当前基因信息
    NSArray *currentNib = [[NSBundle mainBundle] loadNibNamed:@"CurrentGeneView" owner:self options:nil];
    for (id oneObject in currentNib){
        if ([oneObject isKindOfClass:[CurrentGeneView class]]){
            _currentGeneView = (CurrentGeneView *)oneObject;
        }//if
    }//for
    _currentGeneView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 -10);
    //month --date
    _monthlist = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    //date
    _currentGeneView.lblYear.textColor = [UIColor darkGrayColor];
    _currentGeneView.lblYear.font = [UIFont fontOfApp:20.0f];
    _currentGeneView.lblMonthAndDay.textColor = [UIColor darkGrayColor];
    _currentGeneView.lblMonthAndDay.font = [UIFont fontOfApp:18.0f];
    
    //avatar
    _currentGeneView.egoBtnAvatar.layer.cornerRadius = AVATAR_RADIUS;
    _currentGeneView.egoBtnAvatar.layer.masksToBounds = YES;
    _currentGeneView.egoBtnAvatar.layer.borderWidth = AVATAR_BORDER_WIDTH;
    _currentGeneView.egoBtnAvatar.layer.borderColor = AVATAR_BORDER_COLOR;
    [_currentGeneView.egoBtnAvatar addTarget:self action:@selector(doAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_currentGeneView];
    
    //desc
    _currentGeneView.lblTypeDesc.textColor = [UIColor darkGrayColor];
    _currentGeneView.lblTypeDesc.font = [UIFont fontOfApp:20.0f];
    _currentGeneView.lblMoodDesc.textColor = [UIColor darkGrayColor];
    _currentGeneView.lblMoodDesc.font = [UIFont fontOfApp:20.0f];
    _currentGeneView.lblSceneDesc.textColor = [UIColor darkGrayColor];
    _currentGeneView.lblSceneDesc.font = [UIFont fontOfApp:20.0f];
    
    //类型
    _btnType = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnType.frame = CGRectMake(11.5 + 20, posy + 10 + 100, 31, 31);
    _btnType.tag = 100;
    UIImage *typeimage = [UIImage imageWithName:@"gene_type" type:@"png"];
    [_btnType setImage:typeimage forState:UIControlStateNormal];
    [_btnType addTarget:self action:@selector(doGotoGene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnType];
    
    //心情
    _btnMood = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMood.frame = CGRectMake(11.5 + 246, posy + 10 + 170, 31, 31);
    _btnMood.tag = 200;
    UIImage *moodimage = [UIImage imageWithName:@"gene_type" type:@"png"];
    [_btnMood setImage:moodimage forState:UIControlStateNormal];
    [_btnMood addTarget:self action:@selector(doGotoGene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnMood];
    
    //场景
    _btnScene = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnScene.frame = CGRectMake(11.5 + 20, posy + 10 + 240, 31, 31);
    _btnScene.tag = 300;
    UIImage *sceneimage = [UIImage imageWithName:@"gene_type" type:@"png"];
    [_btnScene setImage:sceneimage forState:UIControlStateNormal];
    [_btnScene addTarget:self action:@selector(doGotoGene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnScene];
    
    //是否锁定频道
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"IsChannelLock"]) {
        _isChannelLock = YES;
    } else {
        _isChannelLock = NO;
    }
    
    //音乐基因
    NSArray *modifyNib = [[NSBundle mainBundle] loadNibNamed:@"ModifyGeneView" owner:self options:nil];
    for (id oneObject in modifyNib){
        if ([oneObject isKindOfClass:[ModifyGeneView class]]){
            _modifyGeneView = (ModifyGeneView *)oneObject;
        }//if
    }//for
    _modifyGeneView.frame = CGRectMake(11.5, posy + 10, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 -10);
    _modifyGeneView.bodyBgImageView.frame = CGRectMake(0, 0, 297, kMainScreenHeight + self.topDistance - posy - 10 - 10 - 73 -10);
    //返回播放信息页面
    [_modifyGeneView.btnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_modifyGeneView.btnBack setTitle:@"确定" forState:UIControlStateNormal];
    [_modifyGeneView.btnBack addTarget:self action:@selector(doBackFromGene:) forControlEvents:UIControlEventTouchUpInside];
    
    float tempposx = 285;
    CGRect switchChannelFrame = _modifyGeneView.switchChannelLock.frame;
    _modifyGeneView.switchChannelLock.frame = CGRectMake(tempposx-switchChannelFrame.size.width, (44-switchChannelFrame.size.height)/2, switchChannelFrame.size.width, switchChannelFrame.size.height);
    _modifyGeneView.switchChannelLock.on = _isChannelLock;//是否锁定频道
    [_modifyGeneView.switchChannelLock addTarget:self action:@selector(doSwitchLockAction:) forControlEvents:UIControlEventValueChanged];
    CGRect lockDesc = _modifyGeneView.lblChannelLock.frame;
    _modifyGeneView.lblChannelLock.frame = CGRectMake(tempposx-switchChannelFrame.size.width-lockDesc.size.width, lockDesc.origin.y, lockDesc.size.width, lockDesc.size.height);
    _modifyGeneView.lblChannel.font = [UIFont fontOfApp:17.0f];
    _modifyGeneView.lblType.font = [UIFont fontOfApp:17.0f];
    _modifyGeneView.lblMood.font = [UIFont fontOfApp:17.0f];
    _modifyGeneView.lblScene.font = [UIFont fontOfApp:17.0f];
    
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
        lblChannel.font = [UIFont fontOfApp:15.0f];
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
        lblType.font = [UIFont fontOfApp:15.0f];
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
        lblMood.font = [UIFont fontOfApp:15.0f];
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
        lblScene.font = [UIFont fontOfApp:15.0f];
        [_modifyGeneView.sceneScrollView addSubview:lblScene];
    }
    
    [self.view addSubview:_modifyGeneView];
    _modifyGeneView.hidden = YES;
    
    // 初始化类型的白框焦点
    _focusImageView = [[UIImageView alloc] init];
    [self.view addSubview:_focusImageView];
    _focusImageView.hidden = YES;
    
    //init gene 4 show
    [self initGeneDataByCache];
    
    //加载歌曲
    [self loadSongsByGene];
    
    //检查更新
    [self checkGeneConfigfile];
    
    //
    [self doResetChannelLockView];
    
    [PPlayerManagerCenter GetInstance].delegate = self;
    
    if ([UserSessionManager GetInstance].isMainMenuFirstLaunch) {
        
        float height = [UIScreen mainScreen].bounds.size.height;
        double version = [[UIDevice currentDevice].systemVersion doubleValue];
        float heightoffset = version >= 7 ? 0 : 6;
        
        _mainGuideScrollView = [[UIScrollView alloc] init];
        _mainGuideScrollView.frame = CGRectMake(0, heightoffset, 320, height - heightoffset);
        _mainGuideScrollView.scrollEnabled = YES;
        _mainGuideScrollView.showsHorizontalScrollIndicator = NO;
        _mainGuideScrollView.pagingEnabled = YES;
        _mainGuideScrollView.delegate = self;
        _mainGuideScrollView.bounces = NO;
        [_mainGuideScrollView setTag:2];
        
        _mainGuideScrollView.contentSize = CGSizeMake(320 * GUIDE_MAIN_NUMBER, height);
        for (int i=0; i<GUIDE_MAIN_NUMBER; i++) {
            
            NSString* imgName = [NSString stringWithFormat:@"guide_%d", i+1];
            UIImageView* imgView = [[UIImageView alloc] init];
            imgView.frame = CGRectMake(320 * i, 0, 320, height);
            imgView.image = [UIImage imageWithName:imgName type:@"png"];
            //imgView.alpha = 0.9f;
            [_mainGuideScrollView addSubview:imgView];
        }
        
        UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
        btnStart.frame = CGRectMake(320 * 3 + 60, height - 150, 200, 100);
        btnStart.backgroundColor = [UIColor clearColor];
        btnStart.alpha = 0.4f;
        [btnStart addTarget:self action:@selector(finishCurrentGuide) forControlEvents:UIControlEventTouchUpInside];
        [_mainGuideScrollView addSubview:btnStart];
        
        [self.view addSubview:_mainGuideScrollView];
        
        _mainGuidePageControl = [[UIPageControl alloc] init];
        _mainGuidePageControl.frame = CGRectMake(0, height - 40, 320, 16);
        _mainGuidePageControl.numberOfPages = GUIDE_MAIN_NUMBER;
        _mainGuidePageControl.currentPage = 0;
        _mainGuidePageControl.backgroundColor = [UIColor clearColor];
        [_mainGuidePageControl addTarget:self action:@selector(pageTurn) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_mainGuidePageControl];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //刷新日期
    [self updateDate];
    
    // 刷新头像
    NSString* userHeadUrl = [UserSessionManager GetInstance].currentUser.head;
    if (userHeadUrl && [UserSessionManager GetInstance].isLoggedIn) {
        
        _currentGeneView.egoBtnAvatar.imageURL = [NSURL URLWithString:userHeadUrl];
    }
    else {
        
        _currentGeneView.egoBtnAvatar.imageURL = [NSURL URLWithString:URL_DEFAULT_HEADER_IMAGE];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//更新日期显示
-(void)updateDate{
    
    //date
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger uitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDate *nowDate = [NSDate date];
    NSDateComponents *comps = [calendar components:uitFlags fromDate:nowDate];
    _currentGeneView.lblYear.text = [NSString stringWithFormat:@"%d", comps.year];
    NSString *strMonthAndDay = [NSString stringWithFormat:@"%@ %d", [_monthlist objectAtIndex:comps.month - 1], comps.day];
    PLog(@"strMonthAndDay: %@, strMonthAndDay.length: %d", strMonthAndDay, strMonthAndDay.length);
//    _currentGeneView.lblMonthAndDay.text = [NSString stringWithFormat:@"%@ %d", [_monthlist objectAtIndex:comps.month - 1], comps.day];
    [_currentGeneView.lblMonthAndDay setText:strMonthAndDay afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        UIColor *dayColor = [UIColor colorWithRed:92.0f/255.0f green:210.0f/255.0f blue:248.0f/255.0f alpha:1.0f];
        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)[dayColor CGColor] range:NSMakeRange(4, strMonthAndDay.length - 4)];
        return mutableAttributedString;
    }];
    
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
            
        } else {
            
            tempusergene = [UserSessionManager GetInstance].currentUserGene;
            tempusergene.channel = [_xmlParserUtil.channelList objectAtIndex:3];
            tempusergene.type = [_xmlParserUtil.typeList objectAtIndex:tempusergene.channel.typeindex];
            tempusergene.mood = [_xmlParserUtil.moodList objectAtIndex:tempusergene.channel.moodindex];
            tempusergene.scene = [_xmlParserUtil.sceneList objectAtIndex:tempusergene.channel.sceneindex];
            
        }
        
        // 无论是否获取到一个用户的音乐基因，都需要给当前分配一个基因
        [UserSessionManager GetInstance].currentUserGene = tempusergene;
        
        [self initGeneByUserGene:tempusergene];
        
    }
    @catch (NSException *exception) {
        PLog(@"initGeneDataByCache failed...please check");
        //[SVProgressHUD showErrorWithStatus:@"初始化音乐基因出错:("];
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
-(void)loadSongsByGene{
    
    UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
    
    if (usergene) {
        
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
    }
    
    // 如果用户已经登陆，则载入歌曲，保存基因到数据库
    if ([UserSessionManager GetInstance].isLoggedIn) {
        
        //记录音乐基因
        NSString *userid = [UserSessionManager GetInstance].userid;
        [[PDatabaseManager GetInstance] insertUserGene:usergene userId:userid];
        
        [super loadTypeSongs];
        
    } else {
        [SVProgressHUD showErrorWithStatus:MIGTIP_UNLOGIN];
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
        
        SettingViewController *settingViewController = [[SettingViewController alloc] init];
        [self.topViewcontroller.navigationController pushViewController:settingViewController animated:YES];
        
    } else {
        
        LoginMenuViewController *loginMenuViewController = [[LoginMenuViewController alloc] initWithNibName:@"LoginMenuViewController" bundle:nil];
        [self.topViewcontroller.navigationController pushViewController:loginMenuViewController animated:YES];
        
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
        _focusImageView.hidden = YES;
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
    _focusImageView.hidden = NO;
    _btnCurrentGene.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6f delay:0.0f options:UIViewAnimationCurveLinear animations:^{
        
        _btnCurrentGene.frame = _oldGeneFrame;
        _btnCurrentGene.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        [_currentGeneView setNeedsDisplay];
        
    }];
    
    //
    [self loadSongsByGene];
    
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

//频道锁定开关
-(IBAction)doSwitchLockAction:(id)sender{
    
    UISwitch *switchLock = (UISwitch *)sender;
    _isChannelLock = [switchLock isOn];
    [[NSUserDefaults standardUserDefaults] setBool:_isChannelLock forKey:@"IsChannelLock"];
    
    [self doResetChannelLockView];
    
    if (_isChannelLock) {
        
        // 如果锁定了频道，则组合上传
        UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
        
        if (usergene.channel.changenum == -1) {
            
            usergene.type.changenum = 0;
            usergene.mood.changenum = 0;
            usergene.scene.changenum = 0;
        }
        
        //[self initGeneByUserGene:usergene];
    }
}

-(void)doResetChannelLockView{
    
    //
    if (_isChannelLock) {
        _modifyGeneView.typeScrollView.scrollEnabled = NO;
        _modifyGeneView.moodScrollView.scrollEnabled = NO;
        _modifyGeneView.sceneScrollView.scrollEnabled = NO;
    } else {
        _modifyGeneView.typeScrollView.scrollEnabled = YES;
        _modifyGeneView.moodScrollView.scrollEnabled = YES;
        _modifyGeneView.sceneScrollView.scrollEnabled = YES;
    }
    
}

-(void)finishCurrentGuide {
    
    _mainGuideScrollView.hidden = YES;
    _mainGuidePageControl.hidden = YES;
    
    [UserSessionManager GetInstance].isMainMenuFirstLaunch = NO;
}

-(void)pageTurn :(UIPageControl*)sender {
    
    CGSize viewSize = _mainGuideScrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    
    [_mainGuideScrollView scrollRectToVisible:rect animated:YES];
}

#pragma UIScrollViewDelegate

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView.tag == 2) {
    
        int x = scrollView.contentOffset.x;
        if (x >= 320 * (GUIDE_MAIN_NUMBER - 1)) {
            
            [self finishCurrentGuide];
        }
    }
    else {
        
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
                usergene.type = [_xmlParserUtil.typeList objectAtIndex:tempchannel.typeindex];
                usergene.mood = [_xmlParserUtil.moodList objectAtIndex:tempchannel.moodindex];
                usergene.scene = [_xmlParserUtil.sceneList objectAtIndex:tempchannel.sceneindex];
                [self initGeneByUserGene:usergene];
                
            } else if (scrollView.tag == 201) {
                
                Type *temptype = [_xmlParserUtil.typeList objectAtIndex:pageIndex];
                [temptype log];
                
                UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
                usergene.type = temptype;
                usergene.mood.changenum = -1;
                usergene.scene.changenum = -1;
                usergene.channel.changenum = -1;
                
            } else if (scrollView.tag == 202) {
                
                Mood *tempmood = [_xmlParserUtil.moodList objectAtIndex:pageIndex];
                [tempmood log];
                
                UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
                usergene.mood = tempmood;
                usergene.type.changenum = -1;
                usergene.scene.changenum = -1;
                usergene.channel.changenum = -1;
                
            } else if (scrollView.tag == 203) {
                
                Scene *tempscene = [_xmlParserUtil.sceneList objectAtIndex:pageIndex];
                [tempscene log];
                
                UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
                usergene.scene = tempscene;
                usergene.type.changenum = -1;
                usergene.mood.changenum = -1;
                usergene.channel.changenum = -1;
                
            }
            
        }
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 2) {
        
        [self finishCurrentGuide];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 2) {
        
        CGPoint offset = _mainGuideScrollView.contentOffset;
        CGRect bounds = _mainGuideScrollView.frame;
        [_mainGuidePageControl setCurrentPage:offset.x / bounds.size.width];
    }
    else {
        
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
            usergene.mood.changenum = -1;
            usergene.scene.changenum = -1;
            usergene.channel.changenum = -1;
            
        } else if (scrollView.tag == 202) {
            
            Mood *tempmood = [_xmlParserUtil.moodList objectAtIndex:pageIndex];
            [tempmood log];
            
            UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
            usergene.mood = tempmood;
            usergene.type.changenum = -1;
            usergene.scene.changenum = -1;
            usergene.channel.changenum = -1;
            
        } else if (scrollView.tag == 203) {
            
            Scene *tempscene = [_xmlParserUtil.sceneList objectAtIndex:pageIndex];
            [tempscene log];
            
            UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
            usergene.scene = tempscene;
            usergene.type.changenum = -1;
            usergene.mood.changenum = -1;
            usergene.channel.changenum = -1;
            
        }
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
     NSDictionary *result = [tNotification userInfo];
     ConfigFileInfo *configInfo = [result objectForKey:@"result"];
     */
    
}

//getTypeSongsFailed notification
-(void)getTypeSongsFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"getTypeSongsFailed...%@", [result objectForKey:@"msg"]);

    // 从网络获取歌曲失败，则从本地数据库获取音乐
    UserGene *tusergene = [UserSessionManager GetInstance].currentUserGene;
    NSMutableArray *tempsonglist = [[PDatabaseManager GetInstance] getSongInfoListByUserGene:tusergene rowCount:GET_TYPE_SONGS_NUM];
    
    [[PPlayerManagerCenter GetInstance] doUpdateSongList:tempsonglist];
    
    //[SVProgressHUD showErrorWithStatus:@"根据纬度获取歌曲失败:("];
    
}

-(void)getTypeSongsSuccess:(NSNotification *)tNotification{
    
    PLog(@"getModeMusicSuccess...");
    NSDictionary *result = [tNotification userInfo];
    NSMutableArray *songInfoList = [result objectForKey:@"result"];
    [[PDatabaseManager GetInstance] insertSongInfoList:songInfoList];
    
    UserGene *tusergene = [UserSessionManager GetInstance].currentUserGene;
    NSMutableArray *tempsonglist = [[PDatabaseManager GetInstance] getSongInfoListByUserGene:tusergene rowCount:GET_TYPE_SONGS_NUM];
    /*
    PPlayerManagerCenter *playerManagerCenter = [PPlayerManagerCenter GetInstance];
    if (playerManagerCenter.songList.count > 0) {
        playerManagerCenter.currentSongIndex = 0;
        NSIndexSet *indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tempsonglist.count)];
        [playerManagerCenter.songList insertObjects:tempsonglist atIndexes:indexs];
    } else {
        [playerManagerCenter.songList addObjectsFromArray:tempsonglist];
    }
    */
    
    if (_isUpdatedList) {
        
        // 如果是正在播放的列表歌曲播放完毕，则在原有列表上添加新的歌曲
        [[PPlayerManagerCenter GetInstance] doAddSongList:tempsonglist];
        
        _isUpdatedList = NO;
        
        PAAMusicPlayer *aaMusicPlayer = [[PPlayerManagerCenter GetInstance] getPlayer:WhichPlayer_AVAudioPlayer];
        if ([aaMusicPlayer isMusicPlaying]) {
            
            [[PPlayerManagerCenter GetInstance] doPlayOrPause];
        }
    }
    else if([songInfoList count] > 0){
        
        // 如果是音乐基因获取到的歌曲，则删除之前的列表，添加新歌曲
        // 原有逻辑是添加从本地获取的列表，改为添加从服务端获取的列表，获取失败的逻辑不变
        //[[PPlayerManagerCenter GetInstance] doReplaceSongList:tempsonglist];
        [[PPlayerManagerCenter GetInstance] doReplaceSongList:songInfoList];
        [[PPlayerManagerCenter GetInstance] doNext];
    }
    else {
        
        // 没有获取到一首歌，则用本地的数据
        [[PPlayerManagerCenter GetInstance] doReplaceSongList:tempsonglist];
    }
    
    //[SVProgressHUD showErrorWithStatus:@"根据纬度获取歌曲成功:)"];
    
}

-(void)doUpdatePlayList:(id)sender {
    
    _isUpdatedList = YES;
    
    [self loadSongsByGene];
}

-(void)updateGeneDisplay:(Song *)song {
   
    NSString* strid = song.type;
    CGRect rect;
    
    if ([strid isEqualToString:@"chl"]) {
        
        rect = _btnType.frame;
    }
    else if ([strid isEqualToString:@"mm"]) {
        
        rect = _btnMood.frame;
    }
    else if ([strid isEqualToString:@"ms"]) {
        
        rect = _btnScene.frame;
    }
    else {
     
        _focusImageView.hidden = YES;
        return;
    }
    
    // 初始位置往回退像素
    rect.origin.x -= 5;
    rect.origin.y -= 5;
    
    // 大小增加
    rect.size.width += 10;
    rect.size.height += 10;
    
    // 初始化白框图片
    UIImage* focusImg = [UIImage imageWithName:@"gene_focus"];
    _focusImageView.image = focusImg;
    _focusImageView.frame = rect;
    _focusImageView.hidden = NO;
}

#pragma mark - Player Delegate

-(void)DidPlayNext:(Song *)song {
    
    PLog(@"change gene display...");
    [self updateGeneDisplay:song];
}

-(void)DidPlayorPause:(Song *)song {
    
    
}

@end
