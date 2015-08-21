//
//  FLListPhotoViewController.m
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLListPhotoViewController.h"
#import "FLListPhotoCustomViewCellTableViewCell.h"
#import "FLPhotoModel.h"
#import "FLButtonHelper.h"
#import "CameraObject.h"
#import "FLPhotoService.h"
#import "FLListFolderChooseViewController.h"
#import "UIAlertView+VC.h"
#import "VCPhotoPageController.h"
#import "CTAssetsPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "FLManageImage.h"
#import <Accounts/Accounts.h>
#import <STTwitter/STTwitter.h>
#import <Twitter/Twitter.h>
#import "DBCameraViewController.h"
#import "DBCameraContainerViewController.h"
#import "MHOverviewController.h"
#import "UIImageView+WebCache.h"
#import "FLManageImage.h"
#import "FLImageHelper.h"

static NSString *customListPhotoCell = @"FLListPhotoCustomViewCellTableViewCell";
static NSString *consumerKey = @"u3C1JoMbkYYXk36uqNJ3CoPCz";
static NSString *consumerSecret = @"eZXChsh84InSUWXA2TRhWDE7dUYrbhXbbcM46KQcQ8dTluSU9a";
NSInteger TAG_SELECT_ACCOUNT_TWITTER = 100001;

typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage); // don't bother with NSError for that

@interface FLListPhotoViewController ()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, CameraObjectDelegate, UIActionSheetDelegate,CTAssetsPickerControllerDelegate, FBSDKSharingDelegate, DBCameraViewControllerDelegate>
@property (nonatomic, strong) FLPhotoService *service;
@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;
@property (nonatomic, strong) accountChooserBlock_t accountChooserBlock;
@property (nonatomic, strong) FBSDKSharePhoto *photoShare;
@property (nonatomic, strong) FBSDKSharePhotoContent *content;
@property (nonatomic,strong) NSArray *galleryDataSource;
@property (nonatomic, strong) NSArray *listPhotoModel;
@property (nonatomic, strong) DBCameraContainerViewController *cameraContainer;
@end

@implementation FLListPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars=NO;
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.tbView = [[UITableView alloc] initForAutoLayout];
    self.tbView.dataSource = self;
    self.tbView.delegate = self;
    [self.tbView setBackgroundColor:[UIColor clearColor]];
    [self.tbView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tbView];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        [self.tbView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:90];
    [self.tbView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50];
    [self.tbView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.tbView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    [self.tbView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    
    self.title = _LSFromTable(@"title.strings", @"FLListPhotoViewController", @"List Photo");
    UIButton *backBtn = fl_buttonBack();
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIButton *cameraButton = fl_buttonCamera();
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
    [cameraButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    [self registerTableViewCell];
    self.service = [[FLPhotoService alloc] init];
    self.listPhotoModel = [NSArray new];
    [self performSelectorInBackground:@selector(setUpData) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated {
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


#pragma mark login twitter

- (void)tweetTapped:(UIImage *)image{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *sheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        if (image) {
            [sheet addImage:image];
        }
        SLComposeViewControllerCompletionHandler completionBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Cancelled");
            } else {
                NSLog(@"Done");
            }
            
            [sheet dismissViewControllerAnimated:YES completion:Nil];
        };
        sheet.completionHandler = completionBlock;
        
        //Adding the Text to the post value from iOS
        [sheet setInitialText:@"hello twitter"];
        [self presentViewController:sheet animated:YES completion:Nil]; 
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:kShowAlertView object:@{@"title":@"Please Enter your account on setting"}];
    }
}

- (void)reloadData {
    self.folderModel.listPhotoModel = nil;
    [self setUpData];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMore {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Take photo", @"Choose Existing", nil];
    //[actionSheet showInView:self.view];
    [actionSheet showInView:self.navigationController.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag==TAG_SELECT_ACCOUNT_TWITTER) {
        if(buttonIndex == [actionSheet cancelButtonIndex]) {
            _accountChooserBlock(nil, @"Account selection was cancelled.");
            return;
        }
        NSUInteger accountIndex = buttonIndex - 1;
        ACAccount *account = [_iOSAccounts objectAtIndex:accountIndex];
        _accountChooserBlock(account, nil);
    }else{
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"Take photo"]) {
            [self openCamera];
        }else if ([title isEqualToString:@"Choose Existing"]){
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                dispatch_async(dispatch_get_main_queue(), ^{
                    // request authorization status
                    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // init picker
                            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                            // set delegate
                            picker.delegate = self;
                            // to present picker as a form sheet on iPad
                            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                                picker.modalPresentationStyle = UIModalPresentationFormSheet;
                            // present picker
                            [self presentViewController:picker animated:YES completion:nil];
                        });
                    }];
                });
            }];
        }
    }
}


#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (picker.selectedAssets.count > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [picker dismissViewControllerAnimated:YES completion:^{
            for (PHAsset * asset in picker.selectedAssets) {
                PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                options.synchronous = YES;
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
                    [self.service saveImageToFolder:self.folderModel image:@[result] success:^{
                        
                    }];
                }];
            }
            [self reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else {
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void) openCamera
{
    if (!self.cameraContainer) {
        self.cameraContainer = [[DBCameraContainerViewController alloc] initWithDelegate:self];
    }
    [self.cameraContainer setFullScreenMode];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self.cameraContainer];
    [nav setNavigationBarHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

//Use your captured image
#pragma mark - DBCameraViewControllerDelegate

- (void) camera:(id)cameraViewController didFinishWithImage:(UIImage *)image withMetadata:(NSDictionary *)metadata
{
    if (!self.service) {
        self.service = [[FLPhotoService alloc] init];
    }
    [self.service saveImageToFolder:self.folderModel image:@[image] success:^{
        [self reloadData];
        [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void) dismissCamera:(id)cameraViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
    [cameraViewController restoreFullScreenMode];
}

#pragma mark cameraDelegate
- (void)didFinishPickingMediaWithInfo:(UIImage *)image {
    if (!self.service) {
        self.service = [[FLPhotoService alloc] init];
    }
    [self.service saveImageToFolder:self.folderModel image:@[image] success:^{
        [self reloadData];
    }];
}

- (void)imagePickerControllerDidCancel {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)registerTableViewCell {
    [self.tbView registerNib:[UINib nibWithNibName:NSStringFromClass([FLListPhotoCustomViewCellTableViewCell class]) bundle:nil] forCellReuseIdentifier:customListPhotoCell];
}

- (void)setUpData{
    NSMutableArray *lists = [NSMutableArray new];
    self.listPhotoModel = self.folderModel.listPhotoModel;
    for (NSInteger index = 0; index < self.listPhotoModel.count; index++) {
        NSString *stringUrl = [FLManageImage getURLPathImage:[[self.listPhotoModel objectAtIndex:index] uuid] folderID:self.folderModel.uuid];
        NSString *stringUrlThumbnail = [FLManageImage getURLPathThumbnailImage:[[self.listPhotoModel objectAtIndex:index] uuid] folderID:self.folderModel.uuid];
        MHGalleryItem *landscha = [[MHGalleryItem alloc]initWithURL:stringUrl
                                                           galleryType:MHGalleryTypeImage];
        landscha.thumbnailURL = stringUrlThumbnail;
        [lists addObject:landscha];
    }
    self.galleryDataSource = [lists copy];
    [self.tbView reloadData];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FLListPhotoCustomViewCellTableViewCell *cell = [self.tbView dequeueReusableCellWithIdentifier:customListPhotoCell forIndexPath:indexPath];
    cell.leftUtilityButtons = [self leftButtons];
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIImageView *imageView = [(FLListPhotoCustomViewCellTableViewCell*)[tableView cellForRowAtIndexPath:indexPath] imgView];
    
    NSArray *galleryData = self.galleryDataSource;
    
    
    MHGalleryController *gallery = [[MHGalleryController alloc]initWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarShown];
    gallery.galleryItems = galleryData;
    gallery.presentingFromImageView = imageView;
    gallery.presentationIndex = indexPath.row;
    
    __weak MHGalleryController *blockGallery = gallery;
    
    gallery.finishedCallback = ^(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition,MHGalleryViewMode viewMode){
        
        NSIndexPath *newIndex = [NSIndexPath indexPathForRow:currentIndex inSection:0];
        
        [self.tbView scrollToRowAtIndexPath:newIndex atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imageView = [(FLListPhotoCustomViewCellTableViewCell*)[self.tbView cellForRowAtIndexPath:newIndex] imgView];
            [blockGallery dismissViewControllerAnimated:YES dismissImageView:imageView completion:nil];
        });
        
    };
    
    [self presentMHGalleryController:gallery animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.galleryDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (void)configureBasicCell:(FLListPhotoCustomViewCellTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    MHGalleryItem *item = self.galleryDataSource[indexPath.row];
    FLPhotoModel *photoModel = [self.listPhotoModel objectAtIndex:indexPath.row];
    [cell valueForCell:photoModel galleryItem:item];
}


- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static FLListPhotoCustomViewCellTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tbView dequeueReusableCellWithIdentifier:customListPhotoCell];
    });
    
    [self configureBasicCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tbView.frame), CGRectGetHeight(sizingCell.bounds));
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    if(size.height<60)
        return 60;
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}


#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    [cell hideUtilityButtonsAnimated:NO];
    switch (index) {
        case 0:{
            NSIndexPath *cellIndexPath = [self.tbView indexPathForCell:cell];
            FLListFolderChooseViewController *chooseFolder = [[FLListFolderChooseViewController alloc] initWithNibName:NSStringFromClass([FLListFolderChooseViewController class]) bundle:nil];
            chooseFolder.typeSavePhoto = MOVE_PHOTO;
            chooseFolder.photoModel = [self.listPhotoModel objectAtIndex:cellIndexPath.row];
            chooseFolder.didCompleteSaveImage = ^{
                self.folderModel.listPhotoModel = nil;
                [self setUpData];
            };
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:chooseFolder];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_LSFromTable(@"title.strings.confirm.delete", @"FLListPhotoViewController", @"Do you want delete this folder") delegate:nil cancelButtonTitle:_LSFromTable(@"title.strings.cancel", @"FLFolderListViewController", @"Cancel") otherButtonTitles:_LSFromTable(@"title.strings.ok", @"FLFolderListViewController", @"OK"), nil];
            [alert showAlerViewWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex) {
                    NSIndexPath *cellIndexPath = [self.tbView indexPathForCell:cell];
                    [self.service deleteImageInFolder:self.folderModel photoMode:[self.listPhotoModel objectAtIndex:cellIndexPath.row] success:^{
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:_LSFromTable(@"title.strings.delete.success", @"FLListPhotoViewController", @"Delete success") delegate:nil cancelButtonTitle:nil otherButtonTitles:_LSFromTable(@"title.strings.ok", @"FLFolderListViewController", @"OK"), nil];
                        [alert show];
                        [self reloadData];
                    }];
                }
            }];
            break;
        }
        default:
            break;
    }
    
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    [cell hideUtilityButtonsAnimated:NO];
    switch (index) {
        case 0:{
            FLPhotoModel *photoModel = [self.listPhotoModel firstObject];
            UIImage *image = [FLManageImage getImage:photoModel.uuid folderID:self.folderModel.uuid];
            [self tweetTapped:image];
            break;
        }
        case 1:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"What is on your mind?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert showAlerViewWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex) {
                    UITextField *textInput = [alertView textFieldAtIndex:0];
                    if ([FBSDKAccessToken currentAccessToken]) {
                        NSIndexPath *cellIndexPath = [self.tbView indexPathForCell:cell];
                        FLPhotoModel *photoModel = [self.listPhotoModel objectAtIndex:cellIndexPath.row];
                        UIImage *image = [FLManageImage getImage:photoModel.uuid folderID:self.folderModel.uuid];
                        [self postToWallImage:image message:textInput.text];
                    }else{
                        [self loginButtonClicked:nil];
                    }
                }
            }];
            break;
        }
        default:
            break;
    }
}

- (void)postToWallImage:(UIImage*)image message:(NSString*)message{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        if (image) {
            [self sharePhoto:image message:message];
        }
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (!error && image) {
                [self sharePhoto:image message:message];
            }
        }];
    }
}

- (void)sharePhoto:(UIImage*)image message:(NSString*)message{
    self.photoShare = [[FBSDKSharePhoto alloc] init];
    if (message.length) {
        self.photoShare.caption = message;
    }
    self.photoShare.image = image;
    self.photoShare.userGenerated = YES;
    self.content = [[FBSDKSharePhotoContent alloc] init];
    self.content.photos = @[self.photoShare];
    [FBSDKShareAPI shareWithContent:self.content delegate:self];
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    
}

- (IBAction)loginButtonClicked:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@",error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                [self fetchUserInfo];
            }
        }
    }];
}

-(void)fetchUserInfo {
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Fetched User Information:%@", result);
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    } else {
        
        NSLog(@"User is not Logged in");
    }
}



- (NSArray *)leftButtons
{
    NSMutableArray *lefttUtilityButtons = [NSMutableArray new];
    [lefttUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:_LSFromTable(@"title.strings.move", @"FLListPhotoViewController", @"Move")];
    [lefttUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:_LSFromTable(@"title.strings.delete", @"FLListPhotoViewController", @"Delete")];
    
    return lefttUtilityButtons;
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:_LSFromTable(@"title.strings.process.image", @"FLListPhotoViewController", @"Processing")];    
    return rightUtilityButtons;
}



#pragma mark - photo detail

- (void)showPhotoPageControllerAtIndex:(NSInteger)index
{
    VCPhotoPageController * photoPageController = [[VCPhotoPageController alloc] initWithPhotos:self.listPhotoModel];
    [photoPageController setPageIndex:index];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:photoPageController];
    [navController setViewControllers:@[photoPageController]];
    [self presentViewController:navController animated:YES completion:NULL];
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
