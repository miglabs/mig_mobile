//
//  MusicCommentPlayerView.h
//  miglab_mobile
//
//  Created by pig on 13-8-21.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGOImageButton.h"

@interface MusicCommentPlayerView : UIView

@property (nonatomic, retain) IBOutlet EGOImageButton *btnAvatar;
@property (nonatomic, retain) IBOutlet UILabel *lblSongName;
@property (nonatomic, retain) IBOutlet UILabel *lblSongArtist;
@property (nonatomic, retain) IBOutlet UIButton *btnPlayOrPause;
@property (nonatomic, retain) IBOutlet UIButton *btnCollect;           //喜欢
@property (nonatomic, retain) IBOutlet UIButton *btnDelete;            //移除
@property (nonatomic, retain) IBOutlet UIButton *btnShare;             //下一首

@end
