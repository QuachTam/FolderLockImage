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
        _title = _LSFromTable(@"account.title", @"FLAccountViewController", @"Account");
    }
    return _title;
}

- (NSString *)titleName {
    if (!_titleName) {
        _titleName = _LSFromTable(@"account.fullName", @"FLAccountViewController", @"Your full name");
    }
    return _titleName;
}

- (NSString *)titlePassword {
    if (!_titlePassword) {
        _titlePassword = _LSFromTable(@"account.enter.your.password", @"FLAccountViewController", @"Enter your Password");
    }
    return _titlePassword;
}

- (NSString *)titleRepassword {
    if (!_titleRepassword) {
        _titleRepassword = _LSFromTable(@"account.re.enter.your.password", @"FLAccountViewController", @"Re-enter your password");
    }
    return _titleRepassword;
}

- (NSString *)titleEmail {
    if (!_titleEmail) {
        _titleEmail = _LSFromTable (@"account.email", @"FLAccountViewController", @"Your email");
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
