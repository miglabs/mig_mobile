//
//  Type.h
//  miglab_mobile
//
//  Created by pig on 13-8-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Type : NSObject

@property (nonatomic, assign) int typeid;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, assign) int typeIndex;
@property (nonatomic, retain) NSString *picname;
@property (nonatomic, retain) NSString *desc;
@property (nonatomic, assign) int changenum;

//类别
+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end
