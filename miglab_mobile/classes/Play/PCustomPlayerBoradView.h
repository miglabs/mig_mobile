//
//  PCustomPlayerBoradView.h
//  miglab_mobile
//
//  Created by pig on 13-7-16.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageButton.h"

@interface PCustomPlayerBoradView : UIView

//底部歌曲控制菜单
@property (nonatomic, retain) UIImageView *playerBoradBgImageView;
@property (nonatomic, retain) EGOImageButton *btnAvatar;
@property (nonatomic, retain) UILabel *lblSongName;
@property (nonatomic, retain) UILabel *lblArtist;
@property (nonatomic, retain) UIButton *btnRemove;                                  //移除
@property (nonatomic, retain) UIButton *btnLike;                                    //喜欢
@property (nonatomic, retain) UIButton *btnPlayOrPause;
@property (nonatomic, retain) UIButton *btnNext;                                    //下一首

-(id)initPlayerBoradView:(CGRect)frame;

@end
