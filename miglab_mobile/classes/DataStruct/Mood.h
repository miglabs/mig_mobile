//
//  Mood.h
//  miglab_mobile
//
//  Created by apple on 13-7-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mood : NSObject

@property (nonatomic, assign) int day;
@property (nonatomic, assign) int typeid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int moodIndex;
@property (nonatomic, retain) NSString *picname;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, assign) int changenum;

//心情
+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end
