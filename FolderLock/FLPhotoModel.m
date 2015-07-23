//
//  FLPhotoModel.m
//  FolderLock
//
//  Created by ATam on 7/22/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLPhotoModel.h"

@implementation FLPhotoModel

- (instancetype)initWithPhotoEntity:(Photo*)entity {
    self = [super init];
    if (self) {
        self.entity = entity;
    }
    return self;
}

- (NSString *)name {
    if (!_name) {
        _name = self.entity.name ? self.entity.name : @"";
    }
    return _name;
}

- (NSString *)url {
    if (!_url) {
        _url = self.entity.url ? self.entity.url : @"";
    }
    return _url;
}

@end
