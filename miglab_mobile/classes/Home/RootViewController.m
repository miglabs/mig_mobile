//
//  RootViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "RootViewController.h"
#import "GeneViewController.h"
#import "MusicViewController.h"
#import "FriendViewController.h"

#import "PDatabaseManager.h"
#import "PPlayerManagerCenter.h"

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize rootNavMenuView = _rootNavMenuView;
@synthesize dicViewControllerCache = _dicViewControllerCache;
@synthesize currentShowViewTag = _currentShowViewTag;

@synthesize miglabAPI = _miglabAPI;

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
    
    _rootNavMenuView = [[RootNavigationMenuView alloc] initRootNavigationMenuView:CGRectMake(0, 0, 320, 44)];
    _rootNavMenuView.btnMenuFirst.tag = 100;
    _rootNavMenuView.btnMenuSecond.tag = 101;
    _rootNavMenuView.btnMenuThird.tag = 102;
    [_rootNavMenuView.btnMenuFirst setTitle:@"音乐基因" forState:UIControlStateNormal];
    [_rootNavMenuView.btnMenuSecond setTitle:@"歌单" forState:UIControlStateNormal];
    [_rootNavMenuView.btnMenuThird setTitle:@"歌友" forState:UIControlStateNormal];
    [_rootNavMenuView.btnMenuFirst addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rootNavMenuView.btnMenuSecond addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rootNavMenuView.btnMenuThird addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rootNavMenuView];
    
    //缓存view
    _dicViewControllerCache = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self segmentAction:_rootNavMenuView.btnMenuFirst];
    
    //test data
    PDatabaseManager *databaseManager = [PDatabaseManager GetInstance];
    NSMutableArray *tempSongInfoList = [databaseManager getSongInfoList:25];
    
    PLog(@"rand(): %d, random(): %ld", rand(), random());
    int songListCount = [tempSongInfoList count];
    int rnd = rand() % songListCount;
    
    PPlayerManagerCenter *playerManagerCenter = [PPlayerManagerCenter GetInstance];
    [playerManagerCenter.songList addObjectsFromArray:tempSongInfoList];
    playerManagerCenter.currentSongIndex = rnd;
    playerManagerCenter.currentSong = (songListCount > 0) ? [tempSongInfoList objectAtIndex:rnd] : nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)segmentAction:(id)sender{
    
    UIButton *tempButton = sender;
    
    _currentShowViewTag = tempButton.tag;
    NSLog(@"_currentShowViewTag: %d", _currentShowViewTag);
    
    //remove
    UIView *oldShowView = [self.view viewWithTag:999];
    [oldShowView removeFromSuperview];
    
    //show
    UIViewController *controller = [self getControllerBySegIndex:_currentShowViewTag];
    UIView *newShowView = controller.view;
    newShowView.tag = 999;
    [self.view insertSubview:newShowView belowSubview:_rootNavMenuView];
    
}

-(UIViewController *)getControllerBySegIndex:(int)segindex{
    
    NSNumber *numIndex = [NSNumber numberWithInt:segindex];
    UIViewController *controller = [_dicViewControllerCache objectForKey:numIndex];
    
    switch (segindex) {
        case 100:
        {
            if (controller) {
                //update
                GeneViewController *oldGene = (GeneViewController *)controller;
                
            } else {
                
                GeneViewController *gene = [[GeneViewController alloc] initWithNibName:@"GeneViewController" bundle:nil];
                [gene setTopViewcontroller:self];
                [_dicViewControllerCache setObject:gene forKey:numIndex];
                controller = gene;
                
            }
            
        }
            break;
        case 101:
        {
            if (controller) {
                //update
                MusicViewController *oldMusic = (MusicViewController *)controller;
                
            } else {
                
                MusicViewController *music = [[MusicViewController alloc] initWithNibName:@"MusicViewController" bundle:nil];
                [music setTopViewcontroller:self];
                [_dicViewControllerCache setObject:music forKey:numIndex];
                controller = music;
                
            }
        }
            break;
        case 102:
        {
            if (controller) {
                //update
                FriendViewController *oldFriend = (FriendViewController *)controller;
                
            } else {
                
                FriendViewController *friend = [[FriendViewController alloc] initWithNibName:@"FriendViewController" bundle:nil];
                [friend setTopViewcontroller:self];
                [_dicViewControllerCache setObject:friend forKey:numIndex];
                controller = friend;
                
            }
        }
            break;
            
        default:
            break;
    }
    
    return controller;
}


@end
