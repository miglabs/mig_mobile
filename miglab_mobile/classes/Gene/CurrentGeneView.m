//
//  CurrentGeneView.m
//  miglab_mobile
//
//  Created by pig on 13-8-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "CurrentGeneView.h"

@implementation CurrentGeneView

@synthesize lblYear = _lblYear;
@synthesize lblMonthAndDay = _lblMonthAndDay;
@synthesize egoBtnAvatar = _egoBtnAvatar;
@synthesize typeImageView = _typeImageView;
@synthesize lblTypeDesc = _lblTypeDesc;
@synthesize moodImageView = _moodImageView;
@synthesize lblMoodDesc = _lblMoodDesc;
@synthesize sceneImageView = _sceneImageView;
@synthesize lblSceneDesc = _lblSceneDesc;
@synthesize lbllocation = _lbllocation;
@synthesize imageWeather = _imageWeather;

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
