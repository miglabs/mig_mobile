//
//  ChatNotification.m
//  miglab_chat
//
//  Created by 180 on 14-4-3.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import "ChatNotification.h"

#define CHATNOTIFICATION  @"ChatNotification"



@implementation ChatNotificationCenter

+ (void) postNotification:(ChatNotification*) data
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CHATNOTIFICATION object:data];
}
+ (void) postNotification:(NSInteger) type obj:(id) object
{
    ChatNotification* data = [[ChatNotification alloc] init:type obj:object];
    [ ChatNotificationCenter postNotification:data];
}

+ (void) addObserver:(id)observer selector:(SEL)aSelector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:aSelector name:CHATNOTIFICATION object:nil];
}
+ (void) removeObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:CHATNOTIFICATION object:nil];
}


-(void) onChatNotification:(NSNotification *)notification
{
    if( notification != nil && self.delegate != nil )
    {
        if ( notification.object != nil
            &&[self.delegate respondsToSelector:@selector(onChatNotification:)])
        {
            [self.delegate onChatNotification:notification.object];
        }
    }
}

- (id) init:(id) observer
{
    self = [super init];
    if(self)
    {
        self.delegate = observer;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onChatNotification:) name:CHATNOTIFICATION object:nil];
    }
    return  self;
}

- (void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHATNOTIFICATION object:nil];
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}
@end



@interface ChatNotification()
{
    //id          m_obj;
    //NSInteger   m_type;
}
@end

@implementation ChatNotification

- (id)  init:(NSInteger) type obj:(id) obj
{
    self = [super init];
    self.object = obj;
    self.type = type;
    return self;
}

-(void) dealloc
{
    self.object = nil;
#if DEBUG
    NSLog(@"%@ dealloc", self);
#endif
}

@end
