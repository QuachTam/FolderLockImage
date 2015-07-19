//
//  FLSettingViewController.h
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLSettingViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@end
