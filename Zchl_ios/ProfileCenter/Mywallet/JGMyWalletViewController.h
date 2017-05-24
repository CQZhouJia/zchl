//
//  JGMyWalletViewController.h
//  NDP_eHome
//
//  Created by 冠美 on 16/2/3.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGMyWalletViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *walletImageConstraint;
@property (weak, nonatomic) IBOutlet UIButton *getOutMoneyFromWalletBtn;

@property (weak, nonatomic) IBOutlet UIButton *PayToWalletBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)recordListBtnClick:(id)sender;
- (IBAction)payToWalletBtnClick:(id)sender;
- (IBAction)getOutMoneyFromWalletBtnClick:(id)sender;
@end
