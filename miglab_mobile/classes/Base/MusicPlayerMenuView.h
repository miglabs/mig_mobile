//
//  MusicPlayerMenuView.h
//  miglab_mobile
//
//  Created by pig on 13-8-14.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "EGOImageButton.h"

@interface MusicPlayerMenuView : UIView

//底部歌曲控制菜单
@property (nonatomic, retain) UIImageView *menuBgImageView;
@property (nonatomic, retain) EGOImageButton *btnAvatar;
@property (nonatomic, retain) UILabel *lblSongInfo;
@property (nonatomic, retain) UIButton *btnDelete;                                  //移除
@property (nonatomic, retain) UIButton *btnCollect;                                 //喜欢
@property (nonatomic, retain) UIButton *btnPlayOrPause;
@property (nonatomic, retain) UIButton *btnNext;                                    //下一首

-(id)initDefaultMenuView:(CGRect)frame;

@end
