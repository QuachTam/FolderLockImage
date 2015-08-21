//
//  FLListPhotoCustomViewCellTableViewCell.h
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWTableViewCell.h>
#import "FLPhotoModel.h"
#import "RWLabel.h"
#import "MHGalleryItem.h"

@interface FLListPhotoCustomViewCellTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet RWLabel *lbName;
@property (weak, nonatomic) IBOutlet RWLabel *lbDateCreate;

- (void)valueForCell:(FLPhotoModel*)photoModel galleryItem:(MHGalleryItem*)item;

@end
