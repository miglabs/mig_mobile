//
//  ConfigFileInfo.h
//  miglab_mobile
//
//  Created by Archer_LJ on 13-8-28.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigFileInfo : NSObject

@property (nonatomic, retain) NSString* version;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, retain) NSString* filename;

+(id)initWithNSDictionary:(NSDictionary *)dict;
-(void)log;

@end
