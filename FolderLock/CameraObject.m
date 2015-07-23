//
//  CameraObject.m
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import "CameraObject.h"

@interface CameraObject () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation CameraObject

+ (instancetype)shareInstance
{
    static dispatch_once_t predicate;
    static CameraObject *instance = nil;
    dispatch_once(&predicate, ^{
        instance = [[CameraObject alloc] init];
    });
    return instance;
}

- (void)showCamera{
    if ([UIImagePickerController isSourceTypeAvailable:self.sourceType]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = self.sourceType;
        if (self.supperView) {
            [self.supperView presentViewController:picker animated:YES completion:^ {
            }];
        }
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if ([self.delegate respondsToSelector:@selector(didFinishPickingMediaWithInfo:)]) {
        [self.delegate didFinishPickingMediaWithInfo:chosenImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    if ([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel)]) {
        [self.delegate imagePickerControllerDidCancel];
    }
}
@end
