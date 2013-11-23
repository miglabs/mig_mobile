//
//  ModifyGeneView.h
//  miglab_mobile
//
//  Created by pig on 13-8-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyGeneView : UIView

@property (nonatomic, retain) IBOutlet UIImageView *bodyBgImageView;    //背景
@property (nonatomic, retain) IBOutlet UIButton *btnBack;               //设置返回
@property (nonatomic, retain) IBOutlet UILabel *lblChannelLock;         //频道锁定
@property (nonatomic, retain) IBOutlet UISwitch *switchChannelLock;     //
@property (nonatomic, retain) IBOutlet UILabel *lblChannel;             //
@property (nonatomic, retain) IBOutlet UILabel *lblType;
@property (nonatomic, retain) IBOutlet UILabel *lblMood;
@property (nonatomic, retain) IBOutlet UILabel *lblScene;
@property (nonatomic, retain) IBOutlet UIScrollView *channelScrollView; //频道
@property (nonatomic, retain) IBOutlet UIScrollView *typeScrollView;    //类别
@property (nonatomic, retain) IBOutlet UIScrollView *moodScrollView;    //心情
@property (nonatomic, retain) IBOutlet UIScrollView *sceneScrollView;   //场景

@end
