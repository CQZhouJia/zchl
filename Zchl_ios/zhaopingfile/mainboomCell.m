//
//  mainboomCell.m
//  Zchl_ios
//
//  Created by jglx on 17/4/28.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "mainboomCell.h"

@implementation mainboomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = Color_RGBA(187, 187, 187, 1.0).CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
