//
//  UIAlertView+VC.h
//  Vaccinations
//
//  Created by Nguyen Le Duan on 11/25/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIActionAlertViewCallBackHandler)(UIAlertView *alertView, NSInteger buttonIndex);

@interface UIAlertView (VC)

- (id)vc_initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void)showAlerViewWithHandler:(UIActionAlertViewCallBackHandler)handler;
@end
