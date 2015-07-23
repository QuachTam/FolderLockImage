//
//  UIAlertView+VC.m
//  Vaccinations
//
//  Created by Nguyen Le Duan on 11/25/14.
//  Copyright (c) 2014 Gem Vietnam. All rights reserved.
//

#import "UIAlertView+VC.h"
#import <objc/runtime.h>

@implementation UIAlertView (VC)

- (id) vc_initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    /*For iOS 8+*/
    return [[[self class] alloc] initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
}

//Runtime association key.
static NSString *handlerRunTimeAccosiationKey = @"alertViewBlocksDelegate";

- (void)showAlerViewWithHandler:(UIActionAlertViewCallBackHandler)handler {
    
    //set runtime accosiation of object
    //param -  sourse object for association, association key, association value, policy of association
    objc_setAssociatedObject(self, (__bridge  const void *)(handlerRunTimeAccosiationKey), handler, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setDelegate:self];
    [self show];  //call UIAlertView show method
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIActionAlertViewCallBackHandler completionHandler = objc_getAssociatedObject(self, (__bridge  const void *)(handlerRunTimeAccosiationKey));
    
    if (completionHandler != nil) {
        
        completionHandler(alertView, buttonIndex);
    }
}

@end
