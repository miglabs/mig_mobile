//
//  CharInputToolBar.h
//  miglab_chat
//
//  Created by 180 on 14-4-1.
//  Copyright (c) 2014年 180. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatNotification.h"
@interface CharInputToolBar : UIToolbar<UITextViewDelegate,ChatNotificationDelegate>


@property BOOL isFaceBoardShow;

@end
