//
//  PlayBodyView.m
//  miglab_mobile
//
//  Created by apple on 13-7-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PlayBodyView.h"
#import "UIImage+PImageCategory.h"
#import "PCommonUtil.h"

@implementation PlayBodyView

@synthesize ivCircleProcess = _ivCircleProcess;
@synthesize coverOfSongEGOImageView = _coverOfSongEGOImageView;
@synthesize cdCenterImageView = _cdCenterImageView;
@synthesize btnCdOfSong = _btnCdOfSong;
@synthesize btnPlayProcessPoint = _btnPlayProcessPoint;
@synthesize lrcOfSongTextView = _lrcOfSongTextView;
@synthesize isDraging = _isDraging;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)updateProcess:(float)processRate{
    
    if (processRate < 0.01) {
        processRate = 0.01;
    }
    
    float width = 213.0f;
    float height = 213.0f;
    CGSize imageSize = CGSizeMake(width, height);
    
    //圆盘
    UIImage *circleProcess = [UIImage imageWithName:@"progress_line" type:@"png"];
    UIImage *processMask = [PCommonUtil getCircleProcessImageWithNoneAlpha:imageSize progress:processRate];
    UIImage *currentProcessImage = [PCommonUtil maskImage:circleProcess withImage:processMask];
    _ivCircleProcess.image = currentProcessImage;
    
    //圆点
    if (!_isDraging) {
        
        //半径
        CGFloat radius = MIN(height, width) / 2 + 10;
        //扇形开始角度
        CGFloat radians = DEGREES_2_RADIANS((processRate * 359.9) - 90);
        CGFloat xOffset = radius*(1 + 0.85*cosf(radians));
        CGFloat yOffset = radius*(1 + 0.85*sinf(radians));
        
        CGRect processPointFrame = _btnPlayProcessPoint.frame;
        processPointFrame.origin.x = xOffset + 45 - (processPointFrame.size.width/2);
        processPointFrame.origin.y = yOffset - (processPointFrame.size.height/2);
        _btnPlayProcessPoint.frame = processPointFrame;
    }
    
}

//旋转歌曲封面
-(void)doRotateSongCover{
    
    CGAffineTransform transformTmp = _coverOfSongEGOImageView.transform;
    transformTmp = CGAffineTransformRotate(transformTmp, ROTATE_ANGLE);
    _coverOfSongEGOImageView.transform = transformTmp;
    
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
