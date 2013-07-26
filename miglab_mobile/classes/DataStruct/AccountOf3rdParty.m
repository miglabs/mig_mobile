//
//  AccountOf3rdParty.m
//  miglab_mobile
//
//  Created by apple on 13-7-15.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "AccountOf3rdParty.h"

@implementation AccountOf3rdParty

@synthesize username = _username;
@synthesize password = _password;
@synthesize accounttype = _accounttype;
@synthesize accountid = _accountid;
@synthesize accesstoken = _accesstoken;

-(void)log{
    
    PLog(@"Print AccountOf3rdParty: username(%@), password(%@), accounttype(%d), accountid(%@), accesstoken(%@)", _username, _password, _accounttype, _accountid, _accesstoken);
    
}

@end
