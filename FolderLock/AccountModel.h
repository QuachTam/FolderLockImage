//
//  AccountModel.h
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "User.h"
#import "FLBaseModel.h"

typedef NS_ENUM(NSInteger, ACCOUNT_ROW) {
    ACCOUNT_ROW_NAME = 0,
    ACCOUNT_ROW_EMAIL = 1,
    ACCOUNT_ROW_PASSWORD = 2,
    ACCOUNT_ROW_CONFIRM_PASSWORD = 3
};

typedef NS_ENUM(NSInteger, TYPE) {
    ACCOUNT_SETUP = 0,
    ACCOUNT_CHANGE = 1,
};

@interface AccountModel : FLBaseModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *rePassword;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *titleEmail;
@property (nonatomic, strong) NSString *titlePassword;
@property (nonatomic, strong) NSString *titleRepassword;
@property (nonatomic, readwrite) NSInteger numberRow;

@property (nonatomic, readwrite) TYPE type;
@property (nonatomic, strong) User *user;

- (instancetype)initWithUser:(User*)user;
@end
