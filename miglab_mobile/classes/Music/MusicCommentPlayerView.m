//
//  MusicCommentPlayerView.m
//  miglab_mobile
//
//  Created by pig on 13-8-21.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "MusicCommentPlayerView.h"

@implementation MusicCommentPlayerView

@synthesize btnAvatar = _btnAvatar;
@synthesize lblSongName = _lblSongName;
@synthesize lblSongArtist = _lblSongArtist;
@synthesize btnPlayOrPause = _btnPlayOrPause;
@synthesize btnCollect = _btnCollect;
@synthesize btnDelete = _btnDelete;
@synthesize btnShare = _btnShare;

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
