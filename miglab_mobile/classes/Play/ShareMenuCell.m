//
//  ShareMenuCell.m
//  miglab_mobile
//
//  Created by pig on 13-10-5.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ShareMenuCell.h"

@implementation ShareMenuCell

@synthesize iconImageView = _iconImageView;
@synthesize lblDesc = _lblDesc;
@synthesize switchChoose = _switchChoose;

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
