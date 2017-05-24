//
//  detaiMessageCell.m
//  Zchl_ios
//
//  Created by jglx on 17/4/27.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "detaiMessageCell.h"

@implementation detaiMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.logoImage.layer.co
    self.phonelale.textColor = Color_RGBA(59, 64, 111, 1.0);
    self.timelabel.textColor = Color_RGBA(221, 221, 221, 1.0);
    self.jiqilabel.layer.borderWidth = 1;
//    self.jiqilabel.layer.backgroundColor = Color_RGBA(151, 214, 254, 1.0).CGColor;
    self.jiqilabel.layer.borderColor = Color_RGBA(151, 214, 254, 1.0).CGColor;
    self.jiqilabel.textColor = Color_RGBA(86, 92, 129, 1.0);
    self.localLabel.textColor = Color_RGBA(86, 92, 129, 1.0);
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
