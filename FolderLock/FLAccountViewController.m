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

@interface FLAccountViewController ()
@property (nonatomic, strong) AccountModel *accountModel;
@end

@implementation FLAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *cancelButton = fl_buttonCancel();
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = fl_buttonSave();
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountModel = [[AccountModel alloc] init];
    self.title = self.accountModel.title;
    [self setupCustomCell];
}

#pragma mark action
- (void)cancelDidSelect:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAction:(id)sender {
    
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
    return cell;
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
