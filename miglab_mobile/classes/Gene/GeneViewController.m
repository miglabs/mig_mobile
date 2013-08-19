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
    [_currentGeneView.btnGotoGeneType addTarget:self action:@selector(doGotoGene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_currentGeneView];
    
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
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    /*
    NSInteger first = [[self.view subviews] indexOfObject:_currentGeneView];
    NSInteger seconde = [[self.view subviews] indexOfObject:_modifyGeneView];
    
    [self.view exchangeSubviewAtIndex:first withSubviewAtIndex:seconde];
    */
    
    _currentGeneView.hidden = YES;
    _modifyGeneView.hidden = NO;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}

-(IBAction)doBackFromGene:(id)sender{
    
    PLog(@"doBackFromGene...");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    _currentGeneView.hidden = NO;
    _modifyGeneView.hidden = YES;
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
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
