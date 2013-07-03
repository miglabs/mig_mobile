//
//  UserSessionManager.m
//  miglab_mobile
//
//  Created by pig on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "UserSessionManager.h"

@implementation UserSessionManager

@synthesize currentUser = _currentUser;
@synthesize isLoggedIn = _isLoggedIn;
@synthesize accesstoken = _accesstoken;

+(UserSessionManager *)GetInstance{
    
    static UserSessionManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[self alloc] init];
            instance.currentUser = [[User alloc] init];
        }
    }
    return instance;
}

@end
