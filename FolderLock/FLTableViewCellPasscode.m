//
//  FLTableViewCellPasscode.m
//  FolderLock
//
//  Created by QSOFT on 7/14/15.
//  Copyright (c) 2015 QSOFT. All rights reserved.
//

#import "FLTableViewCellPasscode.h"

@implementation FLTableViewCellPasscode

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOnSwitch:(BOOL)isOn {
    self.isPasscode.on = isOn;
}

- (IBAction)didChangeValue:(id)sender {
    if (self.didChangeValue) {
        self.didChangeValue([sender isOn]);
    }
}
@end
