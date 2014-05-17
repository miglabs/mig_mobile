//
//  GlobalDataManager.m
//  miglab_mobile
//
//  Created by Archer_LJ on 14-5-17.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "GlobalDataManager.h"

@implementation GlobalDataManager

@synthesize isMainMenuFirstLaunch = _isMainMenuFirstLaunch;
@synthesize isGeneMenuFirstLaunch = _isGeneMenuFirstLaunch;
@synthesize isFirendMenuFirstLaunch = _isFirendMenuFirstLaunch;
@synthesize isProgramFirstLaunch = _isProgramFirstLaunch;
@synthesize isDetailPlayFirstLaunch = _isDetailPlayFirstLaunch;

+(GlobalDataManager *)GetInstance{
    
    static GlobalDataManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[self alloc] init];
        }
    }
    return instance;
}

@end
