//
//  FLInputPassword.m
//  FolderLock
//
//  Created by ATam on 7/23/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLPasswordViewController.h"
#import "FLButtonHelper.h"
#import <skpsmtpmessage/SKPSMTPMessage.h>
#import "AccountModel.h"
#import "FLAccountSetting.h"

@interface FLPasswordViewController ()<SKPSMTPMessageDelegate>
@property (nonatomic, strong) SKPSMTPMessage *forgotPassword;
@end

@implementation FLPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Enter Your Password";
    
    UIButton *cancelButton = fl_buttonCancel();
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [cancelButton addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = fl_buttonSave();
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    self.textField.placeholder = @"Password";
    self.btnForgotPassword.titleLabel.text = @"Forgot Your password account";
}

- (void)actionCancel {
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
}

- (void)actionSave {
    [self.view endEditing:YES];
    if ([self.textField.text isEqualToString:self.stringPassword]) {
        if (self.didCompleteSuccessPassword) {
            self.didCompleteSuccessPassword();
        }
        [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    }else{
        NSString *message = @"Password do not match";
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

- (IBAction)forgotPasswordAccount:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        AccountModel *accountModel = [[AccountModel alloc] initWithUser:[FLAccountSetting findUser]];
        NSString *emailTitle = [NSString stringWithFormat:_LSFromTable(@"title.strings.forgotpassword", @"FLFolderListViewController", @"Forgot password")];
        // Email Content
        NSString *messageBody = [NSString stringWithFormat:@"%@ %@: %@",_LSFromTable(@"title.strings.password.account", @"FLFolderListViewController", @"Password Account"), accountModel.email, accountModel.password];

        self.forgotPassword = [[SKPSMTPMessage alloc] init];
        [self.forgotPassword setFromEmail:@"mr.tamqn.app.folderlock@gmail.com"];  // Change to your email address
        [self.forgotPassword setToEmail:accountModel.email]; // Load this, or have user enter this
        [self.forgotPassword setRelayHost:@"smtp.gmail.com"];
        [self.forgotPassword setRequiresAuth:YES]; // GMail requires this
        [self.forgotPassword setLogin:@"mr.tamqn.app.folderlock@gmail.com"]; // Same as the "setFromEmail:" email
        [self.forgotPassword setPass:@"Quachtam87@gmail.comm"]; // Password for the Gmail account that you are sending from
        [self.forgotPassword setSubject:emailTitle]; // Change this to change the subject of the email
        [self.forgotPassword setWantsSecure:YES]; // Gmail Requires this
        [self.forgotPassword setDelegate:self]; // Required
        
        NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain", kSKPSMTPPartContentTypeKey, messageBody, kSKPSMTPPartMessageKey, @"8bit" , kSKPSMTPPartContentTransferEncodingKey, nil];
        
        [self.forgotPassword setParts:[NSArray arrayWithObjects:plainPart, nil]];
        [self.forgotPassword send];
}

-(void)messageSent:(SKPSMTPMessage *)message {
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_LSFromTable(@"title.strings.send.email.success", @"FLFolderListViewController", @"Send email success") delegate:nil cancelButtonTitle:nil otherButtonTitles:_LSFromTable(@"title.strings.ok", @"FLFolderListViewController", @"OK"), nil];
    [alert show];
    self.forgotPassword = nil;
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    self.forgotPassword = nil;
}
@end
