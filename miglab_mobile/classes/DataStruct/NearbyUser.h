//
//  NearbyUser.h
//  miglab_mobile
//
//  Created by apple on 13-8-8.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearbyUser : NSObject

@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, assign) long distance;
@property (nonatomic, assign) int cur_music;
@property (nonatomic, retain) NSString* nickname;
@property (nonatomic, retain) NSString* sex;
@property (nonatomic, retain) NSString* songstat;
@property (nonatomic, retain) NSString* songname;
@property (nonatomic, retain) NSString* singer;

//附近的人
+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end
