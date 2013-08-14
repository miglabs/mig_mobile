//
//  MusicPlayerNavigationView.h
//  miglab_mobile
//
//  Created by pig on 13-8-14.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface MusicPlayerNavigationView : UIView

@property (nonatomic, retain) UIImageView *topBgImageView;
@property (nonatomic, retain) EGOImageButton *btnAvatar;
@property (nonatomic, retain) UILabel *lblNickName;
@property (nonatomic, retain) UIButton *btnFirstMenu;
@property (nonatomic, retain) UIButton *btnSecondMenu;

-(id)initMusicNavigationView:(CGRect)frame;

@end
