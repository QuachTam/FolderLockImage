//
//  FLAccountSetting.h
//  FolderLock
//
//  Created by ATam on 7/19/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccountModel.h"

@interface FLAccountSetting : NSObject
- (void)saveAccountInfo:(AccountModel*)accountModel success:(void(^)(void))success fail:(void(^)(void))fail;
- (BOOL)checkUserInfo;
+ (User*)findUser;
- (void)validWithModel:(AccountModel *)accountModel success:(void(^)(NSString *message))success;
@end
