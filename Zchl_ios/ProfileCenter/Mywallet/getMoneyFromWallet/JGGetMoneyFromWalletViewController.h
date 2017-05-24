//
//  JGGetMoneyFromWalletViewController.h
//  NDP_eHome
//
//  Created by 钟亮 on 16/3/18.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGBaseViewController.h"
@interface JGGetMoneyFromWalletViewController : JGBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *zhifubaoCount;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *money;

@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)comfirmBtnClick:(id)sender;
@end
