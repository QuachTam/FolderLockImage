//
//  VCLocalizeCenter.h
//  Vaccinations
//
//  Created by Nguyen Le Duan on 11/18/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VCLocalizedString(key) [[VCLocalizeCenter sharedInstance] localizedStringForKey:(key)]

@interface VCLocalizeCenter : NSObject

+ (instancetype)sharedInstance;
- (NSString *)localizedStringForKey:(NSString *)key;

@end
