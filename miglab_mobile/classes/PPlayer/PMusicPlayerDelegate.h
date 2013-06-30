//
//  PMusicPlayerDelegate.h
//  miglab_mobile
//
//  Created by pig on 13-6-30.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMusicPlayerDelegate <NSObject>

//PAAMusicPlayer
-(void)aaMusicPlayerStoped;

//PAMusicPlayer
-(void)aMusicPlayerStoped;

@end
