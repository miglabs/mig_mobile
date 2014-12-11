//
//  Barray.m
//  miglab_mobile
//
//  Created by kerry on 14/12/11.
//  Copyright (c) 2014年 pig. All rights reserved.
//

#import "Barray.h"

@implementation BarrayInfo

@synthesize messageid = _messageid;
@synthesize message = _message;
@synthesize nickname = _nickname;
@synthesize tid = _tid;
@synthesize tname = _tname;

+(id)initWithNSDictionary:(NSDictionary *)dict {
    
    BarrayInfo* barrayinfo = nil;
    
    if(dict && [dict isKindOfClass:[NSDictionary class]]) {
        
        barrayinfo = [[BarrayInfo alloc] init];
        
        
        
        /* 其他自定义格式信息，根据接口不同，需要的值不同 */
        NSString* message = [dict objectForKey:@"msg"];
        barrayinfo.message = message;
        barrayinfo.messageid = [dict objectForKey:@"msgid"];
        barrayinfo.nickname = [dict objectForKey:@"nickname"];
        barrayinfo.tid = [dict objectForKey:@"tid"];
        barrayinfo.tname = [dict objectForKey:@"type"];
    }
    
    return barrayinfo;
}

-(void)log {
    
    
}

@end
