//
//  JGPayMoenyFromWalletViewController.m
//  NDP_eHome
//
//  Created by 钟亮 on 16/3/18.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGPayMoenyFromWalletViewController.h"
//#import "Order.h"
//#import "DataSigner.h"
//#import <AlipaySDK/AlipaySDK.h>
//#import "APAuthV2Info.h"
#import "JGEncrypt.h"
@interface JGPayMoenyFromWalletViewController ()
{
    BOOL isHaveDian;
    BOOL isZero;
}
@end

@implementation JGPayMoenyFromWalletViewController
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
    self.nextStep.layer.cornerRadius = 3;
    self.nextStep.layer.masksToBounds = YES;
    self.money.keyboardType = UIKeyboardTypeDecimalPad;
    // Do any additional setup after loading the view from its nib.
    
    
    //添加观察者 接收支付宝回调的信息（接收结果，用于在当前页面展示（支付成功，支付失败等））
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alipayRestInfo:) name:@"PostToZhiFuPageToShow" object:nil];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PostToZhiFuPageToShow" object:nil];
}

-(void)alipayRestInfo:(NSNotification *) text{
    
    NSDictionary * restDic=text.userInfo;
    
    if ([restDic[@"resultStatus"] integerValue]==9000) {
        [self showHint:@"支付成功"];
    }else{
        [self showHint:@"支付失败"];
    }
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

- (IBAction)nextStepBtnClick:(id)sender {
    [self.money resignFirstResponder];
    if ([JGIsBlankString isBlankString:self.money.text]) {
        [self showHint:@"请输入金额"];
        return;
    }
//    if ([self.money.text integerValue]<5) {
//        [self showHint:@"充值金额至少5元"];
//        return;
//    }
    [self showHUDWithMessage:@"正在加载中..."];
    [ZTHttpTool postWithUrl:@"Balance/BuildAlipayOrder" param:@{@"moneyStr":[JGEncrypt encryptWithContent:self.money.text type:kCCEncrypt key:TextKey],@"nickname":[StorageUserInfromation storageUserInformation].nickName} success:^(id responseObj) {
        [self hideHud];
        if ([responseObj[@"State"] integerValue]  ==0) {
            [self keyizhifu:responseObj[@"Data"]];

        }
    } failure:^(NSError *error) {
        [self hideHud];
    }];
    
}
- (void)keyizhifu:(NSDictionary*)returnDict
{
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
//    NSString *partner = @"2088121602726575";
//    NSString *seller = @"1003339999@jgyx.com";
//    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAMsnUtz5jopAa7bFUUK1/4gbhHrziWOl6LzIX5nNlwWgc3GL6jPXhyKXEuV52zHeOlV1VF1Nc5rAUFdyRnXe8Al8ClxdYejCIXSpRxQA1MKedZw6ifZZshTd7wkyMqfcJww+7eF/4YB/FwuusZZqKf0k8Q3WdHuU4RH+pA740hEvAgMBAAECgYBGiWHRDek7AYEk1cAQPKb7uCo4koSaj8mOergO6/5K2toai60G0Qe/r9rEyJmd5/4zG+jt+G1yRuHeavQiCwUmdqe9Gs0ed9ePBmZpFTr35Txg2x64ZlFKvjJvTlzAnecewZ6KxtZ1SYDcAEl84SNKXu/5NQXk/n1+klH684AJiQJBAP1fEVNSI4+DvtPvQ6cgCEg936W92432Ojr93zGJ6N1y5XCfw8iRuw7ofyFfSXuuMD9wKSa7PibRxsl1nkt5W90CQQDNQuHMVC4hJOJC3AtOTxGovEOLkMmRhGDV5H2YKnwGo1vXtP7Ri2s2IPbaryLK0XztTqui5arHPDRFQHil7sZ7AkEAvjQV34Sz6VKveI4PLXDghsrcD6IdJc8IG6zlVlz/EO7lysxEv1aXJDPo6/aKRWyYD6d1XPwHRkEIh8fiEyqBiQJAaiioLYxwGzY/S0MRGdwtDu7npDwq8/baOmWlS1jVsn00l/iFPgz0UxdzdKDVxr3X9cgVXveXftm1UwfIHlHDFwJAOMkpamHa5scQ5ztdyqEKO8cZ91ESNGYmWZ9E74gZ/3iX/DkBHs4BJViek/Z3+tyDhpHAUlAp8JuJRDrKMPklwQ==";
//    /*============================================================================*/
//    /*============================================================================*/
//    /*============================================================================*/
//    
//    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    /*
//     *生成订单信息及签名
//     */
//    //将商品信息赋予AlixPayOrder的成员变量
//    Order *order = [[Order alloc] init];
//    order.partner = partner;
//    order.seller = seller;
//    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.productName = [NSString stringWithFormat:@"Lx.%@",[StorageUserInfromation storageUserInformation].loginPhone]; //商品标题
//    order.productDescription = @"余额充值"; //商品描述
//    order.amount = [NSString stringWithFormat:@"%0.2f",[self.money.text floatValue]]; //商品价格
//    order.notifyURL =  @"http://www.jgyx.com"; //回调URL
//    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
//    order.itBPay = @"30m";
//    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemoZCHL";
    
    //将商品信息拼接成字符串
 //   NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
//    
//    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
//    NSLog(@"signedString = %@",signedString);
    
    NSArray *array = [[UIApplication sharedApplication] windows];
    UIWindow* win=[array objectAtIndex:0];
    [win setHidden:NO];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
    if (returnDict != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
//        NSLog(@"orderString = %@",orderString);

        
        
        //发送通知到appdelegate页面，把订单号和金额传过去，在支付宝的回调中（跳到支付宝后应用被kill了，此处回调不会走，要到APPdelegate中回调）返回给服务端
        NSDictionary * alipayInfoDic=@{@"orderNo":returnDict[@"orderNo"],@"money":self.money.text};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AlipayMoneyInfo" object:nil userInfo:alipayInfoDic];
        
        [[AlipaySDK defaultService] payOrder:returnDict[@"returnStr"] fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            
            if([[resultDic valueForKey:@"resultStatus"] integerValue] == 9000){
                NSString *orderEncode = returnDict[@"orderNo"];
                NSString *moneyEncode = [JGEncrypt encryptWithContent:self.money.text type:kCCEncrypt key:TextKey];

                NSDictionary  *dic = @{@"order":orderEncode,@"money":moneyEncode};
                [ZTHttpTool postWithUrl:@"UserCenter/Recharge" param:dic success:^(id responseObj) {
//                    [win setHidden:YES];
                    NSLog(@"%@",responseObj);
                    [self showHint:responseObj[@"Msg"]];
                    if ([responseObj[@"State"] integerValue] == 0||[responseObj[@"State"] integerValue] == 1) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } failure:^(NSError *error) {
//                    [win setHidden:YES];

                }];
//                [self showHint:@"支付成功"];
//                
//                [self.navigationController popViewControllerAnimated:YES];

            }else{
//                [win setHidden:YES];

                [self showHint:@"支付失败"];
            }
           

            }];
    }
}

- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((int)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
