//
//  CreateFolderService.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateFolderService : NSObject
- (NSString *)checkValidNameFolder:(NSString*)folderName password:(NSString*)password rePassowrd:(NSString*)rePassowrd;
- (void)saveFolder:(NSString *)name password:(NSString*)passowrd success:(void(^)(void))success;
@end
