//
//  chooseFolderService.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLFolderModel.h"
#import "FLPhotoModel.h"
#import <UIKit/UIKit.h>

@interface chooseFolderService : NSObject
@property (nonatomic, strong) NSArray *listModelFolder;
@property (nonatomic, copy, readwrite) void(^didFinishFetchResults)();
- (void)fetchDatabase;
- (void)saveImageToFolder:(FLFolderModel*)folderModel image:(UIImage *)image success:(void(^)(void))success;
- (void)saveMoveImageToFolder:(FLFolderModel*)folderModel photoModel:(FLPhotoModel*)photoModel success:(void(^)(void))success;
@end
