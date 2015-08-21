//
//  CreateFolderViewController.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLFolderModel.h"

typedef NS_ENUM(NSInteger, TYPE_VC){
    TYPE_CREATE = 0,
    TYPE_EDIT
};

@interface FLCreateFolderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic, strong) FLFolderModel *folderModel;
@property (nonatomic, readwrite) TYPE_VC type;

@end
