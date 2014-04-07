//
//  PCustomNavigationBarView.h
//  itime
//
//  Created by pig on 13-4-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCustomNavigationBarView : UIView

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIButton *rightButton;

- (id)initCustomNavigationBarView:(NSString *)tTitle;
- (id)initWithTitle:(NSString *)tTitle bgImageView:(NSString *)tImageName;

@end
