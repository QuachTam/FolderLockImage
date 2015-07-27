//
//  CreateFolderViewController.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLFolderModel.h"

@interface FLCreateFolderViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic, strong) FLFolderModel *folderModel;

@end
