//
//  MusicSourceEditMenuView.m
//  miglab_mobile
//
//  Created by pig on 13-9-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicSourceEditMenuView.h"

@implementation MusicSourceEditMenuView

@synthesize btnBack = _btnBack;
@synthesize btnOnline = _btnOnline;
@synthesize btnCollected = _btnCollected;
@synthesize btnNearby = _btnNearby;
@synthesize btnIPod = _btnIPod;
@synthesize btnImportFromOther = _btnImportFromOther;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
