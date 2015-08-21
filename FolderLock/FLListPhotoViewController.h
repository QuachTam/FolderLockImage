//
//  FLListPhotoViewController.h
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLFolderModel.h"
#import <StartApp/StartApp.h>

@interface FLListPhotoViewController : UIViewController {
    STABannerView *startAppBanner_fixed;
}
@property (strong, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic, strong) FLFolderModel *folderModel;
@property (nonatomic, readwrite, copy) void(^didCompleteGetData)();
@end
