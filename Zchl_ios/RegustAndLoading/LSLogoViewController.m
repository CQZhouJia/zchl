//
//  LSLogoViewController.m
//  LSOnline
//
//  Created by jglx on 17/4/12.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "LSLogoViewController.h"
#import "AppDelegate.h"
#import "HomeTextField.h"
#import "LSReguseViewController.h"
#import "LSFindBackPasswordViewController.h"
#import "JGLoginModel.h"
#import "JGLoginBaseModel.h"

@interface LSLogoViewController ()

@property (nonatomic,strong)HomeTextField * usernametextfield;

@property (nonatomic,strong)HomeTextField * passwordtextfield;



@end

@implementation LSLogoViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"registerCenter" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;

    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:215/255.0 green:252/255.0 blue:250/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:248/255.0 green:195/255.0 blue:141/255.0 alpha:1.0].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, HEIGHT);
    [self.backView.layer addSublayer:gradientLayer];
    
    self.LSZXlabel.font = [UIFont boldSystemFontOfSize:40];
    self.LSZXlabel.textColor = Color_RGBA(120, 120, 120, 1.0);
    
    [self.backView addSubview:self.LSZXlabel];
    
    _usernametextfield = [[HomeTextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(self.LSZXlabel.frame), WIDTH - 60, 40)];
    _usernametextfield.placeholder = @"用户名";
    _usernametextfield.backgroundColor = [UIColor clearColor];
    _usernametextfield.textColor = Color_RGBA(120, 120, 120, 1.0);
    _usernametextfield.borderStyle = UITextBorderStyleRoundedRect;
    _usernametextfield.layer.borderColor = Color_RGBA(79, 114, 93, 1.0).CGColor;
    UIImageView * userimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"username"]];
    _usernametextfield.leftView = userimage;
    _usernametextfield.leftViewMode = UITextFieldViewModeAlways;
    [self.backView addSubview:_usernametextfield];
    
    _passwordtextfield = [[HomeTextField alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(_usernametextfield.frame) + 25, WIDTH - 60, 40)];
    _passwordtextfield.placeholder = @"密码";
    _passwordtextfield.backgroundColor = [UIColor clearColor];
    _passwordtextfield.textColor = Color_RGBA(120, 120, 120, 1.0);
    _passwordtextfield.borderStyle = UITextBorderStyleRoundedRect;
    _passwordtextfield.keyboardType = UIKeyboardTypePhonePad;
    _passwordtextfield.secureTextEntry = YES;
    _passwordtextfield.layer.borderColor = Color_RGBA(79, 114, 93, 1.0).CGColor;
    UIImageView * passimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    _passwordtextfield.leftView = passimage;
    _passwordtextfield.leftViewMode = UITextFieldViewModeAlways;
    [self.backView addSubview:_passwordtextfield];
    
    
    // 将用户信息存储在本地
//    [[NSUserDefaults standardUserDefaults] setObject:self.nowPassWord.text forKey:@"passWord"];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]) {
        self.usernametextfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"]) {
            self.passwordtextfield.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"];
        }
    }


    
    
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(CGRectGetMinX(_passwordtextfield.frame), CGRectGetMaxY(_passwordtextfield.frame) + 25, CGRectGetWidth(_passwordtextfield.frame), 40);
    loginButton.backgroundColor = Color_RGBA(255, 102, 23, 1.0);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 5;
    [loginButton addTarget:self action:@selector(loginButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:loginButton];
    
    UIButton * forgotpasswordbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    forgotpasswordbutton.frame = CGRectMake(CGRectGetMinX(loginButton.frame), CGRectGetMaxY(loginButton.frame), 100, 30);
    [forgotpasswordbutton setTitleColor:nil forState:UIControlStateNormal];
    forgotpasswordbutton.backgroundColor = [UIColor clearColor];
    [forgotpasswordbutton setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgotpasswordbutton setTitleColor:Color_RGBA(255, 102, 23, 1.0) forState:UIControlStateNormal];
    forgotpasswordbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgotpasswordbutton addTarget:self action:@selector(findBackPasswordButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:forgotpasswordbutton];
    
    UIButton * newusernamebutton = [UIButton buttonWithType:UIButtonTypeSystem];
    newusernamebutton.frame = CGRectMake(CGRectGetMaxX(loginButton.frame) - 100, CGRectGetMaxY(loginButton.frame), 100, 30);
    [newusernamebutton setTitle:@"新用户注册" forState:UIControlStateNormal];
    [newusernamebutton setTitleColor:Color_RGBA(255, 102, 23, 1.0) forState:UIControlStateNormal];
    newusernamebutton.backgroundColor = [UIColor clearColor];
    newusernamebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.backView addSubview:newusernamebutton];
    [newusernamebutton addTarget:self action:@selector(newuserbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfor:) name:@"registerCenter" object:nil];  // 收到注册成功的通知获取用户信息

}

- (void)getUserInfor:(NSNotification *)info
{
    NSLog(@"%@",info);
    self.usernametextfield.text = info.userInfo[@"tele"];
    self.passwordtextfield.text = info.userInfo[@"pass"];
}


-(void)loginButton:(UIButton *)sender{
    
    if ([self.usernametextfield.text isEqualToString:@""] ||[self.passwordtextfield.text isEqualToString:@""]) {
        [self showTextHUD:@"请输入用户名或密码"];
        return;
    }
    NSString *pwdEncrypt = [JGEncrypt encryptWithContent:self.passwordtextfield.text type:kCCEncrypt key:TextKey];
    StorageUserInfromation *Storage = [StorageUserInfromation storageUserInformation];
    if (!Storage.dingweiCity) {
        Storage.dingweiCity = @"重庆";
        Storage.coordX = @"0";
        Storage.coordY = @"0";
    }
    NSDictionary *dict = @{@"platform":@"2",@"phone":self.usernametextfield.text,@"pwd":pwdEncrypt,@"coordX":Storage.coordX,@"coordY":Storage.coordY,@"cityName":Storage.dingweiCity};
    NSLog(@"%@",dict);
    [self showHUDWithMessage:@"正在登录..."];
    
    [ZTHttpTool postWithUrl:@"User/Login" param:dict success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        JGLoginBaseModel *baseModel = [JGLoginBaseModel mj_objectWithKeyValues:responseObj];
        if (!baseModel.State) {
            JGLoginModel *login = [JGLoginModel mj_objectWithKeyValues:baseModel.Data];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            Storage.level = login.level;
            storage.Huanxin = login.huanxin;
            storage.pwd = pwdEncrypt;
            storage.areaCode = login.areaCode;
            storage.buildingID = login.buildingId;
            storage.buildingChatId = login.buildingChatId;
            storage.token = login.token;
            storage.userID = login.uid;
            storage.auditingManager = [login.auditingManager intValue];
            storage.loginPhone = login.phone;
            Storage.nickName = login.nickName;
            Storage.auditingState = login.auditingState;
            Storage.state = login.state;
            
            Storage.buildingName =login.buildingName;
            Storage.gender = login.sex;
            Storage.age = login.age;
            Storage.userHeadImage = login.logo;
            storage.birthday = login.birthday;
            storage.trueName = login.trueName;
            storage.buildingImageUrl = login.buildingImg;
            storage.blockGroupMsg=login.blockGroupMsg;
           
            
            //每次登录后 设置成自动登录
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"autoLogin"];
            
            // 将用户信息存储在本地
            [[NSUserDefaults standardUserDefaults] setObject:self.usernametextfield.text forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordtextfield.text forKey:@"passWord"];

            
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            delegate.window.rootViewController = mainStoryboard.instantiateInitialViewController;
            
            //初始化消息界面推送
        }else{
            [self showTextHUD:baseModel.Msg];
        }
        [self hideHud];
    } failure:^(NSError *error) {
        [self showTextHUD:@"连接服务器失败,请稍后再试!"];
        [self hideHud];
    }];


}

-(void)newuserbutton:(UIButton *)sender{
  
    LSReguseViewController * page = [[LSReguseViewController alloc] init];
//    page.toptitleStr = @"注册";
//    page.boomButtonStr = @"注册完成";
    [self.navigationController pushViewController:page animated:YES];
}

-(void)findBackPasswordButton:(UIButton *)sender{
    
    LSFindBackPasswordViewController * page = [[LSFindBackPasswordViewController alloc] init];
    [self.navigationController pushViewController:page animated:YES];
}

@end
