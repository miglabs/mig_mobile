//
//  NearMusicState.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-9-7.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NearbyUser.h"
#import "Song.h"

@interface NearMusicState : NSObject

@property (nonatomic, retain) NearbyUser* nearuser;
@property (nonatomic, retain) Song* song;
@property (nonatomic, assign) int songstate;

+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end
