//
//  UserSessionManager.h
//  miglab_mobile
//
//  Created by pig on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUser.h"
#import "UserGene.h"

@interface UserSessionManager : NSObject

@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *accesstoken;
@property (nonatomic, assign) int accounttype;
@property (nonatomic, retain) PUser *currentUser;
@property (nonatomic, assign) BOOL isLoggedIn;

@property (nonatomic, retain) UserGene *currentUserGene;

+(UserSessionManager *)GetInstance;

@end
