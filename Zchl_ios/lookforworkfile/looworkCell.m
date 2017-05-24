//
//  looworkCell.m
//  Zchl_ios
//
//  Created by jglx on 17/4/28.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "looworkCell.h"

@implementation looworkCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.jiqilabel.layer.borderWidth = 1;
    self.jiqilabel.layer.cornerRadius = 1;
    self.jiqilabel.layer.borderColor = Color_RGBA(128, 231, 240, 1.0).CGColor;
    
    [self.checkbutton setTitleColor:Color_RGBA(133, 133, 133, 1.0) forState:UIControlStateNormal];
    self.checkbutton.layer.borderWidth = 1;
    self.checkbutton.layer.cornerRadius = 3;
    self.checkbutton.layer.borderColor = Color_RGBA(133, 133, 133, 1.0).CGColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)rightBnt:(UIButton *)sender {

    [_delegate rightbuttondelegate:sender];
}



@end
