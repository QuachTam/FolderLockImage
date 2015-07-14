//
//  FLFolderListViewController.m
//  FolderLock
//
//  Created by QSOFT on 7/13/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLFolderListViewController.h"
#import "FLButtonHelper.h"
#import "FLSettingViewController.h"

@interface FLFolderListViewController ()

@end

@implementation FLFolderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = _LSFromTable(@"title.strings", @"FLFolderListViewController", @"List Folder");
    UIButton *settingButton = fl_buttonSetting();
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    [settingButton addTarget:self action:@selector(settingTap:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark Action

- (void)settingTap:(id)sender {
    FLSettingViewController *setting = [[FLSettingViewController alloc] initWithNibName:NSStringFromClass([FLSettingViewController class]) bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setting];
    [self presentViewController:nav animated:YES completion:nil];
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
