//
//  CreateFolderViewController.m
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import "FLCreateFolderViewController.h"
#import "FLButtonHelper.h"
#import "TextFieldTableViewCell.h"
#import "CreateFolderService.h"

static NSString *textFieldIdentifier = @"textFieldIdentifier";

@interface FLCreateFolderViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSString *stringFolderName;
@property (nonatomic, strong) NSString *stringPassowrd;
@property (nonatomic, strong) NSString *stringRePassowrd;
@property (nonatomic, readwrite) UISwitch *swith;
@property (nonatomic, strong) CreateFolderService *service;
@end

@implementation FLCreateFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.type) {
        self.title = @"Edit Folder";
    }else{
        self.title = @"Create Folder";
    }
    
    if (!self.folderModel) {
        self.folderModel = [[FLFolderModel alloc] init];
    }
    
    self.stringFolderName = self.folderModel.name;
    self.stringPassowrd = self.folderModel.password;
    self.stringRePassowrd = self.folderModel.password;
    
    if (!self.swith) {
        self.swith = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    }
    if (self.stringPassowrd.length) {
        [self.swith setOn:YES];
    }else{
        [self.swith setOn:NO];
    }
    
    UIButton *cancelBtn = fl_buttonCancel();
    [cancelBtn addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIButton *saveBtn = fl_buttonSave();
    [saveBtn addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    
    [self registerTableViewCell];
}

- (void)registerTableViewCell {
    [self.tbView registerNib:[UINib nibWithNibName:NSStringFromClass([TextFieldTableViewCell class]) bundle:nil] forCellReuseIdentifier:textFieldIdentifier];
}

- (void)dismissViewController {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveAction:(id)sender {
    [self.view endEditing:YES];
    if (!self.service) {
        self.service = [[CreateFolderService alloc] init];
    }
    self.folderModel.name = self.stringFolderName;
    self.folderModel.password = self.stringPassowrd;
    self.folderModel.rePassword = self.stringRePassowrd;
    
    NSString *message = [self.service checkValidNameFolder:self.folderModel.name password:self.folderModel.password rePassowrd:self.folderModel.rePassword];
    if (message.length) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }else{
        [self.service saveFolder:self.folderModel success:^{
            [self dismissViewController];
        }];
    }
}

- (void)changeValue:(id)sender {
    [self.view endEditing:YES];
    if (![sender isOn]) {
        self.stringPassowrd = @"";
        self.stringRePassowrd = @"";
    }
    [self.tbView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.swith.isOn) {
        return 3;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.f)];
    [view setBackgroundColor:[UIColor colorWithRed:139/255.f green:195/255.f blue:74/255.f alpha:1]];
    [view addSubview:self.swith];
    [self.swith addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.swith autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:40];
    [self.swith autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [self.swith autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7];
    [self.swith autoSetDimension:ALDimensionHeight toSize:25];
    [self.swith autoSetDimension:ALDimensionWidth toSize:25];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lb.text = @"Enable Password";
    lb.textColor = [UIColor whiteColor];
    [view addSubview:lb];
    
    [lb autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:15];
    [lb autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [lb autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7];
    
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextFieldTableViewCell *cell = [self.tbView dequeueReusableCellWithIdentifier:textFieldIdentifier forIndexPath:indexPath];
    [self textFieldCell:indexPath TextFieldTableViewCell:cell];
    return cell;
}

- (void)textFieldCell:(NSIndexPath*)indexPath TextFieldTableViewCell:(TextFieldTableViewCell*)cell{
    if (indexPath.row==0) {
        if (self.stringFolderName.length) {
            cell.textField.text = self.stringFolderName;
        }else{
            [cell setValueTextField:@"Folder Name"];
        }
        cell.textField.secureTextEntry = NO;
    }else if (indexPath.row==1){
        if (self.stringPassowrd.length) {
            cell.textField.text = self.stringPassowrd;
        }else{
            cell.textField.text = nil;
            [cell setValueTextField:@"Password"];
        }
        cell.textField.secureTextEntry = YES;
    }else{
        if (self.stringRePassowrd.length) {
            cell.textField.text = self.stringRePassowrd;
        }else{
            cell.textField.text = nil;
            [cell setValueTextField:@"Re-Passoword"];
        }
        cell.textField.secureTextEntry = YES;
    }
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag==0) {
        self.stringFolderName = textField.text;
    }else if(textField.tag==1){
        self.stringPassowrd = textField.text;
    }else{
        self.stringRePassowrd = textField.text;
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
