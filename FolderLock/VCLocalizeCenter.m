//
//  VCLocalizeCenter.m
//  Vaccinations
//
//  Created by Nguyen Le Duan on 11/18/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#import "VCLocalizeCenter.h"

@implementation VCLocalizeCenter

+ (instancetype)sharedInstance
{
    static VCLocalizeCenter * shared = Nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[VCLocalizeCenter alloc] init];
    });
    return shared;
}
- (NSString *)localizedStringForKey:(NSString *)key
{
    return NSLocalizedString(key, Nil);
}

@end
