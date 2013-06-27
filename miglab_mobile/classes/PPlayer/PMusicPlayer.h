//
//  PMusicPlayer.h
//  miglab_mobile
//
//  Created by apple on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PMusicPlayer : NSObject

@property (nonatomic, retain) AVPlayer *avPlayer;
@property (nonatomic, retain) AVPlayerItem *avPlayerItem;
@property (nonatomic, retain) id audioMix;
@property (nonatomic, retain) id volumeMixInput;

@property (nonatomic, retain) NSString *songUrl;
@property (nonatomic, assign) BOOL playBeginState;

//初始化
-(BOOL)initPlayer;
//播放
-(void)play;
//暂停
-(void)pause;
//停止
-(void)stop;
//音量调整
-(void)setVolume:(float)volume;
//取得播放时间
-(NSTimeInterval)playableDuration;
//当前播放时间
-(NSTimeInterval)playableCurrentTime;

@end
