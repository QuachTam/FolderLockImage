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

- (void)saveFolder:(NSString *)name password:(NSString*)passowrd success:(void(^)(void))success {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        Folder *entity = [Folder MR_createEntityInContext:localContext];
        entity.uuid = [[[NSUUID UUID] UUIDString] lowercaseString];
        entity.name = name;
        entity.password = passowrd;
        entity.createDate = [NSDate date];
    }];
    if (success) {
        success();
    }
}
@end
