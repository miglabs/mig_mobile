//
//  User.m
//  miglab_mobile
//
//  Created by pig on 13-6-26.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize username = _username;
@synthesize password = _password;
@synthesize userid = _userid;
@synthesize nickname = _nickname;
@synthesize gender = _gender;
@synthesize type = _type;
@synthesize birthday = _birthday;
@synthesize location = _location;
@synthesize age = _age;
@synthesize source = _source;
@synthesize head = _head;

+(id)initWithNSDictionary:(NSDictionary *)dict{
    
    User *user = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            user = [[User alloc] init];
            user.userid = [dict objectForKey:@"userid"];
            user.username = [dict objectForKey:@"username"];
            user.nickname = [dict objectForKey:@"nickname"];
            user.gender = [[dict objectForKey:@"gender"] intValue];
            user.type = [[dict objectForKey:@"type"] intValue];
            user.birthday = [dict objectForKey:@"birthday"];
            user.location = [dict objectForKey:@"location"];
            user.age = [[dict objectForKey:@"age"] intValue];
            user.source = [[dict objectForKey:@"source"] intValue];
            user.head = [dict objectForKey:@"head"];
            
        }
        
    }
    @catch (NSException *exception) {
        PLog(@"parser User failed...please check");
    }
    
    return user;
}

@end
