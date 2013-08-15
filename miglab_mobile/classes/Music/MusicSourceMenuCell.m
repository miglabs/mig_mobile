//
//  MusicSourceMenuCell.m
//  miglab_mobile
//
//  Created by pig on 13-8-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicSourceMenuCell.h"

@implementation MusicSourceMenuCell

@synthesize menuImageView = _menuImageView;
@synthesize lblMenu = _lblMenu;
@synthesize lblTipNum = _lblTipNum;
@synthesize arrowImageView = _arrowImageView;

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
