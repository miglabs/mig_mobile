//
//  LeftViewCell.m
//  miglab_mobile
//
//  Created by pig on 13-7-23.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "LeftViewCell.h"

@implementation LeftViewCell

@synthesize menuImageView = _menuImageView;
@synthesize lblMenu = _lblMenu;

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
