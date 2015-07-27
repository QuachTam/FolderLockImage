//
//  ListFolderChooseViewController.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLListFolderChooseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tbView;
@property (nonatomic, strong) NSArray *listFolder;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, readwrite, copy) void(^didCompleteSaveImage)();
@end
