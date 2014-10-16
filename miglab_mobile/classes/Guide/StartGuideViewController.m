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
    NSString *imageName = (kMainScreenFrame.size.height >= 567 ) ? @"startpage%d-568h" : @"startpage%d";
    for (int i = 0; i < guideCount ; ++i)
    {
        imageview = [[UIImageView alloc] initWithFrame:rect];
        [imageview setImage:[UIImage imageNamed:[NSString stringWithFormat:imageName,i+1]]];
        [scrollView addSubview:imageview];
        rect.origin.x += rect.size.width;
        
    }
    [imageview setUserInteractionEnabled:TRUE];
    [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(presentViewController)]];
    
    imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"startpage_in_button"]];
    rect = imageview.frame;
    rect.origin.x = ((guideCount-1)*CGRectGetWidth(self.view.frame)) + (CGRectGetWidth(self.view.frame) - CGRectGetWidth(rect) )/2 ;
    rect.origin.y = CGRectGetHeight(self.view.frame) -35 - CGRectGetHeight(rect);
    [imageview setFrame:rect];
    [scrollView addSubview:imageview];

}

+(NSString*) showGuideKey
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *showGuideKey = [NSString stringWithFormat:@"ShowGuide%@",appVersion];
    return showGuideKey;
}
#define kOLDAPPVERSION_KEY @"OldAppVersion"
#define kCFBundleShortVersionString @"CFBundleShortVersionString"
+(BOOL) isShowGuide
{
    return ! [[[[NSBundle mainBundle] infoDictionary] objectForKey:kCFBundleShortVersionString] isEqualToString:[[NSUserDefaults standardUserDefaults] stringForKey:kOLDAPPVERSION_KEY]];
}

-(void) presentViewController
{
    UIViewController* desView = [((AppDelegate*)[UIApplication sharedApplication].delegate) navController];
    [self presentViewController:desView animated:NO completion:^{
        [[NSUserDefaults standardUserDefaults] setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:kCFBundleShortVersionString]  forKey:kOLDAPPVERSION_KEY];
    }];
}

-(BOOL) prefersStatusBarHidden
{
    return TRUE;
}

@end
