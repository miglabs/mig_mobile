//
//  UserSessionManager.h
//  miglab_mobile
//
//  Created by pig on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUser.h"

@interface UserSessionManager : NSObject

@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *accesstoken;
@property (nonatomic, assign) int accounttype;
@property (nonatomic, retain) PUser *currentUser;
@property (nonatomic, assign) BOOL isLoggedIn;

+(UserSessionManager *)GetInstance;

@end
