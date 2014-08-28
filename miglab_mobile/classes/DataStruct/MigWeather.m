//
//  MigWeather.m
//  miglab_mobile
//
//  Created by Archer_LJ on 14-8-23.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "MigWeather.h"
#import "apidefine.h"

@implementation MigWeather

+(NSString *)getWeatherIconName:(NSString *)weather {
    
    NSString *szImg;
    
    if ([weather isEqualToString:MIG_WEATHER_RAIN]) {
        
        szImg = @"rain_ico.png";
    }
    else if ([weather isEqualToString:MIG_WEATHER_CLEAR_DAY]) {
        
        szImg = @"sun_ico.png";
    }
    else if ([weather isEqualToString:MIG_WEATHER_CLEAR_NIGHT]) {
        
        szImg = @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_PARTLY_CLOUDY_DAY]) {
        
        szImg = @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_PARTLY_CLOUDY_NIGHT]) {
        
        szImg = @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_CLOUDY]) {
        
        szImg = @"cloudy_ico.png";
    }
    else if ([weather isEqualToString:MIG_WEATHER_SLEET]) {
        
        szImg = @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_SNOW]) {
        
        szImg = @"snow_ico.png";
    }
    else if ([weather isEqualToString:MIG_WEATHER_WIND]) {
        
        szImg = @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_FOG]) {
        
        szImg = @"";
    }
    
    if (!(MIG_NOT_EMPTY_STR(szImg))) {
        
        szImg = @"sun_ico.png";
    }
    
    return szImg;
}

@end
