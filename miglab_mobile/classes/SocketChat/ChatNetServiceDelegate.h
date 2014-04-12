//
//  ChatNetServiceDelegate.h
//  miglab_chat
//
//  Created by 180 on 14-3-31.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatNetServiceDelegate <NSObject>

- (void) onError:(NSString*) error;
- (void) onHiscChatMsg:(NSArray*) data;
- (void) onChatMsg:(id) data;

@end
