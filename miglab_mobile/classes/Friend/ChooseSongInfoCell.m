//
//  ChooseSongInfoCell.m
//  miglab_mobile
//
//  Created by Archer_LJ on 13-11-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ChooseSongInfoCell.h"

@implementation ChooseSongInfoCell

@synthesize lblSongName = _lblSongName;
@synthesize lblSongInfo = _lblSongInfo;
@synthesize lblListenNumber = _lblListenNumber;
@synthesize lblCommentNumber = _lblCommentNumber;
@synthesize lbtnIsChosed = _lbtnIsChosed;

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
