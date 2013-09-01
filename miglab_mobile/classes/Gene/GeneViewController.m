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
    _btnMood.frame = CGRectMake(11.5 + 246, 45 + 10 + 160, 31, 31);
    _btnMood.tag = 200;
    UIImage *moodimage = [UIImage imageWithName:@"gene_type" type:@"png"];
    [_btnMood setImage:moodimage forState:UIControlStateNormal];
    [_btnMood addTarget:self action:@selector(doGotoGene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnMood];
    
    //场景
    _btnScene = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnScene.frame = CGRectMake(11.5 + 20, 45 + 10 + 220, 31, 31);
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
    UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
    usergene.channel = [_xmlParserUtil.channelList objectAtIndex:3];
    [self initGeneByUserGene:usergene];
    
    /*
    int currentchannelid = [usergene.channel.channelId intValue];
    if (currentchannelid > 0 && currentchannelid < channelCount) {
        
        CGRect channelRect = CGRectMake(PAGE_WIDTH*(currentchannelid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.channelScrollView scrollRectToVisible:channelRect animated:YES];
        
        int temptypeid = usergene.channel.typeid;
        CGRect typeRect = CGRectMake(PAGE_WIDTH*(temptypeid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.typeScrollView scrollRectToVisible:typeRect animated:YES];
        
        int tempmoodid = usergene.channel.moodid;
        CGRect moodRect = CGRectMake(PAGE_WIDTH*(tempmoodid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.moodScrollView scrollRectToVisible:moodRect animated:YES];
        
        int tempsceneid = usergene.channel.sceneid;
        CGRect sceneRect = CGRectMake(PAGE_WIDTH*(tempsceneid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.sceneScrollView scrollRectToVisible:sceneRect animated:YES];
        
    } else {
        
        int currenttypeid = usergene.type.typeid;
        CGRect typeRect = CGRectMake(PAGE_WIDTH*(currenttypeid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.typeScrollView scrollRectToVisible:typeRect animated:YES];
        
        int currentmoodid = usergene.mood.typeid;
        CGRect moodRect = CGRectMake(PAGE_WIDTH*(currentmoodid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.moodScrollView scrollRectToVisible:moodRect animated:YES];
        
        int currentsceneid = usergene.scene.typeid;
        CGRect sceneRect = CGRectMake(PAGE_WIDTH*(currentsceneid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.sceneScrollView scrollRectToVisible:sceneRect animated:YES];
        
    }
    */
    
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

-(void)initGeneByUserGene:(UserGene *)usergene{
    
    [self initGene:usergene.channel typeId:usergene.type.typeid moodId:usergene.mood.typeid sceneId:usergene.scene.typeid];
    
}

-(void)initGene:(Channel *)tchannel typeId:(int)ttypeid moodId:(int)tmoodid sceneId:(int)tsceneid{
    
    [tchannel log];
    PLog(@"tchannel.channelId(%@), tchannel.channelName(%@), ttypeid(%d), tmoodid(%d), tsceneid(%d)", tchannel.channelId, tchannel.channelName, ttypeid, tmoodid, tsceneid);
    
    int currentchannelid = [tchannel.channelId intValue];
    if (currentchannelid > 0) {
        
        CGRect channelRect = CGRectMake(PAGE_WIDTH*(currentchannelid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.channelScrollView scrollRectToVisible:channelRect animated:YES];
        
        int temptypeid = tchannel.typeid;
        CGRect typeRect = CGRectMake(PAGE_WIDTH*(temptypeid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.typeScrollView scrollRectToVisible:typeRect animated:YES];
        
        int tempmoodid = tchannel.moodid;
        CGRect moodRect = CGRectMake(PAGE_WIDTH*(tempmoodid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.moodScrollView scrollRectToVisible:moodRect animated:YES];
        
        int tempsceneid = tchannel.sceneid;
        CGRect sceneRect = CGRectMake(PAGE_WIDTH*(tempsceneid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.sceneScrollView scrollRectToVisible:sceneRect animated:YES];
        
    } else {
        
        int currenttypeid = ttypeid;
        CGRect typeRect = CGRectMake(PAGE_WIDTH*(currenttypeid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.typeScrollView scrollRectToVisible:typeRect animated:YES];
        
        int currentmoodid = tmoodid;
        CGRect moodRect = CGRectMake(PAGE_WIDTH*(currentmoodid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.moodScrollView scrollRectToVisible:moodRect animated:YES];
        
        int currentsceneid = tsceneid;
        CGRect sceneRect = CGRectMake(PAGE_WIDTH*(currentsceneid+1), 8, PAGE_WIDTH, 50);
        [_modifyGeneView.sceneScrollView scrollRectToVisible:sceneRect animated:YES];
        
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
    
    LoginChooseViewController *loginChooseViewController = [[LoginChooseViewController alloc] initWithNibName:@"LoginChooseViewController" bundle:nil];
    [self.topViewcontroller.navigationController pushViewController:loginChooseViewController animated:YES];
    
}

-(IBAction)doGotoGene:(id)sender{
    
    PLog(@"doGotoGene...");
    
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
    
    NSString *userid = [UserSessionManager GetInstance].userid;
    NSString *accesstoken = [UserSessionManager GetInstance].accesstoken;
    UserGene *usergene = [UserSessionManager GetInstance].currentUserGene;
    NSString *tmoodid = [NSString stringWithFormat:@"%d", usergene.mood.typeid];
    NSString *tsceneid = [NSString stringWithFormat:@"%d", usergene.scene.typeid];
    NSString *tchannelid = [NSString stringWithFormat:@"%@", usergene.channel.channelId];
    
    [self.miglabAPI doGetTypeSongs:userid token:accesstoken moodid:tmoodid moodindex:@"0" sceneid:tsceneid sceneindex:@"0" channelid:tchannelid channelindex:@"0" num:@"5"];
    
    
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
            usergene.type.typeid = tempchannel.typeid;
            usergene.mood.typeid = tempchannel.moodid;
            usergene.scene.typeid = tempchannel.sceneid;
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
        usergene.type.typeid = tempchannel.typeid;
        usergene.mood.typeid = tempchannel.moodid;
        usergene.scene.typeid = tempchannel.sceneid;
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
}

//getTypeSongsFailed notification
-(void)getTypeSongsFailed:(NSNotification *)tNotification{
    
    NSDictionary *result = [tNotification userInfo];
    PLog(@"getModeMusicFailed...%@", [result objectForKey:@"msg"]);
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
