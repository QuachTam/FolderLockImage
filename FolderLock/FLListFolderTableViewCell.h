//
//  ListFolderTableViewCell.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLFolderModel.h"
#import <SWTableViewCell.h>

@interface FLListFolderTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *folderName;
@property (weak, nonatomic) IBOutlet UILabel *createDate;
@property (weak, nonatomic) IBOutlet UIImageView *imageLock;
@property (weak, nonatomic) IBOutlet UIImageView *iconFolder;

- (void)setValueForCell:(FLFolderModel *)model;
@end

