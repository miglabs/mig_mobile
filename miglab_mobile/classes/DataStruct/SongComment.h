//
//  SongComment.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-9-9.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUser.h"

@interface SongComment : NSObject

@property (nonatomic, retain) NSString* songid;
@property (nonatomic, retain) NSString* createdtime;
@property (nonatomic, retain) NSString* cid; //评论id
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) PUser* user;

+(id)initWithNSDictionary:(NSDictionary*) dict;
-(void)log;

@end
