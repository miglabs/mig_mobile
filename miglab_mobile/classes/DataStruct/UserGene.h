//
//  UserGene.h
//  miglab_mobile
//
//  Created by pig on 13-8-31.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Channel.h"
#import "Type.h"
#import "Mood.h"
#import "Scene.h"

@interface UserGene : NSObject

@property (nonatomic, retain) Channel *channel;
@property (nonatomic, retain) Type *type;
@property (nonatomic, retain) Mood *mood;
@property (nonatomic, retain) Scene *scene;

@end
