//
//  FLAccountSetting.m
//  FolderLock
//
//  Created by ATam on 7/19/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLAccountSetting.h"
#import <MagicalRecord/MagicalRecord.h>
#import "User.h"

@implementation FLAccountSetting
- (void)saveAccountInfo:(AccountModel*)accountModel success:(void(^)(void))success fail:(void(^)(void))fail {
    [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        User *user = [User MR_findFirstInContext:localContext];
        if (!user) {
            user = [User MR_createEntityInContext:localContext];
        }
        user.name = accountModel.name;
        user.email = accountModel.email;
        user.password = accountModel.password;
    }];
    if (success) {
        success();
    }
}

+ (User *)findUser {
    User *user = [User MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    return user;
}

- (BOOL)checkUserInfo {
    User *user = [User MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    if (user && user.email.length) {
        return YES;
    }
    return NO;
}

- (void)validWithModel:(AccountModel *)accountModel success:(void(^)(NSString *message))success {
    NSString *message = nil;
    if (accountModel.type==ACCOUNT_SETUP) {
        if (!accountModel.rePassword.length) {
            message = @"Enter your confirm password";
        }
        if (!accountModel.password.length) {
            message = @"Enter your password";
        }
        if (accountModel.password.length && accountModel.rePassword.length) {
            if (![accountModel.password isEqualToString:accountModel.rePassword]) {
                message = @"Password not match";
            }
        }
        if (!accountModel.email.length) {
            message = @"Enter your email";
        }
        if (!accountModel.name.length) {
            message = @"Enter your name";
        }
    }else{
        if (!accountModel.email.length) {
            message = @"Enter your email";
        }
        if (!accountModel.name.length) {
            message = @"Enter your name";
        }
    }
    if (success) {
        success (message);
    }
}
@end
