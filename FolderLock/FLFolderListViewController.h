//
//  FLFolderListViewController.h
//  FolderLock
//
//  Created by QSOFT on 7/13/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StartApp/StartApp.h>

@interface FLFolderListViewController : UIViewController<STADelegateProtocol, UITableViewDataSource, UITableViewDelegate>{
    STAStartAppAd *startAppAd_loadShow;
    STABannerView *startAppBanner_fixed;
}
@property (strong, nonatomic) IBOutlet UITableView *tbView;

@end
