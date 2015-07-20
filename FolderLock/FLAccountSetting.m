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
            message = _LSFromTable(@"account.re.enter.your.password", @"FLAccountViewController", @"Re-enter your password");
        }
        if (!accountModel.password.length) {
            message = _LSFromTable(@"account.enter.your.password", @"FLAccountViewController", @"Enter your password");
        }
        if (accountModel.password.length && accountModel.rePassword.length) {
            if (![accountModel.password isEqualToString:accountModel.rePassword]) {
                message = _LSFromTable(@"account.password.did.not.match", @"FLAccountViewController", @"Password did not match, Try again.");
            }
        }
        
        if (accountModel.email.length && ![accountModel.email isValidEmail]) {
            message = _LSFromTable(@"account.enter.your.email.isValid", @"FLAccountViewController", @"Email did not match");
        }
        if (!accountModel.email.length) {
            message = _LSFromTable(@"account.enter.your.email", @"FLAccountViewController", @"Enter your email");
        }
        if (!accountModel.name.length) {
            message = _LSFromTable(@"account.enter.your.name", @"FLAccountViewController", @"Enter your name");
        }
    }else{
        if (accountModel.email.length && ![accountModel.email isValidEmail]) {
            message = _LSFromTable(@"account.enter.your.email.isValid", @"FLAccountViewController", @"Email did not match");
        }
        if (!accountModel.email.length) {
            message = _LSFromTable(@"account.enter.your.email", @"FLAccountViewController", @"Enter your email");
        }
        if (!accountModel.name.length) {
            message = _LSFromTable(@"account.enter.your.name", @"FLAccountViewController", @"Enter your name");
        }
    }
    if (success) {
        success (message);
    }
}
@end
