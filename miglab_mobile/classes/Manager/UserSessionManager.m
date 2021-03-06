//
//  UserSessionManager.m
//  miglab_mobile
//
//  Created by pig on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "UserSessionManager.h"

@implementation UserSessionManager

@synthesize userid = _userid;
@synthesize accesstoken = _accesstoken;
@synthesize devicetoken = _devicetoken;
@synthesize accounttype = _accounttype;
@synthesize currentUser = _currentUser;
@synthesize isLoggedIn = _isLoggedIn;
@synthesize isLocation = _isLocation;

@synthesize currentUserGene = _currentUserGene;
@synthesize networkStatus = _networkStatus;

@synthesize bdBindPush = _bdBindPush;

+(UserSessionManager *)GetInstance{
    
    static UserSessionManager *instance = nil;
    @synchronized(self){
        if (nil == instance) {
            instance = [[self alloc] init];
            instance.currentUser = [[PUser alloc] init];
            instance.currentUserGene = [[UserGene alloc] init];
            instance.bdBindPush = [[NSDictionary alloc] init];
        }
    }
    return instance;
}

-(void)doLogout{
    
    _userid = nil;
    _accesstoken = nil;
    _currentUser = [[PUser alloc] init];
    _currentUserGene = [[UserGene alloc] init];
    _isLoggedIn = NO;
    _isLocation = NO;
    
}

@end
