//
//  LSFindBackPasswordViewController.m
//  LSOnline
//
//  Created by jglx on 17/4/12.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "LSFindBackPasswordViewController.h"
#import "JGRegisterBaseModel.h"
#import "JGRegisterModel.h"
#import "JGCodeDataModel.h"
#import "JGCodeDataBaseModel.h"
#import "JGCodeDataModel.h"

@interface LSFindBackPasswordViewController ()

@property (assign,nonatomic) int seconds;
@property (strong,nonatomic) NSTimer *myTiemr;
@property (strong,nonatomic)NSDictionary *callBackDict;

@end

@implementation LSFindBackPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
     gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:215/255.0 green:252/255.0 blue:250/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:248/255.0 green:195/255.0 blue:141/255.0 alpha:1.0].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT);
    [self.view.layer addSublayer:gradientLayer];
    
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainView];
    
    self.topView.backgroundColor = [UIColor clearColor];
    self.mainView.backgroundColor = [UIColor clearColor];
    
    
    self.sendCodeBtn.layer.cornerRadius = 5;
    self.sendCodeBtn.layer.masksToBounds = YES;
    
    self.nextClick.layer.cornerRadius = 5;
    self.nextClick.layer.masksToBounds = YES;
    
    self.seconds = 60;
    self.userPsdTextField.secureTextEntry = YES;
    self.userPsdReqTextField.secureTextEntry = YES;
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
}

- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendCodeClick:(UIButton *)sender {
    if (self.phoneTextField.text.length == 11)
    {
        if (self.myTiemr == nil) {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
            self.myTiemr = timer;
        }
        //    NSString *param = [NSString stringWithFormat:@"{\"platform\":\"%@\",\"phone\":\"%@\"}",@"2",self.phoneTextField.text];
        NSDictionary *param = @{@"platform":@"2",@"phone":self.phoneTextField.text};
        [ZTHttpTool postWithUrl:@"User/ResetPwdSendSMS" param:param success:^(id responseObj) {
            self.callBackDict = responseObj[@"Data"];
            
            JGCodeDataBaseModel *responseData = [JGCodeDataBaseModel mj_objectWithKeyValues:responseObj];
            if (!responseData.State) {
                
                JGCodeDataModel *codeData = [JGCodeDataModel mj_objectWithKeyValues:responseObj[@"Data"]];
                
                NSLog(@"%@",responseData.Data);
            }else{
                [self showTextHUD:responseData.Msg];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        [self showTextHUD:@"请输入正确的手机号"];
    }

    
}

-(void)timerFireMethod:(NSTimer *)theTimer {
    if (self.seconds == 1) {
        
        [theTimer setFireDate:[NSDate distantFuture]];
        self.seconds = 60;
        self.myTiemr = nil;
        [self.sendCodeBtn setTitle:@"重新获取" forState: UIControlStateNormal];
        [self.sendCodeBtn setEnabled:YES];
    }else{
        self.seconds--;
        [self.sendCodeBtn setEnabled:NO];
        [self.sendCodeBtn setTitle:[NSString stringWithFormat:@"%d秒",self.seconds] forState:UIControlStateNormal];
    }
}


- (IBAction)nextBtnClick:(UIButton *)sender {
    
    if ([self.codeTextField.text isEqualToString:@""]) {
        [self showTextHUD:@"填写验证码"];
        return;
    }
    if (self.callBackDict == nil) {
        [self showTextHUD:@"请获取验证码"];
        return;
    }
    if (![self.userPsdTextField.text isEqual:self.userPsdReqTextField.text]) {
        [self showHint:@"密码两次输入不一致"];
        return;
    }
    NSString *codeEnCrypt = [JGEncrypt encryptWithContent:self.codeTextField.text type:kCCEncrypt key:TextKey];
    NSString *pwdEncrypt = [JGEncrypt encryptWithContent:self.userPsdTextField.text type:kCCEncrypt key:TextKey];
    StorageUserInfromation *Storage = [StorageUserInfromation storageUserInformation];
    if (!Storage.dingweiCity) {
        Storage.dingweiCity = @"重庆";
        Storage.coordX = @"0";
        Storage.coordY = @"0";
        
    }
    NSDictionary *dict = @{@"code":codeEnCrypt,@"newPassword":pwdEncrypt,@"callback":[[StorageUserInfromation storageUserInformation] jsonStringWithDictionary: self.callBackDict ]};
    
    
    [ZTHttpTool postWithUrl:@"User/ResetPwd" param:dict success:^(id responseObj) {
        if ([responseObj[@"State"] integerValue]==0) {
            
            
            // 将用户信息存储在本地
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextField.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:self.userPsdTextField.text forKey:@"passWord"];
            NSDictionary *dic = @{@"tele":self.phoneTextField.text,@"pass":self.userPsdTextField.text};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registerCenter" object:self userInfo:dic];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showTextHUD:responseObj[@"Msg"]];
        }
    } failure:^(NSError *error) {
        
    }];

}



@end
