//
//  CreateFolderService.m
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import "CreateFolderService.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Folder.h"
#import "FLFolderModel.h"

@implementation CreateFolderService
- (NSString *)checkValidNameFolder:(NSString*)folderName password:(NSString*)password rePassowrd:(NSString*)rePassowrd {
    NSString *message = nil;
    if ([self trimWhiteSpace:password].length || [self trimWhiteSpace:rePassowrd].length) {
        if (![password isEqualToString:rePassowrd]) {
            message = @"Password fail";
        }
    }
    if (![self trimWhiteSpace:folderName].length) {
        message = @"Enter Your Folder Name";
    }
    return message;
}

- (NSString *)trimWhiteSpace:(NSString*)string {
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return trimmedString;
}

- (void)saveFolder:(FLFolderModel*)folderModel success:(void(^)(void))success {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Folder *entity = [Folder entityWithUuid:folderModel.uuid inContext:localContext];
        entity.name = folderModel.name;
        entity.password = folderModel.password;
        entity.createDate = folderModel.createDate;
    }];
    if (success) {
        success();
    }
}
@end
