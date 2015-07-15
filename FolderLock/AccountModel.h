//
//  AccountModel.h
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ACCOUNT_ROW) {
    ACCOUNT_ROW_NAME = 0,
    ACCOUNT_ROW_EMAIL = 1,
    ACCOUNT_ROW_PASSWORD = 2,
    ACCOUNT_ROW_CONFIRM_PASSWORD = 3
};

@interface AccountModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *titleName;
@property (nonatomic, strong) NSString *titleEmail;
@property (nonatomic, strong) NSString *titlePassword;
@property (nonatomic, strong) NSString *titleRepassword;
@property (nonatomic, readwrite) NSInteger numberRow;
@end
