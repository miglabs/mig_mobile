//
//  XmlParserUtil.h
//  miglab_mobile
//
//  Created by pig on 13-8-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlParserUtil : NSObject<NSXMLParserDelegate>

@property (nonatomic, retain) NSMutableArray *elements2Parser;//需要获取的节点
@property (nonatomic, retain) NSString *currentElementValue;//节点值
@property (nonatomic, assign) BOOL storingCharacterData;//当前节点是否要记录
@property (nonatomic, assign) long long version;//数据版本

@property (nonatomic, retain) NSMutableArray *typeList;
@property (nonatomic, retain) NSMutableArray *moodList;
@property (nonatomic, retain) NSMutableArray *sceneList;
@property (nonatomic, retain) NSMutableArray *channelList;

-(id)initWithParserElements:(NSArray *)elements;
-(id)initWithParserDefaultElement;
-(BOOL)parserXml:(NSData *)xmlData;

@end
