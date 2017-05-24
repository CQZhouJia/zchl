//
//  LSReguseViewController.m
//  LSOnline
//
//  Created by jglx on 17/4/12.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "LSReguseViewController.h"
#import "JGCodeDataBaseModel.h"
#import "JGCodeDataModel.h"
#import "JGRegisterBaseModel.h"
#import "JGRegisterModel.h"
#import "AppDelegate.h"
#import "completeView.h"

@interface LSReguseViewController ()<completeDelegate>

@property (assign,nonatomic) int seconds;
@property (strong,nonatomic) NSTimer *myTiemr;

@property (strong,nonatomic)NSDictionary * callBackDict;

@property (strong,nonatomic)completeView * completeView;

@end

@implementation LSReguseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:215/255.0 green:252/255.0 blue:250/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:248/255.0 green:195/255.0 blue:141/255.0 alpha:1.0].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT);
    [self.view.layer addSublayer:gradientLayer];
   
    [self.view addSubview:self.topview];
    [self.view addSubview:self.mainView];
    
    self.toptitileLabel.text = @"注册";
    
    self.getphonebutton.layer.cornerRadius = 5;
    self.getphonebutton.layer.masksToBounds = YES;
    
    self.newcompletebutton.layer.cornerRadius = 5;
    self.newcompletebutton.layer.masksToBounds = YES;
    [self.newcompletebutton setTitle:@"注册完成" forState:UIControlStateNormal];
    
    
    self.seconds = 60;
    self.passwordtextfield.secureTextEntry = YES;
    self.anthorpasstextfield.secureTextEntry = YES;
    self.phoneTextfield.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneCodetTextfield.keyboardType = UIKeyboardTypeNumberPad;
}

- (IBAction)senderCodeClick:(UIButton *)sender {
    [self.phoneNIckName resignFirstResponder];
    [self.phoneTextfield resignFirstResponder];
    if (self.phoneTextfield.text.length == 11) {
        NSDictionary * param = @{@"platform":@"2",@"phone":self.phoneTextfield.text};
        [ZTHttpTool postWithUrl:@"User/SendSMS" param:param success:^(id responseObj) {
            //
            NSLog(@"%@",responseObj[@"Data"]);
            self.callBackDict = responseObj[@"Data"];
            JGCodeDataBaseModel *responseData = [JGCodeDataBaseModel mj_objectWithKeyValues:responseObj];
            if (!responseData.State) {
//              JGCodeDataModel *codeData = [JGCodeDataModel mj_objectWithKeyValues:responseObj[@"Data"]];
                [self hideHud];
                [self showHint:@"发送成功"];
                NSLog(@"%@",responseData.Data);
                if (self.myTiemr == nil) {
                    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                    self.myTiemr = timer;
                }
            }else{
                [self showTextHUD:responseData.Msg];
                [self hideHud];
            }
            
        } failure:^(NSError *error) {
            //
            [self showTextHUD:@"服务器连接失败"];
            [self hideHud];
        }];
    }else{
         [self showTextHUD:@"请输入正确的手机号"];
    }
}

-(void)timerFireMethod:(NSTimer *)theTimer {
    if (self.seconds == 1) {
        [theTimer setFireDate:[NSDate distantFuture]];
        self.seconds = 60;
        self.myTiemr = nil;
        [self.getphonebutton setTitle:@"重新获取" forState: UIControlStateNormal];
        [self.getphonebutton setEnabled:YES];
    }else{
        self.seconds--;
        [self.getphonebutton setEnabled:NO];
        [self.getphonebutton setTitle:[NSString stringWithFormat:@"%d秒",self.seconds] forState:UIControlStateNormal];
    }
}


- (IBAction)newUserButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    
    if ([self.phoneCodetTextfield.text isEqualToString:@""]) {
        [self showTextHUD:@"填写验证码"];
        return;
    }
    if (self.callBackDict == nil) {
        [self showTextHUD:@"请获取验证码"];
        return;
    }
    if (![self.passwordtextfield.text isEqualToString:self.anthorpasstextfield.text]) {
        [self showHint:@"密码两次输入不一致"];
        return;
    }
    if ([JGIsBlankString isBlankString:self.phoneNIckName.text]) {
        [self showHint:@"昵称不能为空"];
        return;
    }
    if (self.passwordtextfield.text.length > 20) {
        [self showHint:@"请设置密码长度在20个字以内"];
        return;
    }
    if (self.phoneNIckName.text.length > 20) {
        [self showHint:@"请设置昵称长度在20个字以内"];
        return;
    }
    
    _completeView = [[completeView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _completeView.delegate = self;
    [self.view addSubview:_completeView];
}

-(void)comepleteClickPass:(NSString *)flag{
    [self reguestUserflag:flag];
}


-(void)reguestUserflag:(NSString *)flag{
    //加密处理
    NSString *codeEnCrypt = [JGEncrypt encryptWithContent:self.phoneCodetTextfield.text type:kCCEncrypt key:TextKey];
    NSString *pwdEncrypt = [JGEncrypt encryptWithContent:self.passwordtextfield.text type:kCCEncrypt key:TextKey];
    
    NSLog(@"%@",codeEnCrypt);
    
    StorageUserInfromation *Storage = [StorageUserInfromation storageUserInformation];
    if (!Storage.dingweiCity) {
        Storage.dingweiCity = @"重庆";
        Storage.coordX = @"0";
        Storage.coordY = @"0";
    }
    NSDictionary *dict = @{@"platform":@"2",@"nickname":self.phoneNIckName.text,@"code":codeEnCrypt,@"phone":self.phoneTextfield.text,@"pwd":pwdEncrypt,@"areaName":Storage.dingweiCity,@"coordX":Storage.coordX,@"coordY":Storage.coordY,@"role":flag,@"callback":[[StorageUserInfromation storageUserInformation] jsonStringWithDictionary: self.callBackDict ]};
    NSLog(@"%@",dict);
    
    [self showHUDWithMessage:@"正在加载中..."];
    [ZTHttpTool postWithUrl:@"User/Reg" param:dict success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        NSLog(@"%@",responseObj[@"Msg"]);
        JGRegisterBaseModel * param = [JGRegisterBaseModel mj_objectWithKeyValues:responseObj];
        if (!param.State) {
            Storage.token = param.Data.token;
            Storage.userID = param.Data.uid;
            Storage.pwd = codeEnCrypt;
            Storage.loginPhone = param.Data.phone;
            Storage.areaCode = param.Data.areaCode;
            Storage.Huanxin = param.Data.huanxin;
            Storage.nickName = param.Data.auditingState;
            Storage.auditingState = param.Data.auditingState;
            Storage.gender = param.Data.sex;
            Storage.age = param.Data.age;
            Storage.userHeadImage = param.Data.logo;
            Storage.birthday = param.Data.birthday;
            Storage.buildingChatId = param.Data.buildingChatId;
            
            //将用户信息存储到本地
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextfield.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordtextfield.text forKey:@"passWord"];
            NSDictionary *dic = @{@"tele":self.phoneTextfield.text,@"pass":self.passwordtextfield.text};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registerCenter" object:self userInfo:dic];
            
            [self hideHud];
            //            [self logon];
            [self newUserButton:nil];
        }else{
            [self showTextHUD:param.Msg];
        }
    } failure:^(NSError *error) {
        //
        [self hideHud];
    }];

}

-(void)logon{
    //    [self saveDefaultData];
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    delegate.window.rootViewController = mainStoryboard.instantiateInitialViewController;
//    if ([delegate.window.rootViewController.childViewControllers count] > 1) {
//        [StorageUserInfromation storageUserInformation].needGetUnreadMessage = @"NO";
//        UINavigationController *child = [delegate.window.rootViewController.childViewControllers objectAtIndex:1];
//        //    if (application.applicationIconBadgeNumber!=0 &&[[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"]) {
//        JGMessageController *childChild = [child.viewControllers objectAtIndex:0];
//        [childChild getUnReadMessages];
//        //    }
//    }
    
    UIStoryboard * mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = mainStoryboard.instantiateInitialViewController;
}

@end
