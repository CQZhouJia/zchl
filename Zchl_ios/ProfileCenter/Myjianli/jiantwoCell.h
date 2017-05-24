//
//  jiantwoCell.h
//  Zchl_ios
//
//  Created by jglx on 17/5/3.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jiantwoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *leftlabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftlabelwidth;

@property (weak, nonatomic) IBOutlet UITextField *righttextfield;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textwidth;


@property (weak, nonatomic) IBOutlet UILabel *rightlabel;

@end
