//
//  JGSafeSetUpViewController.m
//  NDP_eHome
//
//  Created by 冠美 on 16/2/2.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGSafeSetUpViewController.h"
#import "AppDelegate.h"

@interface JGSafeSetUpViewController ()<UITextFieldDelegate>

@end

@implementation JGSafeSetUpViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = backGroundColor;
    self.confirmBtn.layer.cornerRadius = 5;
    self.oldPassWord.layer.cornerRadius = 5;
    self.oldPassWord.layer.borderColor = [UIColor grayColor].CGColor;
    self.oldPassWord.layer.borderWidth = 0.5;
    self.oldPassWord.layer.masksToBounds = YES;
    
    self.nowPassWord.layer.cornerRadius = 5;
    self.nowPassWord.layer.borderColor = [UIColor grayColor].CGColor;
    self.nowPassWord.layer.borderWidth = 0.5;
    self.nowPassWord.layer.masksToBounds = YES;

    self.comfirmNowPassWord.layer.cornerRadius = 5;
    self.comfirmNowPassWord.layer.borderColor = [UIColor grayColor].CGColor;
    self.comfirmNowPassWord.layer.borderWidth = 0.5;
    self.comfirmNowPassWord.layer.masksToBounds = YES;
    self.nowPassWord.secureTextEntry = YES;
    self.oldPassWord.secureTextEntry = YES;
    self.comfirmNowPassWord.secureTextEntry = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.oldPassWord endEditing:YES];
    [self.nowPassWord endEditing:YES];
    [self.comfirmNowPassWord endEditing:YES];

}
- (IBAction)comfirmBtnClick:(id)sender {
//    if ([JGIsBlankString isBlankString:self.oldPassWord.text ]) {
//        [self  showHint:@"旧密码不能为空"];
//        return;
//    }
//    if ([JGIsBlankString isBlankString:self.nowPassWord.text ]) {
//        [self  showHint:@"新密码不能为空"];
//        return;
//    }
//    if ([JGIsBlankString isBlankString:self.comfirmNowPassWord.text ]) {
//        [self  showHint:@"确认密码不能为空"];
//        return;
//    }
//    if (![self.nowPassWord.text isEqual:self.comfirmNowPassWord.text]) {
//        [self showHint:@"新密码和确认密码输入不一致"];
//        return;
//    }
//    NSString * oldPasswordEncord =  [JGEncrypt encryptWithContent:self.oldPassWord.text type:kCCEncrypt key:TextKey];
//    NSString * nowPasswordEncord =  [JGEncrypt encryptWithContent:self.nowPassWord.text type:kCCEncrypt key:TextKey];
//
//    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
//    NSDictionary * param = @{@"platform":@"2",@"uid":storage.userID,@"phone":storage.loginPhone,@"token":storage.token,@"oldPwd":oldPasswordEncord,@"newPwd":nowPasswordEncord};
//    
//    
//    [ZTHttpTool postWithUrl:@"UserCenter/ChangePwd" param:param success:^(id responseObj) {
//        if ([responseObj[@"State"] integerValue] == 0) {
//            // 将用户信息存储在本地
//            [[NSUserDefaults standardUserDefaults] setObject:self.nowPassWord.text forKey:@"passWord"];
//            NSDictionary *dic = @{@"tele":[StorageUserInfromation storageUserInformation].loginPhone,@"pass":self.nowPassWord.text};
//            NSLog(@"%@",dic);
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"registerCenter" object:self userInfo:dic];
//                       
//            //退出登录
//            LSLogoViewController *page  = [[LSLogoViewController alloc]initWithNibName:@"LSLogoViewController" bundle:nil];
//
//            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            delegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:page];
//            [self.tabBarController setSelectedIndex:0];
//        }else{
//            [self showHint:responseObj[@"Msg"]];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
}

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
