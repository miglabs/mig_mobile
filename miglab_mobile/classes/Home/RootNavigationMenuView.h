//
//  RootNavigationMenuView.h
//  miglab_mobile
//
//  Created by apple on 13-8-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface RootNavigationMenuView : UIView

@property (nonatomic, retain) UIImageView *bgImageView;
@property (nonatomic, retain) UIButton *btnMenuFirst;
@property (nonatomic, retain) UIButton *btnMenuSecond;
@property (nonatomic, retain) UIButton *btnMenuThird;
@property (nonatomic, retain) IBOutlet EGOImageButton *egoBtnAvatar; //头像显示


-(id)initRootNavigationMenuView;
-(id)initRootNavigationMenuView:(CGRect)frame;
-(void)setSelectedMenu:(int)aIndex;

-(IBAction)doAvatar:(id)sender; //头像按钮事件

@end
