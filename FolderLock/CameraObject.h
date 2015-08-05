//
//  CameraObject.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol CameraObjectDelegate <NSObject>
@required
- (void)didFinishPickingMediaWithInfo:(UIImage *)image;
- (void)imagePickerControllerDidCancel;
@end

@interface CameraObject : NSObject
@property (nonatomic, strong) id supperView;
@property (nonatomic, strong) id<CameraObjectDelegate>delegate;
@property (nonatomic, readwrite) UIImagePickerControllerSourceType sourceType;
+ (instancetype)shareInstance;
- (void)showCamera;
@end
