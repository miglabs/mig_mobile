//
//  SongOfSendInfoCell.m
//  miglab_mobile
//
//  Created by pig on 13-11-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SongOfSendInfoCell.h"

@implementation SongOfSendInfoCell

@synthesize headEGOImageView = _headEGOImageView;
@synthesize lblPlaceHolder = _lblPlaceHolder;
@synthesize tvRecommendContent = _tvRecommendContent;
@synthesize lblSongInfo = _lblSongInfo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
