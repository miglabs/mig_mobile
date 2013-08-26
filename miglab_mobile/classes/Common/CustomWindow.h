//
//  CustomWindow.h
//  Vgirl-XAuth2.0
//
//  Created by Ming Jianhua on 12-7-27.
//  Copyright (c) 2012年 9158.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomWindow : UIWindow{
    
    UIView *superView;
    UIView *backgroundView;
    UIView *contentView;
    
    BOOL closed;
}

@property (nonatomic,retain)UIView *superView;
@property (nonatomic,retain)UIView *backgroundView;
@property (nonatomic,retain)UIView *contentView;

-(CustomWindow *)initWithView:(UIView *)aView;
-(void)show;
-(void)close;

@end
