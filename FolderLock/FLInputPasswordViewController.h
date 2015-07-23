//
//  FLInputPasswordViewController.h
//  FolderLock
//
//  Created by ATam on 7/23/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLFolderModel.h"

@interface FLInputPasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *btForgotPassword;

@property (nonatomic, strong) FLFolderModel *folderModel;

@property (nonatomic, readwrite, copy) void(^didCompleteSuccessPassword)();
@property (nonatomic, readwrite, copy) void(^actionForgotPassword)();
- (IBAction)actionForgotpassword:(id)sender;

@end
