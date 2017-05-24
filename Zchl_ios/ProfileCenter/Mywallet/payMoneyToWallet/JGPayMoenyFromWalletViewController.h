//
//  JGPayMoenyFromWalletViewController.h
//  NDP_eHome
//
//  Created by 钟亮 on 16/3/18.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGBaseViewController.h"
@interface JGPayMoenyFromWalletViewController :JGBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UIButton *nextStep;
- (IBAction)nextStepBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
@end
