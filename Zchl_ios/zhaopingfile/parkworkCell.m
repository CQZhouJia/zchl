//
//  parkworkCell.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "parkworkCell.h"

@implementation parkworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.weeklabel sizeToFit];
    self.weeklabel.backgroundColor = [UIColor orangeColor];
    self.weeklabel.font = [UIFont systemFontOfSize:12];
    self.weeklabel.textColor = [UIColor whiteColor];
    
    self.moneylabel.textColor = [UIColor orangeColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
