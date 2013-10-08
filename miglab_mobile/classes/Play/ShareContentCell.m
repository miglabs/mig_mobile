//
//  ShareContentCell.m
//  miglab_mobile
//
//  Created by apple on 13-10-8.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ShareContentCell.h"

@implementation ShareContentCell

@synthesize tvShareContent = _tvShareContent;
@synthesize btnAt = _btnAt;

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
