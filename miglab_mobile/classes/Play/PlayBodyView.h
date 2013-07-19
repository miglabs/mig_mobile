//
//  PlayBodyView.h
//  miglab_mobile
//
//  Created by apple on 13-7-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

@interface PlayBodyView : UIView

@property (nonatomic, retain) IBOutlet UIImageView *ivCircleProcess;
@property (nonatomic, retain) IBOutlet EGOImageView *coverOfSongEGOImageView;
@property (nonatomic, retain) IBOutlet UIImageView *cdCenterImageView;
@property (nonatomic, retain) IBOutlet UIButton *btnCdOfSong;
@property (nonatomic, retain) IBOutlet UIButton *btnPlayProcessPoint;
@property (nonatomic, retain) IBOutlet UITextView *lrcOfSongTextView;
@property (assign) BOOL isDraging;                                          //是否在拖动进度

-(void)updateProcess:(float)processRate;

@end
