//
//  FLListPhotoViewController.h
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLFolderModel.h"

@interface FLListPhotoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic, strong) FLFolderModel *folderModel;
@end
