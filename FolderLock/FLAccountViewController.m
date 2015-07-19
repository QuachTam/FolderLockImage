//
//  FLAccountViewController.m
//  FolderLock
//
//  Created by QSOFT on 7/15/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLAccountViewController.h"
#import "FLButtonHelper.h"
#import "AccountModel.h"
#import "FLAccountCustomCell.h"
#import "FLAccountSetting.h"

@interface FLAccountViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) AccountModel *accountModel;
@property (nonatomic, strong) FLAccountSetting *accountSetting;
@end

@implementation FLAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *saveButton = fl_buttonSave();
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountSetting = [[FLAccountSetting alloc] init];
    self.accountModel = [[AccountModel alloc] initWithUser:[FLAccountSetting findUser]];
    self.title = self.accountModel.title;
    if (self.type==ACCOUNT_SETUP) {
        self.accountModel.type = ACCOUNT_SETUP;
    }else{
        self.accountModel.type = ACCOUNT_CHANGE;
        
        UIButton *cancelButton = fl_buttonCancel();
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
        [cancelButton addTarget:self action:@selector(cancelDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self setupCustomCell];
}

#pragma mark action
- (void)cancelDidSelect:(id)sender {
    if (self.type==ACCOUNT_CHANGE) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)saveAction:(id)sender {
    [self.view endEditing:YES];
    [self.accountSetting validWithModel:self.accountModel success:^(NSString *message) {
        if (message) {
            NSString *stringOK = _LSFromTable (@"account.ok", @"FLAccountViewController", @"OK");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:stringOK, nil];
            [alert show];
        }else{
            [self.accountSetting saveAccountInfo:self.accountModel success:^{
                if (self.didCompleteSaveInfo) {
                    self.didCompleteSaveInfo();
                }
                if (self.type==ACCOUNT_CHANGE) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } fail:^{
                
            }];
        }
    }];
}

#pragma mark tableView

- (void)setupCustomCell {
    [self.tbView registerNib:[UINib nibWithNibName:NSStringFromClass([FLAccountCustomCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FLAccountCustomCell class])];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountModel.numberRow;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLAccountCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FLAccountCustomCell class]) forIndexPath:indexPath];
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    cell.textField.secureTextEntry = NO;
    if (indexPath.row==ACCOUNT_ROW_NAME) {
        if (!self.accountModel.name.length) {
            cell.textField.placeholder = self.accountModel.titleName;
        }else{
            cell.textField.text = self.accountModel.name;
        }
    }
    if (indexPath.row==ACCOUNT_ROW_EMAIL) {
        if (!self.accountModel.email.length) {
            cell.textField.placeholder = self.accountModel.titleEmail;
        }else{
            cell.textField.text = self.accountModel.email;
        }
        cell.textField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    if (indexPath.row==ACCOUNT_ROW_PASSWORD) {
        if (!cell.textField.text.length) {
            cell.textField.placeholder = self.accountModel.titlePassword;
        }
        cell.textField.secureTextEntry = YES;
    }
    if (indexPath.row==ACCOUNT_ROW_CONFIRM_PASSWORD) {
        if (!cell.textField.text.length) {
            cell.textField.placeholder = self.accountModel.titleRepassword;
        }
        cell.textField.secureTextEntry = YES;
    }
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    return cell;
}

#pragma mark UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case ACCOUNT_ROW_NAME:
            self.accountModel.name = textField.text;
            break;
        case ACCOUNT_ROW_EMAIL:
            self.accountModel.email = textField.text;
            break;
        case ACCOUNT_ROW_PASSWORD:
            self.accountModel.password = textField.text;
            break;
        case ACCOUNT_ROW_CONFIRM_PASSWORD:
            self.accountModel.rePassword = textField.text;
        default:
            break;
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
