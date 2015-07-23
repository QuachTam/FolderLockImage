//
//  FLInputPassword.m
//  FolderLock
//
//  Created by ATam on 7/23/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLPasswordViewController.h"
#import "FLButtonHelper.h"

@interface FLPasswordViewController ()

@end

@implementation FLPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.stringTitle.length) {
        self.title = @"Enter Your Passcode";
    }else{
        self.title = @"Enter Your Password";
    }
    
    UIButton *cancelButton = fl_buttonCancel();
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [cancelButton addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = fl_buttonSave();
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    if (self.stringTitle.length) {
        self.textField.placeholder = @"Passcode";
    }else{
        self.textField.placeholder = @"Password";
    }
    
}

- (void)actionCancel {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

- (void)actionSave {
    [self.view endEditing:YES];
    if ([self.textField.text isEqualToString:self.stringPassword]) {
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
        if (self.didCompleteSuccessPassword) {
            self.didCompleteSuccessPassword();
        }
    }else{
        NSString *message = nil;
        if (self.stringTitle.length) {
            message = @"Passcode do not match";
        }else{
            message = @"Password do not match";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
