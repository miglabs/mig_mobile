//
//  FriendViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "FriendViewController.h"

#import "DetailPlayerViewController.h"

@interface FriendViewController ()

@end

@implementation FriendViewController

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
    bodyBgImageView.image = [UIImage imageWithName:@"body_bg" type:@"png"];
    [self.view addSubview:bodyBgImageView];
    
//    self.playerMenuView.frame = CGRectMake(11.5, kMainScreenHeight - 45 - 73 - 10, 297, 73);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//override
-(IBAction)doPlayerAvatar:(id)sender{
    
    [super doPlayerAvatar:sender];
    PLog(@"gene doPlayerAvatar...");
    
}


@end
