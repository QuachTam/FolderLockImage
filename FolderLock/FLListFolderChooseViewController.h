//
//  ListFolderChooseViewController.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPhotoModel.h"

typedef NS_ENUM(NSInteger, TYPE_SAVE_PHOTO) {
    CREATE_PHOTO = 0,
    MOVE_PHOTO
};

@interface FLListFolderChooseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readwrite) TYPE_SAVE_PHOTO typeSavePhoto;
@property (nonatomic, readwrite, copy) void(^didCompleteSaveImage)();
//only move photo
@property (nonatomic, strong) FLPhotoModel *photoModel;
//only move photo end
@end
