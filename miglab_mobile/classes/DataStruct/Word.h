//
//  Word.h
//  miglab_mobile
//
//  Created by pig on 13-7-25.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject

@property (nonatomic, assign) int index;
@property (nonatomic, assign) int typeid;                   //描述词id
@property (nonatomic, retain) NSString *name;               //描述词名称
@property (nonatomic, retain) NSString *mode;               //mm心情模式，ms场景模式即区分获取心情推荐歌曲，还是场景推荐歌曲

//[心情，场景]词描述
+(id)initWithNSDictionary:(NSDictionary*)dict;
-(void)log;

@end
