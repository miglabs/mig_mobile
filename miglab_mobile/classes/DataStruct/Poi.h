//
//  Poi.h
//  miglab_mobile
//
//  Created by Pro on 15/3/29.
//  Copyright (c) 2015年 miglab. All rights reserved.
//
@interface PoiInfo : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double distance;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* district;
@property (nonatomic, retain) NSString* province;
@property (nonatomic, retain) NSString* street;


+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end
