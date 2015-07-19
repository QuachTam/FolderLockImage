//
//  AccountModel.m
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountModel

- (instancetype)initWithUser:(User*)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (NSString *)password {
    if (!_password) {
        _password = self.user.password ? self.user.password : @"";
    }
    return _password;
}

- (NSString *)rePassword {
    if (!_rePassword) {
        _rePassword = self.password;
    }
    return _rePassword;
}

- (NSString *)name {
    if (!_name) {
        _name = self.user.name ? self.user.name : @"";
    }
    return _name;
}

- (NSString *)email {
    if (!_email) {
        _email = self.user.email ? self.user.email : @"";
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
    if (self.type==ACCOUNT_SETUP) {
        return ACCOUNT_ROW_CONFIRM_PASSWORD + 1;
    }else{
        return ACCOUNT_ROW_EMAIL +1;
    }
}

@end
