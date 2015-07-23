//
//  FLButtonHelper.m
//  FolderLock
//
//  Created by QSOFT on 7/13/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLButtonHelper.h"
#import "FLImageHelper.h"

UIButton * fl_buttonSetting() {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
    [button setBackgroundImage:[UIImage imageNamed:kImageSetting] forState:UIControlStateNormal];
    return button;
}


UIButton * fl_buttonCancel() {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
    [button setBackgroundImage:[UIImage imageNamed:kImageCancel] forState:UIControlStateNormal];
    return button;
}

UIButton * fl_buttonSave() {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
    [button setBackgroundImage:[UIImage imageNamed:kImageSave] forState:UIControlStateNormal];
    return button;
}

UIButton *fl_buttonCamera() {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
    [button setBackgroundImage:[UIImage imageNamed:kImageCamera] forState:UIControlStateNormal];
    return button;
}

UIButton *fl_buttonAdd() {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
    [button setBackgroundImage:[UIImage imageNamed:kImageAdd] forState:UIControlStateNormal];
    return button;
}

UIButton *fl_buttonEdit() {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
    [button setBackgroundImage:[UIImage imageNamed:kImageEdit] forState:UIControlStateNormal];
    return button;
}

UIButton *fl_buttonDelete() {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.f, 0.f, 30.f, 30.f);
    [button setBackgroundImage:[UIImage imageNamed:kImageDelete] forState:UIControlStateNormal];
    return button;
}