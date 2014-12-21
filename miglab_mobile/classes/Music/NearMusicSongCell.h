//
//  MusicSongCell.h
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "EGOImageButton.h"

@interface NearMusicSongCell : UITableViewCell

@property (nonatomic, retain) UIViewController *topViewcontroller; // 导航指针
@property (nonatomic, retain) IBOutlet UIButton *btnIcon;
@property (nonatomic, retain) IBOutlet UILabel *lblSongName;
@property (nonatomic, retain) IBOutlet UILabel *lblSongArtistAndDesc;
@property (nonatomic, retain) IBOutlet EGOImageButton* btnAvatar;
@property (nonatomic, retain) IBOutlet UIImageView* imgMsgTips;
@property (nonatomic, retain) IBOutlet UILabel* lblDistance;
@property (nonatomic, retain) IBOutlet UILabel* lblFrom;
@property (nonatomic, retain) MessageInfo* msginfo;

-(void)updateNearMusicSongCellData:(MessageInfo*)message;

@end
