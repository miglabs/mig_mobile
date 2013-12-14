//
//  SongOfSendInfoCell.h
//  miglab_mobile
//
//  Created by pig on 13-11-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface SongOfSendInfoCell : UITableViewCell

@property (nonatomic, retain) IBOutlet EGOImageButton *btnAvatar;
@property (nonatomic, retain) IBOutlet UILabel *lblPlaceHolder;
@property (nonatomic, retain) IBOutlet UITextView *tvRecommendContent;
@property (nonatomic, retain) IBOutlet UILabel *lblSongInfo;

@end
