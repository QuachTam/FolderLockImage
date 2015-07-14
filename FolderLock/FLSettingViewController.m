//
//  FLSettingViewController.m
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLSettingViewController.h"
#import "FLTableViewCellAccount.h"
#import "FLTableViewCellPasscode.h"
#import "FLTableViewCellSignText.h"
#import "SettingModel.h"
#import "FLButtonHelper.h"
#import "AccountModel.h"
#import "LTHPasscodeViewController.h"

NSString *const identifyAbout = @"FLTableViewCellSignText";
NSString *const idendifyLegal = @"FLTableViewCellSignText";

@interface FLSettingViewController ()<LTHPasscodeViewControllerDelegate>
@property (nonatomic, strong) SettingModel *settingModel;
@property (nonatomic, readwrite) BOOL isOnSercurity;
@end

@implementation FLSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.settingModel = [[SettingModel alloc] init];
    self.title = self.settingModel.title;
    
    UIButton *settingButton = fl_buttonCancel();
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    [settingButton addTarget:self action:@selector(cancelDidSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self setupCustomCell];
    [self setupPasscode];
}

#pragma mark Passcode

- (void)setupPasscode {
    NSString *stringPassword = [LTHPasscodeViewController sharedUser].password;
    self.isOnSercurity = stringPassword.length ? 1:0;
    
    [self setupCustomCell];
    
    [[LTHPasscodeViewController sharedUser] setKeychainPasscodeUsername:kKeychainPasscode];
    [[LTHPasscodeViewController sharedUser] setKeychainServiceName:kKeychainService];
    [LTHPasscodeViewController sharedUser].delegate = self;
    [LTHPasscodeViewController sharedUser].maxNumberOfAllowedFailedAttempts = 3;
    [[LTHPasscodeViewController sharedUser] setBackgroundImage:nil];
    [[LTHPasscodeViewController sharedUser] setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]];
    [[LTHPasscodeViewController sharedUser] setPasscodeTextColor:[UIColor blackColor]];
    [[LTHPasscodeViewController sharedUser] setLabelTextColor:[UIColor blackColor]];
    [[LTHPasscodeViewController sharedUser] setLabelFont:[UIFont systemFontOfSize:20]];
}

#pragma mark action
- (void)cancelDidSelect:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark tableView

- (void)setupCustomCell {
    [self.tbView registerNib:[UINib nibWithNibName:NSStringFromClass([FLTableViewCellAccount class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FLTableViewCellAccount class])];
    
    [self.tbView registerNib:[UINib nibWithNibName:NSStringFromClass([FLTableViewCellPasscode class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FLTableViewCellPasscode class])];
    
    [self.tbView registerNib:[UINib nibWithNibName:NSStringFromClass([FLTableViewCellSignText class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FLTableViewCellSignText class])];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settingModel.numberSection;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==SETTING_SECTION_ACCOUNT) {
        return self.settingModel.section_account.count;
    }else if (section==SETTING_SECTION_PASSCODE){
        return self.settingModel.section_passcode.count;
    }else if (section==SETTING_SECTION_ABOUT) {
        return self.settingModel.section_about.count;
    }else if (section==SETTING_SECTION_LEGAL) {
        return self.settingModel.section_legal.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==SETTING_SECTION_ACCOUNT) {
        return [self tableViewAccountWithIndexPath:indexPath tableview:tableView];
    }else if(indexPath.section==SETTING_SECTION_PASSCODE) {
        return [self tableViewPasscodeWithIndexPath:indexPath tableview:tableView];
    }else if (indexPath.section==SETTING_SECTION_ABOUT) {
        return [self tableViewAboutWithIndexPath:indexPath tableview:tableView];
    }else{
        return [self tableViewLegalWithIndexPath:indexPath tableview:tableView];
    }
}

- (FLTableViewCellAccount*)tableViewAccountWithIndexPath:(NSIndexPath*)indexPath tableview:(UITableView*)tableView{
    FLTableViewCellAccount *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FLTableViewCellAccount class]) forIndexPath:indexPath];
    AccountModel *accountModel = [self.settingModel.section_account objectAtIndex:0];
    cell.account.text = accountModel.name;
    cell.email.text = accountModel.email;
    return cell;
}

- (FLTableViewCellPasscode*)tableViewPasscodeWithIndexPath:(NSIndexPath*)indexPath tableview:(UITableView*)tableView {
    FLTableViewCellPasscode *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FLTableViewCellPasscode class]) forIndexPath:indexPath];
    cell.title.text = [self.settingModel.section_passcode objectAtIndex:0];
    [cell setOnSwitch:self.isOnSercurity];
    cell.didChangeValue = ^(NSInteger index){
        [self actionSecurity:index];
    };
    return cell;
}

- (FLTableViewCellSignText*)tableViewAboutWithIndexPath:(NSIndexPath*)indexPath tableview:(UITableView*)tableView {
    FLTableViewCellSignText *cell = [tableView dequeueReusableCellWithIdentifier:identifyAbout forIndexPath:indexPath];
    cell.title.text = [self.settingModel.section_about objectAtIndex:0];
    return cell;
}

- (FLTableViewCellSignText*)tableViewLegalWithIndexPath:(NSIndexPath*)indexPath tableview:(UITableView*)tableView {
    FLTableViewCellSignText *cell = [tableView dequeueReusableCellWithIdentifier:identifyAbout forIndexPath:indexPath];
    cell.title.text = [self.settingModel.section_legal objectAtIndex:0];
    return cell;
}

#pragma action passcode

- (void)actionSecurity:(NSInteger)index {
    [self.tbView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    if (index) {
        [self _enablePasscode];
    }else{
        [self _turnOffPasscode];
    }
}

- (void)_turnOffPasscode {
    [self showLockViewForTurningPasscodeOff];
}


- (void)_changePasscode {
    [self showLockViewForChangingPasscode];
}


- (void)_enablePasscode {
    [self showLockViewForEnablingPasscode];
}

- (void)_switchPasscodeType:(UISwitch *)sender {
    [[LTHPasscodeViewController sharedUser] setIsSimple:sender.isOn
                                       inViewController:self
                                                asModal:YES];
}

- (void)showLockViewForEnablingPasscode {
    [[LTHPasscodeViewController sharedUser] showForEnablingPasscodeInViewController:self
                                                                            asModal:YES];
}

- (void)showLockViewForTestingPasscode {
    [[LTHPasscodeViewController sharedUser] showLockScreenWithAnimation:YES
                                                             withLogout:NO
                                                         andLogoutTitle:nil];
}


- (void)showLockViewForChangingPasscode {
    [[LTHPasscodeViewController sharedUser] showForChangingPasscodeInViewController:self asModal:YES];
}


- (void)showLockViewForTurningPasscodeOff {
    [[LTHPasscodeViewController sharedUser] showForDisablingPasscodeInViewController:self
                                                                             asModal:NO];
}

# pragma mark - LTHPasscodeViewController Delegates -

- (void)passcodeViewControllerWillClose {
    NSString *stringPassword = [LTHPasscodeViewController sharedUser].password;
    self.isOnSercurity = stringPassword.length ? 1:0;
    [self.tbView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)maxNumberOfFailedAttemptsReached {
    NSString *stringPassword = [LTHPasscodeViewController sharedUser].password;
    self.isOnSercurity = stringPassword.length ? 1:0;
    [self.tbView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    [LTHPasscodeViewController close];
}

- (void)passcodeWasEnteredSuccessfully {
    NSString *stringPassword = [LTHPasscodeViewController sharedUser].password;
    self.isOnSercurity = stringPassword.length ? 1:0;
    [self.tbView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)logoutButtonWasPressed {
    NSLog(@"Logout Button Was Pressed");
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
