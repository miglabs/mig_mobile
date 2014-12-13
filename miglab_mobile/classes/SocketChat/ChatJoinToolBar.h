//
//  ChatJoinToolBar.h
//  miglab_mobile
//
//  Created by kerry on 14/12/12.
//  Copyright (c) 2014年 pig. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ChatNotification.h"
@interface CharJoinToolBar : UIToolbar<UITextViewDelegate,ChatNotificationDelegate>


-(IBAction)joinChat:(id)sender;

@end