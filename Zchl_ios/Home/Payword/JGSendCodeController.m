//
//  JGSendCodeController.m
//  NDP_eHome
//
//  Created by zhuangtao on 16/3/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGSendCodeController.h"
//#import "JGPayWordController.h"

@interface JGSendCodeController ()
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (assign,nonatomic) int seconds;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;
@property (strong,nonatomic) NSTimer *myTiemr;
@property (strong,nonatomic)NSDictionary *callBackDict;
@end

@implementation JGSendCodeController

- (void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.seconds = 60;
    self.codetextfield.keyboardType = UIKeyboardTypeNumberPad;

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendCode:(id)sender {
    if (self.myTiemr == nil) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        self.myTiemr = timer;
    }
    
    NSDictionary *param = nil;
    [ZTHttpTool postWithUrl:@"UserCenter/PayPwdSendSMS" param:param success:^(id responseObj) {
        self.callBackDict = responseObj[@"Data"];
        NSLog(@"%@",responseObj);
        if ([responseObj[@"State"] integerValue] == 0) {
//            self.code = [JGEncrypt encryptWithContent:responseObj[@"Data"][@"code"] type:kCCDecrypt key:TextKey];
        }else{
            [self showHint:responseObj[@"Msg"]];
        }
        ;
    } failure:^(NSError *error) {
        
    }];
    
}

- (IBAction)next:(id)sender {
    [self.codetextfield resignFirstResponder];
    if ([self.codetextfield.text isEqualToString:@""]) {
        [self showHint:@"请获取验证码"];
        return;
    }
    
    //取消本地验证-问了安全 客户端不需知道密码

    JGPayWordController *payWord = [[JGPayWordController alloc] init];
    payWord.callBackDict = self.callBackDict;
    payWord.code= self.codetextfield.text;
    [self.navigationController pushViewController:payWord animated:YES];
    
    
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

@end
