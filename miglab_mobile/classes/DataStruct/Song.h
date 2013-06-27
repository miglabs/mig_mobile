//
//  Song.h
//  miglab_mobile
//
//  Created by apple on 13-6-27.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject

@property (nonatomic, assign) long long songId;
@property (nonatomic, retain) NSString *songName;
@property (nonatomic, retain) NSString *songUrl;

@end
