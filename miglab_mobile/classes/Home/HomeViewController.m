//
//  HomeViewController.m
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "HomeViewController.h"
#import "Song.h"
#import "SongDownloadManager.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doStart:(id)sender{
    
    Song *song = [[Song alloc] init];
    song.songId = 276269;
    song.songUrl = @"http://umusic.9158.com//2013/06/27/10/36/276269_3e084a286f644b3caa3d701025b34ca3.mp3";
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    songManager.song = song;
    
    if ([songManager initDownloadInfo]) {
        
        [songManager doStart];
        
    }
    
}

-(IBAction)doPause:(id)sender{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    [songManager doPause];
    
}

-(IBAction)doResume:(id)sender{
    
    SongDownloadManager *songManager = [SongDownloadManager GetInstance];
    [songManager doResume];
}

@end
