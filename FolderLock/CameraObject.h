//
//  CameraObject.h
//  easyCamera
//
//  Created by ATam on 6/12/15.
//  Copyright (c) 2015 ATam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TYPE_SAVE_IMAGE) {
    MUTILPE_IMAGE = 0,
    ONCE_IMAGE
};

@protocol CameraObjectDelegate <NSObject>
@required
- (void)didFinishPickingMediaWithInfo:(UIImage *)image;
- (void)imagePickerControllerDidCancel;
@end

@interface CameraObject : NSObject
@property (nonatomic, strong) id supperView;
@property (nonatomic, strong) id<CameraObjectDelegate>delegate;
@property (nonatomic, readwrite) TYPE_SAVE_IMAGE typeSaveImage;
@property (nonatomic, readwrite) UIImagePickerControllerSourceType sourceType;
+ (instancetype)shareInstance;
- (void)showCamera;
@end
