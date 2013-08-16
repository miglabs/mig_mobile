//
//  GeneViewController.m
//  miglab_mobile
//
//  Created by pig on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "GeneViewController.h"
#import "PlayViewController.h"

@interface GeneViewController ()

@end

@implementation GeneViewController

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
    
    self.playerMenuView.frame = CGRectMake(11.5, kMainScreenHeight - 45 - 73 - 10, 297, 73);
    
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
    
    PlayViewController *playViewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    [self.navigationController presentModalViewController:playViewController animated:YES];
    
}

-(IBAction)doDelete:(id)sender{
    
}

-(IBAction)doCollect:(id)sender{
    
}

-(IBAction)doPlayOrPause:(id)sender{
    
}

-(IBAction)doNext:(id)sender{
    
}

@end
