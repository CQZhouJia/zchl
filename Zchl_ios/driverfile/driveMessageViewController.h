//
//  driveMessageViewController.h
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface driveMessageViewController : JGBaseViewController

@property (nonatomic,strong)NSString * uid;

@property (weak, nonatomic) IBOutlet UIView *topview;


@property (weak, nonatomic) IBOutlet UIButton *backbtn;


@property (weak, nonatomic) IBOutlet UILabel *titlelabel;


@property (weak, nonatomic) IBOutlet UITableView *drivetableView;


@property (weak, nonatomic) IBOutlet UIButton *phonebutton;

@end
