//
//  PCustomToolBarView.h
//  HelloWorld
//
//  Created by Ming Jianhua on 13-1-30.
//  Copyright (c) 2013年 9158.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PCustomToolBarViewDelegate <NSObject>

@optional
//底部左中右菜单委托
-(void)doLeftAction;
-(void)doMiddleAction;
-(void)doRightAction;

@end

@interface PCustomToolBarView : UIView{
    
    id<PCustomToolBarViewDelegate> delegate;
    
}

@property (nonatomic, assign) id<PCustomToolBarViewDelegate> delegate;

-(id)initWithNavToolBar;
-(void)leftAction;
-(void)middleAction;
-(void)rightAction;

@end
