//
//  FriendOfSayHiViewController.h
//  miglab_mobile
//
//  Created by pig on 13-8-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayerViewController.h"

@interface FriendOfSayHiViewController : PlayerViewController<UITextFieldDelegate>

@property (nonatomic, retain) UITextField* text;
@property (nonatomic, retain) UILabel* lblinfo;
@property (nonatomic, retain) NSString* touserid;

-(IBAction)doSayHello:(id)sender;

-(void)doSayHelloSuccess:(NSNotification*)tNotification;
-(void)doSayHelloFailed:(NSNotification *)tNotification;

@end
