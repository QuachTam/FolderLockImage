//
//  FLAccountViewController.h
//  FolderLock
//
//  Created by QSOFT on 7/15/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountModel.h"

@interface FLAccountViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic, readwrite) TYPE type;
@property (nonatomic, copy, readwrite) void(^didCompleteSaveInfo)();

@end
