//
//  PCustomPlayerMenuView.h
//  miglab_mobile
//
//  Created by pig on 13-7-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCustomPlayerMenuView : UIView

//底部歌曲控制菜单
@property (nonatomic, retain) UIImageView *playerMenuBgImageView;
@property (nonatomic, retain) UIButton *btnRemove;                                  //移除
@property (nonatomic, retain) UIButton *btnLike;                                    //喜欢
@property (nonatomic, retain) UIButton *btnNext;                                    //下一首

-(id)initPlayerMenuView:(CGRect)frame;

@end
