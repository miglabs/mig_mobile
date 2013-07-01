//
//  PCustomTabBarView.h
//  itime
//
//  Created by pig on 13-1-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCustomTabBarViewDelegate <NSObject>

-(BOOL)selectedCustomTabBarItemViewIndex:(int)tIndex;

@end

@interface PCustomTabBarView : UIView{
    
    id<PCustomTabBarViewDelegate> delegate;
    int currentSelectedIndex;
    UIImageView *slideBg;
    
}

@property (nonatomic, assign) id<PCustomTabBarViewDelegate> delegate;
@property (nonatomic, assign) int currentSelectedIndex;
@property (nonatomic, retain) UIImageView *slideBg;

-(id)initWithTitleList:(NSArray *)tTitleList normalIconList:(NSArray *)tNormalIconList selectedIconList:(NSArray *)tSelectedIconList;
-(void)updateSelectedCustomTabBarItemView:(int)tIndex;

@end
