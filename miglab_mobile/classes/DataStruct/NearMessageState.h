//
//  NearMessageState.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-10-2.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NearbyUser.h"
#import "MessageInfo.h"

@interface NearMessageState : NSObject

@property (nonatomic, retain) NearbyUser* user;
@property (nonatomic, retain) MessageInfo* msg;

+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end
