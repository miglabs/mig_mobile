//
//  NearbyUser.m
//  miglab_mobile
//
//  Created by apple on 13-8-8.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "NearbyUser.h"

@implementation NearbyUser

@synthesize userid = _userid;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize distance = _distance;
@synthesize cur_music = _cur_music;
@synthesize nickname = _nickname;
@synthesize sex = _sex;
@synthesize songstat = _songstat;
@synthesize songname = _songname;
@synthesize singer = _singer;

//附近的人
+(id)initWithNSDictionary:(NSDictionary*)dict{
    
    NearbyUser *nearbyuser = nil;
    
    @try {
        
        if (dict && [dict isKindOfClass:[NSDictionary class]]) {
            
            nearbyuser = [[NearbyUser alloc] init];
            nearbyuser.userid = [dict objectForKey:@"userid"];
            nearbyuser.latitude = [dict objectForKey:@"latitude"];
            nearbyuser.longitude = [dict objectForKey:@"longitude"];
            nearbyuser.distance = [[dict objectForKey:@"distance"] longValue];
            nearbyuser.cur_music = [[dict objectForKey:@"cur_music"] intValue];
            nearbyuser.nickname = [dict objectForKey:@"nickname"];
            nearbyuser.sex = [dict objectForKey:@"sex"];
            nearbyuser.songstat = [dict objectForKey:@"songstat"];
            nearbyuser.singer = [dict objectForKey:@"name"];
        }
    }
    @catch (NSException *exception) {
        PLog(@"parser NearbyUser failed...");
    }
    
    return nearbyuser;
}

-(void)log{
    
    PLog(@"Print NearbyUser: userid(%@), latitude(%@), longitude(%@), distance(%ld), cur_music(%d)", _userid, _latitude, _longitude, _distance, _cur_music);
    
}

@end
