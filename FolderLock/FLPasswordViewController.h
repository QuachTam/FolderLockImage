//
//  FLInputPassword.h
//  FolderLock
//
//  Created by ATam on 7/23/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLFolderModel.h"

@interface FLPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSString *stringPassword;
@property (nonatomic, strong) NSString *stringTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnForgotPassword;

- (IBAction)forgotPasswordAccount:(id)sender;
@property (nonatomic, readwrite, copy) void(^didCompleteSuccessPassword)();
@end
