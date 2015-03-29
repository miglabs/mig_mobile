//
//  Poi.m
//  miglab_mobile
//
//  Created by Pro on 15/3/29.
//  Copyright (c) 2015年 miglab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Poi.h"

@implementation PoiInfo

@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize distance = _distance;
@synthesize city = _city;
@synthesize district = _district;
@synthesize province = _province;
@synthesize street = _street;


+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    PoiInfo* poiinfo = nil;
    
    if(dict && [dict isKindOfClass:[NSDictionary class]]) {
        poiinfo = [[PoiInfo alloc] init];
        
        
        
        /* 其他自定义格式信息，根据接口不同，需要的值不同 */
        poiinfo.latitude = [[dict objectForKey:@"latitude"] doubleValue];
        poiinfo.longitude = [[dict objectForKey:@"longitude"] doubleValue];
        poiinfo.distance = [[dict objectForKey:@"distance"] doubleValue];
        poiinfo.city = [dict objectForKey:@"city"];
        poiinfo.district = [dict objectForKey:@"district"];
        poiinfo.province = [dict objectForKey:@"province"];
        poiinfo.street = [dict objectForKey:@"street"];
    }
    
    return poiinfo;
}

-(void)log {
    
    
}

@end