//
//  LyricShare.h
//  miglab_mobile
//
//  Created by Archer_LJ on 14-8-16.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricShare : NSObject

@property (nonatomic, retain) NSString* songId;
@property (nonatomic, retain) NSString* lyric;
@property (nonatomic, retain) NSString* weather;
@property (nonatomic, retain) NSString* temprature;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, retain) NSString* mdescription;

+(id)initWithNSDictionary:(NSDictionary*)dict;

@end
