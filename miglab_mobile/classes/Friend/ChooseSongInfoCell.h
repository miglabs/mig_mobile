//
//  ChooseSongInfoCell.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-11-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface ChooseSongInfoCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel* lblSongName;
@property (nonatomic, retain) IBOutlet UILabel* lblSongInfo;
@property (nonatomic, retain) IBOutlet UILabel* lblListenNumber;
@property (nonatomic, retain) IBOutlet UILabel* lblCommentNumber;
@property (nonatomic, retain) IBOutlet UIButton* lbtnIsChosed;

@end
