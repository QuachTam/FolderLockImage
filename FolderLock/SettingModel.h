//
//  SettingModel.h
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLBaseModel.h"

typedef NS_ENUM(NSInteger, SETTING_SECTION) {
    SETTING_SECTION_ACCOUNT = 0,
    SETTING_SECTION_PASSCODE = 1,
    SETTING_SECTION_ABOUT = 2,
    SETTING_SECTION_LEGAL
};
@class AccountModel;
@interface SettingModel : FLBaseModel

@property (nonatomic, readwrite) NSInteger numberSection;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) AccountModel *accountModel;

@property (nonatomic, strong) NSArray *section_account;
@property (nonatomic, strong) NSArray *section_passcode;
@property (nonatomic, strong) NSArray *section_about;
@property (nonatomic, strong) NSArray *section_legal;

@end
