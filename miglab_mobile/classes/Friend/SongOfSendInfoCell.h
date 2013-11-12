//
//  SongOfSendInfoCell.h
//  miglab_mobile
//
//  Created by pig on 13-11-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface SongOfSendInfoCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageView *headEGOImageView;
@property (nonatomic, retain) IBOutlet UILabel *lblPlaceHolder;
@property (nonatomic, retain) IBOutlet UITextView *tvRecommendContent;
@property (nonatomic, retain) IBOutlet UILabel *lblSongInfo;

@end
