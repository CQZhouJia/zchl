//
//  JGGetMoneyFromWalletViewController.m
//  NDP_eHome
//
//  Created by 钟亮 on 16/3/18.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGGetMoneyFromWalletViewController.h"
#import "JGEncrypt.h"
#import "JGPayPassWordView.h"
#import "JGSendCodeController.h"
#import "JGPayFailedView.h"
#import "JGPaySuccessView.h"
#import "EMAlertView.h"
@interface JGGetMoneyFromWalletViewController ()
{
    BOOL isHaveDian;
    BOOL isZero;
    
    
}

@property (strong,nonatomic)JGPayPassWordView *payView;
@property (strong,nonatomic) JGPayFailedView *failedView;
@property (strong,nonatomic)JGPaySuccessView *successView;
@end

@implementation JGGetMoneyFromWalletViewController
-(void)forcePortrait{
    //强制竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self forcePortrait];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.comfirmBtn.layer.cornerRadius = 3;
    self.comfirmBtn.layer.masksToBounds = YES;
    self.money.keyboardType = UIKeyboardTypeDecimalPad;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)comfirmBtnClick:(id)sender {
    [self.zhifubaoCount resignFirstResponder];
    [self.userName resignFirstResponder];
    [self.money resignFirstResponder];

    if ([JGIsBlankString isBlankString:self.zhifubaoCount.text]) {
        [self showHint:@"请输入支付宝账号"];
        return;
    }
    
    if ([JGIsBlankString isBlankString:self.userName.text]) {
        [self showHint:@"请输入真实姓名"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.money.text]) {
        [self showHint:@"请输入金额"];
        return;
    }
    
    [self showHUD];
    [ZTHttpTool postWithUrl:@"UserCenter/ExistPayPwd" param:nil success:^(id responseObj) {
        
        if ([responseObj[@"State"] integerValue]==0) {  //已设置
            JGPayPassWordView *payWordView = [[[NSBundle mainBundle] loadNibNamed:@"JGPayPassWordView" owner:self options:nil] lastObject];
            payWordView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.payView = payWordView;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [UIView animateWithDuration:0.5 animations:^{
                    payWordView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            } completion:^(BOOL finished) {
                
            }];
            //支付的金额
            payWordView.moneyLabel.text = self.money.text;
            
            payWordView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            payWordView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            //取消支付
            [payWordView.cancelBtn addTarget:self action:@selector(removePayView) forControlEvents:UIControlEventTouchUpInside];
            //填好密码后确认支付
            [payWordView.payAllMoneyBtn addTarget:self action:@selector(sendRed) forControlEvents:UIControlEventTouchUpInside];
            //忘记密码：
            [payWordView.forgetPwd addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
            
            //获取的用户密码：payWordView.actStr   需要加密
            
            [[UIApplication sharedApplication].keyWindow addSubview:payWordView];
            [self hideHud];
        }else if ([responseObj[@"State"] integerValue]==1){ //未设置
            [EMAlertView showAlertWithTitle:@"温馨提示" message:@"你未设置支付密码" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                if (buttonIndex) {
                    JGSendCodeController *sendCode = [[JGSendCodeController alloc] init];
                    [self.navigationController pushViewController:sendCode animated:YES];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"去设置",nil];
            [self hideHud];
        }else{  //异常
            [self hideHud];
            [self showHint:@"数据异常"];
        }
        
    } failure:^(NSError *error) {
        [self showHint:@"数据异常"];
        [self hideHud];
    }];
}

- (void)forgetPwd{
    //跳转到更改密码
    [self.payView removeFromSuperview];
    JGSendCodeController *sendCode = [[JGSendCodeController alloc] init];
    [self.navigationController pushViewController:sendCode animated:YES];
}
- (void)removePayView{
    [self.payView removeFromSuperview];
}
- (void)sendRed{
    [self.payView removeFromSuperview];
    self.payView.actStr = (NSMutableString *)[JGEncrypt encryptWithContent:self.payView.actStr type:kCCEncrypt key:TextKey];
    
    NSString *moneyEncode = [JGEncrypt encryptWithContent:self.money.text type:kCCEncrypt key:TextKey];
    
    NSDictionary * dict = @{@"account":self.zhifubaoCount.text,@"tureName":self.userName.text,@"money":moneyEncode,@"flag":@"0",@"payPwd":self.payView.actStr};
    [self showHUDWithMessage:@"正在发送..."];
    [ZTHttpTool postWithUrl:@"UserCenter/ApplyCash" param:dict success:^(id responseObj) {
        if ([responseObj[@"State"] integerValue] ==0) {
            [self.payView removeFromSuperview];
            JGPaySuccessView *successView = [[[NSBundle mainBundle] loadNibNamed:@"JGPaySuccessView" owner:self options:nil] lastObject];
            successView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            successView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            successView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            
            successView.successLB.text = @"申请提现成功";
            
            self.successView = successView;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [UIView animateWithDuration:0.5 animations:^{
                    successView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            } completion:^(BOOL finished) {
                
            }];
            
            
            [successView.confirmButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
            
            [[UIApplication sharedApplication].keyWindow addSubview:successView];
            self.view.alpha = 0.5;

            
        }else if ([responseObj[@"State"] intValue] == 2){
            
            //跳转到设置密码界面
            
            JGSendCodeController *sendCode = [[JGSendCodeController alloc] init];
            [self.navigationController pushViewController:sendCode animated:YES];
            
            [self.payView removeFromSuperview];
        }else{
//            [self showTextHUD:responseObj[@"Msg"]];
            JGPayFailedView *failedView = [[[NSBundle mainBundle] loadNibNamed:@"JGPayFailedView" owner:self options:nil] lastObject];
            failedView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
            failedView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            failedView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            
            failedView.MSGLabel.text= @"申请提现失败";
            
            self.failedView = failedView;
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [UIView animateWithDuration:0.5 animations:^{
                    failedView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            } completion:^(BOOL finished) {
                
            }];
            failedView.MSGLabel.text = responseObj[@"Msg"];
            [failedView.confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [[UIApplication sharedApplication].keyWindow addSubview:failedView];
            self.view.alpha = 0.5;
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self hideHud];
    }];

}

-(void)finish{
    [self.successView removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
    self.view.alpha = 1;
}

-(void)confirmButtonClicked{
    [self.failedView removeFromSuperview];
    self.view.alpha = 1;
}

//带小数点的金额数字键盘输入判定
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                if (single == '0') {
                    isZero = YES;
                }else{
                    isZero = NO;
                }
            }
            if ([textField.text length] == 1) {//首字母为零时第二个必须是小数点
                if (single != '.') {
                    if (isZero) {
                        [textField.text stringByReplacingCharactersInRange:range withString:@""];
                        return NO;
                    }
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
@end
