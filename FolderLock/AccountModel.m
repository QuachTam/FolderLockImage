//
//  AccountModel.m
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

- (NSString *)name {
    if (!_name) {
        _name = @"Quach Ngoc Tam";
    }
    return _name;
}

- (NSString *)email {
    if (!_email) {
        _email = @"tamqn@gemvietnam.com";
    }
    return _email;
}

- (NSString *)title {
    if (!_title) {
        _title = @"Account";
    }
    return _title;
}

- (NSString *)titleName {
    if (!_titleName) {
        _titleName = @"Full Name";
    }
    return _titleName;
}

- (NSString *)titlePassword {
    if (!_titlePassword) {
        _titlePassword = @"Password";
    }
    return _titlePassword;
}

- (NSString *)titleRepassword {
    if (!_titleRepassword) {
        _titleRepassword = @"Re-Password";
    }
    return _titleRepassword;
}

- (NSString *)titleEmail {
    if (!_titleEmail) {
        _titleEmail = @"Email";
    }
    return _titleEmail;
}

- (NSInteger)numberRow {
    return ACCOUNT_ROW_CONFIRM_PASSWORD + 1;
}

@end
