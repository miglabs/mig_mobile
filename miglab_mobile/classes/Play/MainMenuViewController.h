//
//  MainMenuViewController.h
//  miglab_mobile
//
//  Created by apple on 13-7-17.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

#import "PCustomPlayerBoradView.h"

@interface MainMenuViewController : UIViewController

@property (nonatomic, retain) UIView *playView;

@property (nonatomic, retain) PCustomPlayerBoradView *playerBoradView;

-(IBAction)doRemoveAction:(id)sender;
-(IBAction)doLikeAction:(id)sender;
-(IBAction)doNextAction:(id)sender;

@end
