//
//  JGSafeSetUpViewController.h
//  NDP_eHome
//
//  Created by 冠美 on 16/2/2.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGSafeSetUpViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;
@property (weak, nonatomic) IBOutlet UITextField *nowPassWord;
@property (weak, nonatomic) IBOutlet UITextField *comfirmNowPassWord;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
- (IBAction)comfirmBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

@end
