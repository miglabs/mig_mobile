//
//  User.m
//  miglab_mobile
//
//  Created by pig on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "PUser.h"

@implementation PUser

@synthesize username = _username;
@synthesize password = _password;
@synthesize userid = _userid;
@synthesize nickname = _nickname;
@synthesize gender = _gender;
@synthesize type = _type;
@synthesize birthday = _birthday;
@synthesize location = _location;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize age = _age;
@synthesize source = _source;
@synthesize head = _head;
@synthesize token = _token;

@synthesize sinaAccount = _sinaAccount;
@synthesize tencentAccount = _tencentAccount;
@synthesize doubanAccount = _doubanAccount;

+(id)initWithNSDictionary:(NSDictionary *)dict{
    
    PUser *user = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            user = [[PUser alloc] init];
            user.userid = [dict objectForKey:@"userid"];
            user.username = [dict objectForKey:@"username"];
            user.password = [dict objectForKey:@"password"];
            user.nickname = [dict objectForKey:@"nickname"];
            user.gender = [[dict objectForKey:@"gender"] intValue];
            user.type = [[dict objectForKey:@"type"] intValue];
            user.birthday = [dict objectForKey:@"birthday"];
            user.location = [dict objectForKey:@"location"];
            user.age = [[dict objectForKey:@"age"] intValue];
            user.source = [[dict objectForKey:@"source"] intValue];
            user.head = [dict objectForKey:@"head"];
            user.token = [dict objectForKey:@"token"];
            
        }
        
    }
    @catch (NSException *exception) {
        PLog(@"parser User failed...please check");
    }
    
    return user;
}

-(void)log{
    
    PLog(@"Print User: username(%@), password(%@), userid(%@), nickname(%@), gender(%d), type(%d), birthday(%@), location(%@), age(%d), source(%d), head(%@), token(%@)", _username, _password, _userid, _nickname, _gender, _type, _birthday, _location, _age, _source, _head, _token);
    [_sinaAccount log];
    [_tencentAccount log];
    [_doubanAccount log];
    
}

@end
