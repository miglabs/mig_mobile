//
//  MusicHeadMenuView.h
//  miglab_mobile
//
//  Created by pig on 13-8-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicBodyHeadMenuView : UIView

@property (nonatomic, retain) UILabel *lblDesc;
@property (nonatomic, retain) UIButton *btnSort;
@property (nonatomic, retain) UIButton *btnEdit;
@property (nonatomic, retain) UIImageView *separatorImageView;

-(id)initMusicBodyHeadMenuView;

@end
