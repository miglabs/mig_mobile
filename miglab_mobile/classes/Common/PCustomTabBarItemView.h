//
//  PCustomTabBarItemView.h
//  itime
//
//  Created by pig on 13-1-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCustomTabBarItemView : UIButton{
    
    UIImageView *iconImageView;                     //图标view
    UILabel *titleLabel;                            //文字标题
    
    UIImage *normalIconImage;                       //未选中时图标
    UIImage *selectedIcomImage;                     //选择时图标
    
}

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImage *normalIconImage;
@property (nonatomic, retain) UIImage *selectedIcomImage;

-(id)initWithFrame:(CGRect)frame title:(NSString *)tTitle normalIconImage:(UIImage *)tNormalIconImage selectedIconImage:(UIImage *)tSelectedIconImage;
-(id)initWithFrame:(CGRect)frame normalIconImage:(UIImage *)tNormalIconImage selectedIconImage:(UIImage *)tSelectedIconImage;

@end
