//
//  GeneViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "GeneViewController.h"
#import "LoginChooseViewController.h"
#import "DetailPlayerViewController.h"
#import "XmlParserUtil.h"

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    //频道
    //44 44 244 58
    int PAGE_WIDTH = 244;
//    _modifyGeneView.channelScrollView.frame = CGRectMake(44, 44, 70, 58);
    _modifyGeneView.channelScrollView.clipsToBounds = NO;
//    _modifyGeneView.channelScrollView.bounds = CGRectMake(44, 44, 297, 58);
    _modifyGeneView.channelScrollView.backgroundColor = [UIColor clearColor];
    _modifyGeneView.channelScrollView.scrollEnabled = YES;
    _modifyGeneView.channelScrollView.showsHorizontalScrollIndicator = NO;
    _modifyGeneView.channelScrollView.pagingEnabled = YES;
    _modifyGeneView.channelScrollView.delegate = self;
//    _modifyGeneView.channelScrollView.contentSize = CGSizeMake(70 * 10, 50);
    _modifyGeneView.channelScrollView.contentSize = CGSizeMake(PAGE_WIDTH * 10, 50);
    
    for (int i=0; i<10; i++) {
        UILabel *lblChannel = [[UILabel alloc] init];
        lblChannel.frame = CGRectMake(PAGE_WIDTH*i, 8, PAGE_WIDTH/2, 50);
        lblChannel.backgroundColor = [UIColor clearColor];
        lblChannel.text = [NSString stringWithFormat:@"test-%d", i];
        lblChannel.textAlignment = kTextAlignmentCenter;
        lblChannel.textColor = [UIColor redColor];
        [_modifyGeneView.channelScrollView addSubview:lblChannel];
    }
    
    //类别
    
    //心情
    
    //场景
    
    [self.view addSubview:_modifyGeneView];
    _modifyGeneView.hidden = YES;
    
    
//    self.playerMenuView.frame = CGRectMake(11.5, kMainScreenHeight - 45 - 73 - 10, 297, 73);
    
    //解析音乐基因
    [NSThread detachNewThreadSelector:@selector(initGeneDataFromFile) toTarget:self withObject:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _modifyGeneView.alpha = 0.0f;
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
            
            _modifyGeneView.alpha = 1.0f;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
    
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

//解析音乐基因数据
-(void)initGeneDataFromFile{
    
    PLog(@"initGeneDataFromFile...");
    
    NSString *channelInfoXmlPath = [[NSBundle mainBundle] pathForResource:@"channelinfo" ofType:@"xml"];
    NSLog(@"channelInfoXmlPath: %@", channelInfoXmlPath);
    
    NSData *channelInfoXmlData = [[NSData alloc] initWithContentsOfFile:channelInfoXmlPath];
    
    XmlParserUtil *xmlParserUtil = [[XmlParserUtil alloc] initWithParserDefaultElement];
    [xmlParserUtil parserXml:channelInfoXmlData];
    
}

//override
-(IBAction)doPlayerAvatar:(id)sender{
    
    [super doPlayerAvatar:sender];
    PLog(@"gene doPlayerAvatar...");
    
}

@end
