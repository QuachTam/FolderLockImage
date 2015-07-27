//
//  CreateFolderService.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLFolderModel.h"

@interface CreateFolderService : NSObject
- (NSString *)checkValidNameFolder:(NSString*)folderName password:(NSString*)password rePassowrd:(NSString*)rePassowrd;
- (void)saveFolder:(FLFolderModel*)folderModel success:(void(^)(void))success;
@end
