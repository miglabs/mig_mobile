//
//  MainViewController.h
//  miglab_chat
//
//  Created by 180 on 14-3-30.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "FlipsideViewController.h"
#import "FaceViewController.h"
#import "ChatNetServiceDelegate.h"
#import "BaseViewController.h"
#import "ChatMsgTableViewCell.h"
@interface MainViewController : BaseViewController
@property (nonatomic, retain) IBOutlet FaceViewController     *phraseViewController;


@property (strong, nonatomic) UINib *cellNib;
@property (strong, nonatomic) IBOutlet ChatMsgTableViewCell *customCell;
@end
