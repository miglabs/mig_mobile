//
//  UserGene.m
//  miglab_mobile
//
//  Created by pig on 13-8-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "UserGene.h"

@implementation UserGene

@synthesize channel = _channel;
@synthesize type = _type;
@synthesize mood = _mood;
@synthesize scene = _scene;

-(id)init{
    
    self = [super init];
    if (self) {
        _channel = [[Channel alloc] init];
        _channel.channelId = @"1";
        _type = [[Type alloc] init];
        _type.typeid = 1;
        _mood = [[Mood alloc] init];
        _mood.typeid = 1;
        _scene = [[Scene alloc] init];
        _scene.typeid = 1;
    }
    return self;
}

@end
