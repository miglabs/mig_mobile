//
//  MainMenuViewController.m
//  miglab_mobile
//
//  Created by apple on 13-7-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MainMenuViewController.h"
#import "UIImage+PImageCategory.h"
#import <QuartzCore/QuartzCore.h>
#import "PCommonUtil.h"

#import "PlayViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

@synthesize playView = _playView;

@synthesize playerBoradView = _playerBoradView;

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
    
    FRAMELOG(self.view);
    
    //screen height
    float height = [UIScreen mainScreen].bounds.size.height;
    PLog(@"height: %f", height);
    
    PlayViewController *playViewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
    _playView = playViewController.view;
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [_playView addGestureRecognizer:panGestureRecognizer];
    
//    [self.view addSubview:_playView];
    
    //bottom
    _playerBoradView = [[PCustomPlayerBoradView alloc] initPlayerBoradView:CGRectMake(0, height - 20 - 60, 320, 60)];
    [_playerBoradView.btnRemove addTarget:self action:@selector(doRemoveAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnLike addTarget:self action:@selector(doLikeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_playerBoradView.btnNext addTarget:self action:@selector(doNextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playerBoradView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer{
    
    CGPoint translation = [recognizer translationInView:_playView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);
    
    NSLog(@"recognizer.view.center.x: %f, recognizer.view.center.y: %f", recognizer.view.center.x, recognizer.view.center.y);
    
    [recognizer setTranslation:CGPointZero inView:_playView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut animations:^{
            
            if (recognizer.view.frame.origin.y > 50) {
                _playView.frame = CGRectMake(0, 300, 320, 100);
            } else {
                _playView.frame = CGRectMake(0, 0, 320, 50);
            }
            
        } completion:^(BOOL finished) {
            
        }];
        
    } else if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        
        
    }
    
}

-(IBAction)doRemoveAction:(id)sender{
    
}

-(IBAction)doLikeAction:(id)sender{
    
}

-(IBAction)doNextAction:(id)sender{
    
    
}

@end
