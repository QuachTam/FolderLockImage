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
#import "FLListPhotoViewController.h"
#import <skpsmtpmessage/SKPSMTPMessage.h>
#import "AccountModel.h"

static NSString *listFolderTableViewCell = @"FLListFolderTableViewCell";

@interface FLFolderListViewController ()<CameraObjectDelegate, MFMailComposeViewControllerDelegate, SWTableViewCellDelegate, SKPSMTPMessageDelegate>
@property (nonatomic, strong) FLAccountSetting *accountSetting;
@property (nonatomic, strong) NSMutableArray *folderModels;
@property (nonatomic, strong) SKPSMTPMessage *forgotPassword;
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
    [self btnLoadShowClick:nil];
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
    camera.typeSaveImage = ONCE_IMAGE;
    camera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [camera showCamera];
}

- (void)didFinishPickingMediaWithInfo:(UIImage *)image {
    FLListFolderChooseViewController *choose = [[FLListFolderChooseViewController alloc] initWithNibName:NSStringFromClass([FLListFolderChooseViewController class]) bundle:nil];
    choose.image = image;
    choose.typeSavePhoto = CREATE_PHOTO;
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
    [view setBackgroundColor:[UIColor colorWithRed:139/255.f green:195/255.f blue:74/255.f alpha:1]];
    UIButton *button = fl_buttonAdd();
    [view addSubview:button];
    [button addTarget:self action:@selector(addFolder:) forControlEvents:UIControlEventTouchUpInside];
    
    [button autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:15];
    [button autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:7];
    [button autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:7];
    [button autoSetDimension:ALDimensionHeight toSize:25];
    [button autoSetDimension:ALDimensionWidth toSize:25];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FLFolderModel *model = [self.service.listModelFolder objectAtIndex:indexPath.row];
    model.listPhotoModel = nil;
    if (model.isPassword) {
        [self presentRegisterAnAccountViewController:model];
    }else{
        [self gotoFolderDetailViewController:model];
    }
}

- (void)gotoFolderDetailViewController:(FLFolderModel *)folderModel {
    FLListPhotoViewController *photoVC = [[FLListPhotoViewController alloc] initWithNibName:NSStringFromClass([FLListPhotoViewController class]) bundle:nil];
    photoVC.folderModel = folderModel;
    [self.navigationController pushViewController:photoVC animated:YES];
}

- (NSArray *)leftButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:_LSFromTable(@"title.strings.edit", @"FLFolderListViewController", @"Edit")];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:_LSFromTable(@"title.strings.delete", @"FLFolderListViewController", @"Delete")];
    
    return rightUtilityButtons;
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            NSIndexPath *cellIndexPath = [self.tbView indexPathForCell:cell];
            FLFolderModel *folderModel = [self.folderModels objectAtIndex:cellIndexPath.row];
            folderModel.rePassword = folderModel.password;
            
            FLCreateFolderViewController *editFolder = [[FLCreateFolderViewController alloc] initWithNibName:NSStringFromClass([FLCreateFolderViewController class]) bundle:nil];
            editFolder.folderModel = folderModel;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editFolder];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_LSFromTable(@"title.strings.confirm.delete", @"FLFolderListViewController", @"Do you want delete this folder") delegate:nil cancelButtonTitle:_LSFromTable(@"title.strings.cancel", @"FLFolderListViewController", @"Cancel") otherButtonTitles:_LSFromTable(@"title.strings.ok", @"FLFolderListViewController", @"OK"), nil];
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
        MZFormSheetController * formSheet = [[MZFormSheetController alloc] initWithSize:CGSizeMake(self.view.bounds.size.width-20, 154) viewController:nav];
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
    MZFormSheetController * formSheet = [[MZFormSheetController alloc] initWithSize:CGSizeMake(self.view.bounds.size.width-20, 145) viewController:nav];
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
    AccountModel *accountModel = [[AccountModel alloc] initWithUser:[FLAccountSetting findUser]];
    
    NSString *emailTitle = [NSString stringWithFormat:_LSFromTable(@"title.strings.forgotpassword", @"FLFolderListViewController", @"Forgot password")];
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"%@ %@: %@",_LSFromTable(@"title.strings.password.of.folder", @"FLFolderListViewController", @"Password of folder"), folderModel.name, folderModel.password];
    // To address
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_LSFromTable(@"title.strings.send.email.success", @"FLFolderListViewController", @"Send email success") delegate:nil cancelButtonTitle:nil otherButtonTitles:_LSFromTable(@"title.strings.ok", @"FLFolderListViewController", @"OK"), nil];
    [alert show];
    self.forgotPassword = nil;
}
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    self.forgotPassword = nil;
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

- (void)didCloseAd:(STAAbstractAd *)ad {
    
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
