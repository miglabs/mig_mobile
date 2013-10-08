//
//  ShareMenuView.h
//  miglab_mobile
//
//  Created by apple on 13-10-8.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareMenuView : UIView

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *lblDesc;
@property (nonatomic, retain) UISwitch *switchChoose;

-(id)initShareMenuView;

@end
