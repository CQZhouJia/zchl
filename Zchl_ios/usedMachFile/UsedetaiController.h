//
//  UsedetaiController.h
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsedetaiController : JGBaseViewController

@property (nonatomic,strong)NSString * proId;

@property (weak, nonatomic) IBOutlet UIView *topview;


@property (weak, nonatomic) IBOutlet UIButton *backbutton;


@property (weak, nonatomic) IBOutlet UILabel *titlelabel;

@property (weak, nonatomic) IBOutlet UITableView *usertableView;



@end
