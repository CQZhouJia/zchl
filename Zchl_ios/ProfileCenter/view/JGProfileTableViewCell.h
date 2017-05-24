//
//  JGProfileTableViewCell.h
//  NDP_eHome
//
//  Created by 钟亮 on 16/1/25.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CellImageWidth;
@property (weak, nonatomic) IBOutlet UIView *lineView;


@property (weak, nonatomic) IBOutlet UILabel *secondLB;

@end
