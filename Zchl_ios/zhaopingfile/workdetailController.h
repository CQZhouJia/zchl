//
//  workdetailController.h
//  Zchl_ios
//
//  Created by jglx on 17/5/3.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface workdetailController : JGBaseViewController

@property (nonatomic,strong)NSString * proId; // 招聘Id;


@property (weak, nonatomic) IBOutlet UIView *topview;



@property (weak, nonatomic) IBOutlet UIButton *boomright;


@property (weak, nonatomic) IBOutlet UIButton *boomleft;


@property (weak, nonatomic) IBOutlet UITableView *worktableView;



@end
