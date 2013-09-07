//
//  SettingOfModifyNicknameViewController.h
//  miglab_mobile
//
//  Created by apple on 13-9-4.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingOfModifyNicknameViewController : BaseViewController<UITextFieldDelegate>

@property (nonatomic, retain) IBOutlet UITextField *nicknameTextField;
@property (nonatomic, retain) IBOutlet UILabel *lblErrorMessage;

-(IBAction)doSaveNickname:(id)sender;
-(IBAction)doHideKeyBoard:(id)sender;

@end
