//
//  LocalViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LocalViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TSLibraryImport.h"

@interface LocalViewController ()

@end

@implementation LocalViewController

@synthesize navView = _navView;

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
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"本地音乐" bgImageView:@"login_navigation_bg"];
    [self.view addSubview:_navView];
    
    UIImage *backImage = [UIImage imageWithName:@"login_back_arrow_nor" type:@"png"];
    [_navView.leftButton setBackgroundImage:backImage forState:UIControlStateNormal];
    _navView.leftButton.frame = CGRectMake(4, 0, 44, 44);
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    //test
//    [self getSongListFromIPod];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getSongListFromIPod{
    
    NSString *cachesDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *pigDirectory = [[cachesDirectory stringByAppendingPathComponent:[[NSProcessInfo processInfo] processName]] stringByAppendingPathComponent:@"pig"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:pigDirectory isDirectory:NULL])
    {
        NSError *error;
        if (![fm createDirectoryAtPath:pigDirectory withIntermediateDirectories:YES attributes:nil error:&error]) {
            [NSException raise:@"Exception" format:[error localizedDescription]];
        }
    }
    
    MPMediaQuery *videoQuery = [[MPMediaQuery alloc] init];
    NSArray *mediaItems = [videoQuery items];
    for (MPMediaItem *mediaItem in mediaItems){
        
        NSURL *URL = (NSURL*)[mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        
        if (URL) {
            NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
            NSString *artist = (NSString*)[mediaItem valueForProperty:MPMediaItemPropertyArtist];
            NSString *music = [URL absoluteString];
            
            NSLog(@"name(%@), artist(%@), musicUrl(%@)", name, artist, music);
            
            
            
            
        }
    }
    
    __block int currentMediaIndex = 0;
    if ([mediaItems count] > 0) {
        
        MPMediaItem *mediaItem = [mediaItems objectAtIndex:currentMediaIndex];
        NSURL *mediaItemUrl = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
        NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
        
        NSString *file = [NSString stringWithFormat:@"%@/%@", pigDirectory, name];
        NSURL *dstUrl = [NSURL fileURLWithPath:file];
        
        TSLibraryImport *export = [[TSLibraryImport alloc] init];
        [export importAsset:mediaItemUrl toURL:dstUrl completionBlock:^(TSLibraryImport *import) {
            
            currentMediaIndex++;
            
            MPMediaItem *mediaItem = [mediaItems objectAtIndex:currentMediaIndex];
            NSURL *mediaItemUrl = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
            NSString *name = (NSString *)[mediaItem valueForProperty:MPMediaItemPropertyTitle];
            
            NSString *file = [NSString stringWithFormat:@"%@/%@", pigDirectory, name];
            NSURL *dstUrl = [NSURL fileURLWithPath:file];
            
            TSLibraryImport *export = [[TSLibraryImport alloc] init];
            [export importAsset:mediaItemUrl toURL:dstUrl completionBlock:^(TSLibraryImport *import) {
                
                NSLog(@"complete...");
                
            }];
            
        }];
        
    }
    
}

@end
