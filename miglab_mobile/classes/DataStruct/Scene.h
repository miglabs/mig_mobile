//
//  Scene.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-7-19.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Scene : NSObject

@property (nonatomic, assign) int typeid;                   //场景id
@property (nonatomic, retain) NSString* name;               //场景名称

+(id)initWithNSDictionary:(NSDictionary*)dict;

@end
