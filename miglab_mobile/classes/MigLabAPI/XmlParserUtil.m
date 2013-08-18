//
//  XmlParserUtil.m
//  miglab_mobile
//
//  Created by pig on 13-8-18.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "XmlParserUtil.h"
#import "Type.h"
#import "Mood.h"
#import "Scene.h"
#import "Channel.h"

@implementation XmlParserUtil

@synthesize elements2Parser = _elements2Parser;
@synthesize currentElementValue = _currentElementValue;
@synthesize storingCharacterData = _storingCharacterData;
@synthesize version = _version;

@synthesize typeList = _typeList;
@synthesize moodList = _moodList;
@synthesize sceneList = _sceneList;
@synthesize channelList = _channelList;

-(id)init{
    
    if (self = [super init]) {
        _version = 0;
        _storingCharacterData = NO;
        _elements2Parser = [[NSMutableArray alloc] initWithObjects:@"description", nil];
    }
    return self;
}

-(id)initWithParserElements:(NSArray *)elements{
    
    if (self = [super init]) {
        _version = 0;
        _storingCharacterData = NO;
        _elements2Parser = [[NSMutableArray alloc] initWithArray:elements];
    }
    return self;
}

-(id)initWithParserDefaultElement{
    
    return [self initWithParserElements:[NSArray arrayWithObjects:@"description", @"type", @"mood", @"scenes", @"attr", @"mig_channel", @"channel", @"info_version", nil]];
}

-(BOOL)parserXml:(NSData *)xmlData{
    
    if (xmlData) {
        
        NSString *strSrcXml = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
        PLog(@"strSrcXml...");
        
        NSData *utf8data = [strSrcXml dataUsingEncoding:NSUTF8StringEncoding];
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:utf8data];
        
        [parser setDelegate:self];
        [parser setShouldProcessNamespaces:NO];
        [parser setShouldReportNamespacePrefixes:NO];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
        NSError *parserError = [parser parserError];
        if (parserError) {
            NSLog(@"error...%@", parserError);
        }else{
            NSLog(@"success...");
        }
        
    }
    
    
    NSLog(@"_typeList: %d, _moodList: %d, _sceneList: %d, _channelList: %d, version: %lld", [_typeList count], [_moodList count], [_sceneList count], [_channelList count], _version);
    
    
    return (_version > 0);
}

#pragma NSXMLParserDelegate

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    
    PLog(@"parserDidStartDocument...");
    
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    PLog(@"didStartElement elementName: %@", elementName);
    PLog(@"didStartElement namespaceURI: %@", namespaceURI);
    PLog(@"didStartElement qName: %@", qName);
    PLog(@"didStartElement attributeDict: %@", attributeDict);
    
    if ([elementName isEqualToString:@"type"]) {
        _currentElementValue = elementName;
        _typeList = [[NSMutableArray alloc] init];
    } else if ([elementName isEqualToString:@"mood"]) {
        _currentElementValue = elementName;
        _moodList = [[NSMutableArray alloc] init];
    } else if ([elementName isEqualToString:@"scenes"]) {
        _currentElementValue = elementName;
        _sceneList = [[NSMutableArray alloc] init];
    } else if ([elementName isEqualToString:@"mig_channel"]) {
        _currentElementValue = elementName;
        _channelList = [[NSMutableArray alloc] init];
    } else if ([elementName isEqualToString:@"info_version"]) {
        _currentElementValue = elementName;
    } else if ([elementName isEqualToString:@"attr"]) {
        
        if ([_currentElementValue isEqualToString:@"type"]) {
            
            Type *tempType = [[Type alloc] init];
            tempType.typeid = [[attributeDict objectForKey:@"id"] intValue];
            tempType.name = [attributeDict objectForKey:@"name"];
            
            [_typeList addObject:tempType];
            
        } else if ([_currentElementValue isEqualToString:@"mood"]) {
            
            Mood *tempMood = [[Mood alloc] init];
            tempMood.typeid = [[attributeDict objectForKey:@"id"] intValue];
            tempMood.name = [attributeDict objectForKey:@"name"];
            
            [_moodList addObject:tempMood];
            
        } else if ([_currentElementValue isEqualToString:@"scenes"]) {
            
            Scene *tempScene = [[Scene alloc] init];
            tempScene.typeid = [[attributeDict objectForKey:@"id"] intValue];
            tempScene.name = [attributeDict objectForKey:@"name"];
            
            [_sceneList addObject:tempScene];
            
        } else if ([_currentElementValue isEqualToString:@"mig_channel"]) {
            
            Channel *tempChannel = [[Channel alloc] init];
            tempChannel.channelId = [attributeDict objectForKey:@"id"];
            tempChannel.channelName = [attributeDict objectForKey:@"name"];
            tempChannel.typeid = [[attributeDict objectForKey:@"typeid"] intValue];
            tempChannel.moodid = [[attributeDict objectForKey:@"moodid"] intValue];
            tempChannel.sceneid = [[attributeDict objectForKey:@"scenesid"] intValue];
            
            [_channelList addObject:tempChannel];
            
        } else if ([_currentElementValue isEqualToString:@"info_version"]) {
            _version = [[attributeDict objectForKey:@"id"] intValue];
        }
        
    }
    
    _storingCharacterData = [_elements2Parser containsObject:elementName];
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    PLog(@"didEndElement elementName: %@", elementName);
    PLog(@"didEndElement namespaceURI: %@", namespaceURI);
    PLog(@"didEndElement qName: %@", qName);
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
    PLog(@"foundCharacters string: %@", string);
    
}

@end
