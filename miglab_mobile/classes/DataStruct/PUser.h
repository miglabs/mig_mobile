//
//  User.h
//  miglab_mobile
//
//  Created by pig on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountOf3rdParty.h"

@interface PUser : NSObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userid;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, assign) int gender;
@property (nonatomic, assign) int type;                 //0为游客，1为用户
@property (nonatomic, retain) NSString *birthday;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int source;
@property (nonatomic, retain) NSString *head;
@property (nonatomic, retain) NSString* token;
@property (nonatomic, retain) NSString* session;

@property (nonatomic, retain) AccountOf3rdParty *sinaAccount;
@property (nonatomic, retain) AccountOf3rdParty *tencentAccount;
@property (nonatomic, retain) AccountOf3rdParty *doubanAccount;

+(id)initWithNSDictionary:(NSDictionary *)dict;
-(void)log;

@end
