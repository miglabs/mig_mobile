//
//  Barray.h
//  miglab_mobile
//
//  Created by kerry on 14/12/11.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarrayInfo : NSObject

@property (nonatomic, assign) long long messageid;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSString* nickname;
@property (nonatomic, assign) long long tid;
@property (nonatomic, retain) NSString* tname;


+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end