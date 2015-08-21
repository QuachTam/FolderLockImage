//
//  ListFolderTableViewCell.m
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import "FLListFolderTableViewCell.h"
#import "FLFolderModel.h"
#import "FLImageHelper.h"
#import "FLManageImage.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation FLListFolderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.iconFolder.layer.cornerRadius = self.iconFolder.frame.size.width/2.0f;
    self.iconFolder.clipsToBounds = YES;
    self.iconFolder.layer.borderWidth = 2.5;
    self.iconFolder.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setValueForCell:(FLFolderModel *)model {
    if (model.isPassword) {
        self.imageLock.hidden = NO;
        self.imageLock.image = [UIImage imageNamed:kImageLock];
    }else{
        self.imageLock.hidden = YES;
    }
    if (model.urlIcon && !model.password.length) {
        [self.iconFolder sd_setImageWithURL:[[NSURL alloc] initFileURLWithPath:[FLManageImage getContentOfFilemage:model.urlIcon folderID:model.uuid]] placeholderImage:[UIImage imageNamed:kImageDetault] options:SDWebImageCacheMemoryOnly];
    }else{
        [self.iconFolder setImage:[UIImage imageNamed:kImageDetault]];
    }

    self.folderName.attributedText = [[self class] getDetailContentFromTitle:@"Name" andValue:model.name withColon:YES];
    self.createDate.attributedText = [[self class] getDetailContentFromTitle:@"Date" andValue:model.stringCreateDate withColon:YES];
}

+ (NSMutableAttributedString *)getDetailContentFromTitle:(NSString *) title andValue:(NSString *)value withColon:(BOOL)colon
{
    NSString * tempStr = title;
    NSString *fullString = nil;
    if (tempStr.length) {
        tempStr = [tempStr stringByAppendingString:colon ? @":" : @""];
        fullString = tempStr;
        if(value.length) {
            fullString = [fullString stringByAppendingFormat:@" %@", value];
        }
    }
    NSMutableAttributedString * content;
    if (fullString.length) {
        content = [[NSMutableAttributedString alloc] initWithString: fullString];
        [content addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor], NSFontAttributeName: [UIFont systemFontOfSize:14]} range:NSMakeRange(0, tempStr.length)];
        [content addAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:14]} range:NSMakeRange(tempStr.length, fullString.length - tempStr.length)];
    }
    
    return content;
}

@end
