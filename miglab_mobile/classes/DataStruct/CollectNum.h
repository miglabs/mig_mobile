//
//  CollectNum.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-8-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectNum : NSObject

@property (nonatomic, assign) int mynum;
@property (nonatomic, assign) int nearnum;

+(id)initWithNSDictionary:(NSDictionary*)dict;

@end
