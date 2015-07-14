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

@end
