//
//  FLTableViewCellPasscode.h
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FLTableViewCellPasscode : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UISwitch *isPasscode;
@property (nonatomic, copy, readwrite) void(^didChangeValue)(NSInteger index);

- (IBAction)didChangeValue:(id)sender;
- (void)setOnSwitch:(BOOL)isOn;
@end
