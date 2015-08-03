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

static NSString *customListPhotoCell = @"FLListPhotoCustomViewCellTableViewCell";

@interface FLListPhotoViewController ()<UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, CameraObjectDelegate, UIActionSheetDelegate,CTAssetsPickerControllerDelegate>
@property (nonatomic, strong) FLPhotoService *service;
@end

@implementation FLListPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = _LSFromTable(@"title.strings", @"FLListPhotoViewController", @"List Photo");
    UIButton *backBtn = fl_buttonBack();
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    UIButton *cameraButton = fl_buttonCamera();
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cameraButton];
    [cameraButton addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
    [self registerTableViewCell];
    self.service = [[FLPhotoService alloc] init];
}

- (void)reloadData {
    self.folderModel.listPhotoModel = nil;
    [self.tbView reloadData];
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMore {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo", @"Choose Photo", nil];
    [action showInView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // init picker
                CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
                
                // set delegate
                picker.delegate = self;
                
                // present picker
                [self presentViewController:picker animated:YES completion:nil];
            });
        }];
//        [self showCameraPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if (buttonIndex==2){
        [self showCameraPicker:UIImagePickerControllerSourceTypeCamera];
    }
}

#pragma mark - Assets Picker Delegate

//- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
//{
//    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
//}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
//    if (picker.selectedAssets.count > 0) {
//        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [picker dismissViewControllerAnimated:YES completion:^{
//            for (ALAsset * asset in picker.selectedAssets) {
////                [self addFileNamePhotoList:asset];
//            }
//            
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
////            [self reloadPhotoCell];
//        }];
//    }
//    else {
//        [picker dismissViewControllerAnimated:YES completion:^{
//            
//        }];
//    }
}

//- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
//{
//    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
//    {
//        return NO;
//    }
//    else
//    {
//        return YES;
//    }
//}
//
//- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
//{
//    return (asset.defaultRepresentation != nil);
//}


- (void)showCameraPicker:(UIImagePickerControllerSourceType)sourceType
{
    CameraObject *camera = [CameraObject shareInstance];
    camera.delegate = self;
    camera.supperView = self;
    camera.typeSaveImage = MUTILPE_IMAGE;
    camera.sourceType = sourceType;
    [camera showCamera];
}

#pragma mark cameraDelegate
- (void)didFinishPickingMediaWithInfo:(UIImage *)image {
    if (!self.service) {
        self.service = [[FLPhotoService alloc] init];
    }
    [self.service saveImageToFolder:self.folderModel image:image success:^{
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.folderModel.listPhotoModel.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FLListPhotoCustomViewCellTableViewCell *cell = [self.tbView dequeueReusableCellWithIdentifier:customListPhotoCell forIndexPath:indexPath];
    cell.leftUtilityButtons = [self leftButtons];
    cell.delegate = self;
    [self configureBasicCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showPhotoPageControllerAtIndex:indexPath.row];
}

#pragma mark - SWTableViewDelegate

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            NSIndexPath *cellIndexPath = [self.tbView indexPathForCell:cell];
            FLListFolderChooseViewController *chooseFolder = [[FLListFolderChooseViewController alloc] initWithNibName:NSStringFromClass([FLListFolderChooseViewController class]) bundle:nil];
            chooseFolder.typeSavePhoto = MOVE_PHOTO;
            chooseFolder.photoModel = [self.folderModel.listPhotoModel objectAtIndex:cellIndexPath.row];
            chooseFolder.didCompleteSaveImage = ^{
                self.folderModel.listPhotoModel = nil;
                [self.tbView reloadData];
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
                    [self.service deleteImageInFolder:self.folderModel photoMode:[self.folderModel.listPhotoModel objectAtIndex:cellIndexPath.row] success:^{
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
    [cell hideUtilityButtonsAnimated:YES];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    
}


- (NSArray *)leftButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:_LSFromTable(@"title.strings.move", @"FLListPhotoViewController", @"Move")];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:_LSFromTable(@"title.strings.delete", @"FLListPhotoViewController", @"Delete")];
    
    return rightUtilityButtons;
}

- (void)configureBasicCell:(FLListPhotoCustomViewCellTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    FLPhotoModel *photoModel = [self.folderModel.listPhotoModel objectAtIndex:indexPath.row];
    [cell valueForCell:photoModel];
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


#pragma mark - photo detail

- (void)showPhotoPageControllerAtIndex:(NSInteger)index
{
    VCPhotoPageController * photoPageController = [[VCPhotoPageController alloc] initWithPhotos:self.folderModel.listPhotoModel];
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
