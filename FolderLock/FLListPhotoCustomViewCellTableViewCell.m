//
//  FLListPhotoCustomViewCellTableViewCell.m
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLListPhotoCustomViewCellTableViewCell.h"
#import "FLPhotoModel.h"
#import "FLManageImage.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FLImageHelper.h"
#import "MHGalleryItem.h"

@implementation FLListPhotoCustomViewCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.imgView.layer.cornerRadius = self.imgView.frame.size.width/2.0f;
    self.imgView.clipsToBounds = YES;
    self.imgView.layer.borderWidth = 2.5;
    self.imgView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)valueForCell:(FLPhotoModel*)photoModel galleryItem:(MHGalleryItem*)item{
    [self.imgView sd_setImageWithURL:[[NSURL alloc] initWithString:item.thumbnailURL] placeholderImage:[UIImage imageNamed:kImageDetault]];
    self.lbName.text = photoModel.name;
    self.lbDateCreate.text = photoModel.stringCreateDate;
}

@end
