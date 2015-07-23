//
//  chooseFolderService.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLFolderModel.h"
#import <UIKit/UIKit.h>

@interface chooseFolderService : NSObject
- (void)saveImageToFolder:(FLFolderModel*)folderModel image:(UIImage *)image success:(void(^)(void))success;

@end
