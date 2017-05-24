//
//  JGPayWordController.m
//  NDP_eHome
//
//  Created by zhuangtao on 16/3/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGPayWordController.h"
#import "JGEncrypt.h"
@interface JGPayWordController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdfield;
@property (weak, nonatomic) IBOutlet UITextField *twoPwd;

@end

@implementation JGPayWordController

- (void)viewWillAppear:(BOOL)animated{
  
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pwdfield.secureTextEntry = YES;
    self.twoPwd.secureTextEntry = YES;
    self.pwdfield.keyboardType = UIKeyboardTypeNumberPad;
    self.twoPwd.keyboardType = UIKeyboardTypeNumberPad;

    // Do any additional setup after loading the view from its nib.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)updateClick:(id)sender {
    
    if(self.pwdfield.text.length !=6 || self.twoPwd.text.length != 6 ){
        [self.pwdfield resignFirstResponder];
        [self.twoPwd resignFirstResponder];
        [self showHint:@"请输入6位密码"];
        return;
    }

    if (![self.pwdfield.text isEqualToString:self.twoPwd.text]) {
        [self.pwdfield resignFirstResponder];
        [self.twoPwd resignFirstResponder];
        [self showHint:@"密码不一致!"];
        return;
    }
    NSString *secpwd = [JGEncrypt encryptWithContent:self.twoPwd.text type:kCCEncrypt key:TextKey];
    self.code = [JGEncrypt encryptWithContent:self.code type:kCCEncrypt key:TextKey];
    NSDictionary *dict = @{@"newPassword":secpwd,@"code":self.code,@"callback":[[StorageUserInfromation storageUserInformation] jsonStringWithDictionary:self.callBackDict]};
    NSLog(@"%@",dict);
    [ZTHttpTool postWithUrl:@"UserCenter/SetPayPwd" param:dict success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([responseObj[@"State"] integerValue] == 0) {
            
            
            int a = (int)[self.navigationController.viewControllers count] - 3;
            
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:a] animated:YES];
            
            
        }else{
            [self showTextHUD:responseObj[@"Msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
