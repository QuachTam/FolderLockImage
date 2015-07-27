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
#import "FLAccountViewController.h"
#import "STAViewController.h"
#import "AccountModel.h"
#import "FLAccountSetting.h"
#import "LTHPasscodeViewController.h"
#import "CameraObject.h"
#import "FLFolderModel.h"
#import "FLListFolderTableViewCell.h"
#import "FLListFolderService.h"
#import "FLListFolderChooseViewController.h"
#import "FLCreateFolderViewController.h"
#import "FLInputPasswordViewController.h"
#import "FLPasswordViewController.h"
#import <MessageUI/MessageUI.h>
#import "FLAccountSetting.h"
#import "AccountModel.h"
#import "FLImageHelper.h"
#import "UIAlertView+VC.h"

static NSString *listFolderTableViewCell = @"FLListFolderTableViewCell";

@interface FLFolderListViewController ()<CameraObject, MFMailComposeViewControllerDelegate, SWTableViewCellDelegate>
@property (nonatomic, strong) FLAccountSetting *accountSetting;
@property (nonatomic, strong) NSMutableArray *folderModels;

@property (nonatomic, strong) FLListFolderService *service;
@end

@implementation FLFolderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = _LSFromTable(@"title.strings", @"FLFolderListViewController", @"List Folder");
    UIButton *settingButton = fl_buttonSetting();
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    [settingButton addTarget:self action:@selector(settingTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cameraButton = fl_buttonCamera();
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
    [cameraButton addTarget:self action:@selector(cameraTap:) forControlEvents:UIControlEventTouchUpInside];
    
    self.accountSetting = [[FLAccountSetting alloc] init];
    if (![self.accountSetting checkUserInfo]) {
        FLAccountViewController *account = [[FLAccountViewController alloc] initWithNibName:NSStringFromClass([FLAccountViewController class]) bundle:nil];
        account.type = ACCOUNT_SETUP;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:account];
        [self presentViewController:nav animated:YES completion:nil];
    }
    
    if (![LTHPasscodeViewController doesPasscodeExist]) {
        startAppAd_loadShow = [[STAStartAppAd alloc] init];
    }
    [self btnLoadShowClick:nil];
    [self registerTableViewCell];
    [self fetchResults];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (startAppBanner_fixed == nil) {
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
            startAppBanner_fixed = [[STABannerView alloc] initWithSize:STA_PortraitAdSize_768x90
                                                            autoOrigin:STAAdOrigin_Bottom
                                                              withView:self.view withDelegate:nil];
        } else {
            startAppBanner_fixed = [[STABannerView alloc] initWithSize:STA_PortraitAdSize_320x50
                                                            autoOrigin:STAAdOrigin_Bottom
                                                              withView:self.view withDelegate:nil];
        }
        [self.view addSubview:startAppBanner_fixed];
    }
}

- (void)setupFolderModels {
    
}

#pragma mark Action

- (void)settingTap:(id)sender {
    FLSettingViewController *setting = [[FLSettingViewController alloc] initWithNibName:NSStringFromClass([FLSettingViewController class]) bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:setting];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)cameraTap:(id)sencer {
    CameraObject *camera = [CameraObject shareInstance];
    camera.delegate = self;
    camera.supperView = self;
    camera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [camera showCamera];
}

- (void)didFinishPickingMediaWithInfo:(UIImage *)image {
    FLListFolderChooseViewController *choose = [[FLListFolderChooseViewController alloc] initWithNibName:NSStringFromClass([FLListFolderChooseViewController class]) bundle:nil];
    choose.image = image;
    choose.listFolder = self.service.listModelFolder;
    choose.didCompleteSaveImage = ^{
        
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:choose];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel {
    
}

- (void)registerTableViewCell {
    [self.tbView registerNib:[UINib nibWithNibName:NSStringFromClass([FLListFolderTableViewCell class]) bundle:nil] forCellReuseIdentifier:listFolderTableViewCell];
}

- (void)fetchResults {
    __weak __typeof(self)week = self;
    if (!self.service) {
        self.service = [[FLListFolderService alloc] init];
    }
    self.service.didFinishFetchResults = ^{
        __strong __typeof(week)strong = week;
        strong.folderModels = [NSMutableArray arrayWithArray:strong.service.listModelFolder];
        [strong.tbView reloadData];
    };
    self.service.resultsChangeInsert = ^(NSArray *indexPaths) {
        __strong __typeof(week)strong = week;
        strong.folderModels = [NSMutableArray arrayWithArray:strong.service.listModelFolder];
        [strong.tbView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    };
    self.service.resultsChangeUpdate = ^(NSArray *indexPaths) {
        __strong __typeof(week)strong = week;
        NSIndexPath *indexPath = [indexPaths lastObject];
        FLFolderModel *folderModel = [strong.folderModels objectAtIndex:indexPath.row];
        folderModel.urlIcon = nil;
        [strong.tbView reloadData];
    };
    self.service.resultsChangeMove = ^(NSArray *indexPaths) {};
    
    self.service.resultsChangeDelete = ^(NSArray *indexPaths) {
        __strong __typeof(week)strong = week;
        strong.folderModels = [NSMutableArray arrayWithArray:strong.service.listModelFolder];
        [strong.tbView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [strong.tbView reloadData];
    };
    
    [self.service fetchDatabase];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.service.listModelFolder.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40.f)];
    [view setBackgroundColor:[UIColor colorWithRed:239/255.f green:239/255.f blue:244/255.f alpha:1]];
    UIButton *button = fl_buttonAdd();
    [view addSubview:button];
    [button addTarget:self action:@selector(addFolder:) forControlEvents:UIControlEventTouchUpInside];
    
    [button autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15];
    [button autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:5];
    [button autoSetDimension:ALDimensionHeight toSize:30];
    [button autoSetDimension:ALDimensionWidth toSize:30];
    return view;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLListFolderTableViewCell *cell = [self.tbView dequeueReusableCellWithIdentifier:listFolderTableViewCell forIndexPath:indexPath];
    [cell setValueForCell:[self.service.listModelFolder objectAtIndex:indexPath.row]];
    cell.leftUtilityButtons = [self leftButtons];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FLFolderModel *model = [self.service.listModelFolder objectAtIndex:indexPath.row];
    if (model.isPassword) {
        [self presentRegisterAnAccountViewController:model];
    }else{
        [self gotoFolderDetailViewController:model];
    }
}

- (void)gotoFolderDetailViewController:(FLFolderModel *)folderModel {
//    FolderDetailViewController *photoVC = [[FolderDetailViewController alloc] initWithNibName:NSStringFromClass([FolderDetailViewController class]) bundle:nil];
//    photoVC.folderModel = folderModel;
//    [self.navigationController pushViewController:photoVC animated:YES];
}

- (NSArray *)leftButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"Edit"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"Delete"];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            NSIndexPath *cellIndexPath = [self.tbView indexPathForCell:cell];
            FLFolderModel *folderModel = [self.folderModels objectAtIndex:cellIndexPath.row];
            
            FLCreateFolderViewController *editFolder = [[FLCreateFolderViewController alloc] initWithNibName:NSStringFromClass([FLCreateFolderViewController class]) bundle:nil];
            editFolder.folderModel = folderModel;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editFolder];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Do you want delete this folder" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert showAlerViewWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex) {
                    NSIndexPath *cellIndexPath = [self.tbView indexPathForCell:cell];
                    [self.service deleteFolder:[self.folderModels objectAtIndex:cellIndexPath.row]];
                }
            }];
            break;
        }
        default:
            break;
    }
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
}

- (void)addFolder:(id)sender {
    FLCreateFolderViewController *createFolder = [[FLCreateFolderViewController alloc] initWithNibName:NSStringFromClass([FLCreateFolderViewController class]) bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:createFolder];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)presentRegisterAnAccountViewController:(FLFolderModel*)folderModel{
    if (folderModel) {
        FLInputPasswordViewController *registerAccount = [[FLInputPasswordViewController alloc] initWithNibName:NSStringFromClass([FLInputPasswordViewController class]) bundle:nil];
        registerAccount.folderModel = folderModel;
        registerAccount.didCompleteSuccessPassword = ^{
            [self gotoFolderDetailViewController:folderModel];
        };
        registerAccount.actionForgotPassword = ^{
            [self mz_dismissFormSheetControllerAnimated:YES completionHandler:^(MZFormSheetController *formSheetController) {
                [self gotoPasswordViewController:folderModel];
            }];
        };
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerAccount];
        MZFormSheetController * formSheet = [[MZFormSheetController alloc] initWithSize:CGSizeMake(self.view.bounds.size.width-20, 164) viewController:nav];
        [self MZFromSheetViewController:formSheet];
    }
}

- (void)gotoPasswordViewController:(FLFolderModel*)folderModel{
    NSString *stringPassword = [LTHPasscodeViewController sharedUser].password;
    FLPasswordViewController *registerAccount = [[FLPasswordViewController alloc] initWithNibName:NSStringFromClass([FLPasswordViewController class]) bundle:nil];
    registerAccount.stringPassword = stringPassword;
    registerAccount.stringTitle = @"Passcode";
    registerAccount.didCompleteSuccessPassword = ^{
        [self openSendMail:folderModel];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:registerAccount];
    MZFormSheetController * formSheet = [[MZFormSheetController alloc] initWithSize:CGSizeMake(self.view.bounds.size.width-20, 125) viewController:nav];
    [self MZFromSheetViewController:formSheet];
}

- (void)MZFromSheetViewController:(MZFormSheetController*)formSheet {
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsMoveToTop;
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromRight;
    
    self.navigationController.formSheetController.transitionStyle = MZFormSheetTransitionStyleSlideFromLeft;
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:nil];
}

- (void)openSendMail:(FLFolderModel*)folderModel{
    NSString *emailTitle = [NSString stringWithFormat:@"Forgot password"];
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"Password of folder %@ is %@", folderModel.name, folderModel.password];
    // To address
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:emailTitle message:messageBody delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [startAppBanner_fixed didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation ];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

// Tell the system It should autorotate
- (BOOL) shouldAutorotate{
    return YES && (startAppAd_loadShow.STAShouldAutoRotate);
}

#pragma mark Load and Show button click
- (IBAction)btnLoadShowClick:(id)sender
{
    [startAppAd_loadShow loadAdWithDelegate:self];
}

#pragma mark STADelegateProtocol methods
// StartApp Ad loaded successfully
- (void) didLoadAd:(STAAbstractAd*)ad;
{
    NSLog(@"StartApp Ad had been loaded successfully");
    if (startAppAd_loadShow == ad) {
        [startAppAd_loadShow showAd];
    }
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
