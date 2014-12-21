//
//  MusicSongCell.h
//  miglab_mobile
//
//  Created by pig on 13-8-20.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "EGOImageButton.h"

@interface MusicSongCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIButton *btnIcon;
@property (nonatomic, retain) IBOutlet UILabel *lblSongName;
@property (nonatomic, retain) IBOutlet UILabel *lblSongArtistAndDesc;
@property (nonatomic, retain) IBOutlet EGOImageButton* btnCover;

-(void)updateMusicSongCellData:(Song*)song;
@end
