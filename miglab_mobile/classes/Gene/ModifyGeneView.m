//
//  ModifyGeneView.m
//  miglab_mobile
//
//  Created by pig on 13-8-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ModifyGeneView.h"

@implementation ModifyGeneView

@synthesize bodyBgImageView = _bodyBgImageView;
@synthesize btnBack = _btnBack;
@synthesize lblChannel = _lblChannel;
@synthesize lblType = _lblType;
@synthesize lblMood = _lblMood;
@synthesize lblScene = _lblScene;
@synthesize channelScrollView = _channelScrollView;
@synthesize typeScrollView = _typeScrollView;
@synthesize moodScrollView = _moodScrollView;
@synthesize sceneScrollView = _sceneScrollView;

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
