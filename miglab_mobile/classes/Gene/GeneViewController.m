//
//  GeneViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "GeneViewController.h"
#import "LoginChooseViewController.h"
#import "PlayViewController.h"
#import "XmlParserUtil.h"

@interface GeneViewController ()

@end

@implementation GeneViewController

@synthesize topViewcontroller = _topViewcontroller;

@synthesize btnAvatar = _btnAvatar;

@synthesize btnGotoGene = _btnGotoGene;

//音乐基因
@synthesize geneView = _geneView;
@synthesize btnBackFromGene = _btnBackFromGene;

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
    
    UIImageView *bodyBgImageView = [[UIImageView alloc] init];
    bodyBgImageView.frame = CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 - 10);
    bodyBgImageView.tag = 200;
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    [self.view addSubview:bodyBgImageView];
    
    //avatar
    UIImage *avatarNorImage = [UIImage imageWithName:@"music_default_avatar" type:@"png"];
    _btnAvatar = [[EGOImageButton alloc] initWithPlaceholderImage:avatarNorImage];
    _btnAvatar.frame = CGRectMake(10 + 13, 45 + 10 + 13, 36, 36);
    _btnAvatar.layer.cornerRadius = 18;
    _btnAvatar.layer.masksToBounds = YES;
    _btnAvatar.layer.borderWidth = 2;
    _btnAvatar.layer.borderColor = [UIColor whiteColor].CGColor;
    [_btnAvatar setImage:avatarNorImage forState:UIControlStateNormal];
    [_btnAvatar addTarget:self action:@selector(doAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnAvatar];
    
    
    
    //音乐基因
    
    //btnGotoGene
    _btnGotoGene = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnGotoGene.frame = CGRectMake(11.5, 45 + 10, 297, kMainScreenHeight - 45 - 10 - 10 - 73 - 10);
    [_btnGotoGene setTitle:@"goto gene" forState:UIControlStateNormal];
    [_btnGotoGene addTarget:self action:@selector(doGotoGene:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnGotoGene];
    
    //返回播放信息页面
    [_btnBackFromGene addTarget:self action:@selector(doBackFromGene:) forControlEvents:UIControlEventTouchUpInside];
    _geneView.frame = CGRectMake(0, 45 + 10, 320, kMainScreenHeight - 45 - 10 - 10 - 73 - 10);
    [self.view addSubview:_geneView];
    
    
    
    
    
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
    [_topViewcontroller.navigationController pushViewController:loginChooseViewController animated:YES];
    
}

-(IBAction)doGotoGene:(id)sender{
    
    PLog(@"doGotoGene...");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    
    NSInteger first = [[self.view subviews] indexOfObject:[self.view viewWithTag:200]];
    NSInteger seconde = [[self.view subviews] indexOfObject:_geneView];
    
    [self.view exchangeSubviewAtIndex:first withSubviewAtIndex:seconde];
    
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
    
    NSInteger first = [[self.view subviews] indexOfObject:[self.view viewWithTag:200]];
    NSInteger seconde = [[self.view subviews] indexOfObject:_geneView];
    
    [self.view exchangeSubviewAtIndex:seconde withSubviewAtIndex:first];
    
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
    
    PlayViewController *playViewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    [self.navigationController presentModalViewController:playViewController animated:YES];
    [_topViewcontroller.navigationController presentModalViewController:playViewController animated:YES];
    
}

@end
