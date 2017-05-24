//
//  JGUserImageTableViewCell.m
//  NDP_eHome
//
//  Created by 冠美 on 16/2/1.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGUserImageTableViewCell.h"

@implementation JGUserImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.userHeaderImage.layer.cornerRadius = 30;
    self.userHeaderImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
