//
//  RootNavigationMenuView.h
//  miglab_mobile
//
//  Created by apple on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootNavigationMenuView : UIView

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIButton *btnMenuFirst;
@property (nonatomic, retain) UIButton *btnMenuSecond;
@property (nonatomic, retain) UIButton *btnMenuThird;

-(id)initRootNavigationMenuView:(CGRect)frame;
-(void)setSelectedMenu:(int)aIndex;

@end
