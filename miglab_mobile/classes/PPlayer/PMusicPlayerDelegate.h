//
//  PMusicPlayerDelegate.h
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PlayerTimerFunctionInterval 0.1

@protocol PMusicPlayerDelegate <NSObject>

@optional
//PAAMusicPlayer
-(void)aaMusicPlayerTimerFunction;
-(void)aaMusicPlayerStoped;

//PAMusicPlayer
-(void)aMusicPlayerTimerFunction;
-(void)aMusicPlayerStoped;

@end
