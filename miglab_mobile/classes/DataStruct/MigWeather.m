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
    
    if ([weather isEqualToString:MIG_WEATHER_RAIN]) {
        
        return @"rain_ico.png";
    }
    else if ([weather isEqualToString:MIG_WEATHER_CLEAR_DAY]) {
        
        return @"sun_ico.png";
    }
    else if ([weather isEqualToString:MIG_WEATHER_CLEAR_NIGHT]) {
        
        return @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_PARTLY_CLOUDY_DAY]) {
        
        return @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_PARTLY_CLOUDY_NIGHT]) {
        
        return @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_CLOUDY]) {
        
        return @"cloudy_ico.png";
    }
    else if ([weather isEqualToString:MIG_WEATHER_SLEET]) {
        
        return @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_SNOW]) {
        
        return @"snow_ico.png";
    }
    else if ([weather isEqualToString:MIG_WEATHER_WIND]) {
        
        return @"";
    }
    else if ([weather isEqualToString:MIG_WEATHER_FOG]) {
        
        return @"";
    }
    else {
        
        return nil;
    }
}

@end
