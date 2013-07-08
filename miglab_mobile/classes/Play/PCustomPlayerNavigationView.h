//
//  PCustomPlayerNavigationView.h
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCustomPlayerNavigationView : UIView

@property (nonatomic, retain) UIButton *btnMenu;
@property (nonatomic, retain) UIImageView *showPlayingImageView;
@property (nonatomic, retain) UILabel *lblPlayingSongInfo;
@property (nonatomic, retain) UIButton *btnShare;

-(id)initPlayerNavigationView:(CGRect)frame;

@end
