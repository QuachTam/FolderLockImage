//
//  SettingModel.m
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "SettingModel.h"
#import "AccountModel.h"
#import "FLAccountSetting.h"

@implementation SettingModel

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSArray *)section_account {
    if (!_accountModel) {
        _accountModel = [[AccountModel alloc] initWithUser:[FLAccountSetting findUser]];
    }
    return @[_accountModel];
}

- (NSArray *)section_passcode {
    return @[_LSFromTable(@"setting.passcode", @"FLSettingViewController", @"Passcode")];
}

- (NSArray *)section_about {
    return @[_LSFromTable(@"settting.about", @"FLSettingViewController", @"About")];
}

- (NSArray *)section_legal {
    return @[_LSFromTable(@"setting.legal", @"FLSettingViewController", @"Legal Software")];
}

- (NSString *)title {
    if (!_title) {
        _title = _LSFromTable(@"setting.title", @"FLSettingViewController", @"Settings");
    }
    return _title;
}

- (NSInteger)numberSection {
    return SETTING_SECTION_LEGAL+1;
}


@end
