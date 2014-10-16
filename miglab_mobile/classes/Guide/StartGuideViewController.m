//
//  StartGuideViewController.m
//  miglab_mobile
//
//  Created by yaobanglin on 14-10-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "StartGuideViewController.h"
#import "AppDelegate.h"
@implementation StartGuideViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self guideDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
}

-(void) guideDidLoad
{
    int guideCount = 3;
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(guideCount*CGRectGetWidth(rect), 0)];
    [scrollView setPagingEnabled:YES];
    [scrollView setBounces:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    UIImageView *imageview  = nil;
    for (int i = 0; i < guideCount ; ++i)
    {
        imageview = [[UIImageView alloc] initWithFrame:rect];
        [imageview setImage:[UIImage imageNamed:[NSString stringWithFormat:@"startpage%d",i+1]]];
        [scrollView addSubview:imageview];
        rect.origin.x += rect.size.width;
        
    }
    [imageview setUserInteractionEnabled:TRUE];
    [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(presentViewController)]];
}

+(NSString*) showGuideKey
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *showGuideKey = [NSString stringWithFormat:@"ShowGuide%@",appVersion];
    return showGuideKey;
}
#define kOLDAPPVERSION_KEY @"OldAppVersion"
+(BOOL) isShowGuide
{
    return ! [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:kOLDAPPVERSION_KEY]];
}

-(void) presentViewController
{
    UIViewController* desView = [((AppDelegate*)[UIApplication sharedApplication].delegate) navController];
    [self presentViewController:desView animated:NO completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]  forKey:kOLDAPPVERSION_KEY];
    }];
}

-(BOOL) prefersStatusBarHidden
{
    return TRUE;
}

@end
