//
//  FLListPhotoCustomViewCellTableViewCell.h
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>

@interface FLListPhotoCustomViewCellTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbDateCreate;

@end
