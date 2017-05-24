//
//  foueCell.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "foueCell.h"

@implementation foueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)buttonClick:(UIButton *)sender {
    [_delegate buttonphoneDelegate:sender];
}


@end
