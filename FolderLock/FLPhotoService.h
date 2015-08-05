//
//  FLPhotoService.h
//  FolderLock
//
//  Created by ATam on 7/28/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLFolderModel.h"
#import "FLPhotoModel.h"

@interface FLPhotoService : NSObject
- (void)saveImageToFolder:(FLFolderModel*)folderModel image:(NSArray *)ListImage success:(void(^)(void))success;
- (void)deleteImageInFolder:(FLFolderModel*)folderModel photoMode:(FLPhotoModel*)photoModel success:(void(^)(void))success;
@end
