//
//  UsedetaiController.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "UsedetaiController.h"
#import "UserFirstCell.h"
#import "secondCell.h"
#import "threeCell.h"


@interface UsedetaiController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray * leftArr;

@property (nonatomic,strong)NSArray * rightArr;

@property (nonatomic,strong)NSDictionary * dic;

@property (nonatomic,strong)NSDictionary * boomDic;

@property (nonatomic,strong)NSArray * imgsArr;

@property (nonatomic,strong)JGPayPassWordView * payView;
@property (nonatomic,strong)JGClickedPayButtonView *failedView;
@property (nonatomic,strong)JGClickedPayButtonSuccessView *successView;

@end

@implementation UsedetaiController


- (IBAction)buttonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leftArr = @[@"使用年限",@"出厂时间",@"维修状况",@"工作时间",@"所在地",@"合格证/发票"];
    _rightArr = @[@"3年",@"2015年8月3日",@"维修1次",@"1年",@"重庆",@"齐全"];
    
    [self.usertableView tableViewGetFootEmptyView];
    
    [self setNav];
    [self initData];
}

-(void)setNav{
  
    UIColor * colorOne = Color_RGBA(101, 218, 108, 1.0);
    UIColor * colorTwo = Color_RGBA(62, 178, 71, 1.0);
    [self viewChangeColorWithTwoColor:colorOne anotherColor:colorTwo andView:self.topview];
    
    [self.topview addSubview:self.backbutton];
    [self.topview addSubview:self.titlelabel];
}

-(void)initData{
    NSDictionary * dic = @{@"proId":_proId};
    [ZTHttpTool postWithUrl:@"Goods/QueryOne" param:dic success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        _dic = responseObj[@"Data"];
        
        _imgsArr = _dic[@"imgs"];
        NSString * jsonStr = _dic[@"desc"];
        NSData * jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError * parseError = nil;
        _boomDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&parseError];
        if (parseError) {
            NSLog(@"%@",[parseError description]);
        }
        NSLog(@"%@",_boomDic);
        
        [self.usertableView reloadData];
    } failure:^(NSError *error) {
        //
    }];

}

- (IBAction)phoneclick:(UIButton *)sender {
    NSString * phone = [NSString stringWithFormat:@"%zd",[_dic[@"linkPhone"] integerValue]];
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

}


- (IBAction)dingjingClick:(UIButton *)sender {
    if ([[UIDevice currentDevice].systemVersion floatValue]>8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认支付？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self submit];
            
        }];
        
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}
-(void)submit{
    
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    NSDictionary * parm = @{@"platform":@"2",@"uid":storage.userID,@"phone":storage.loginPhone,@"token":storage.token};
    NSLog(@"%@",parm);
    [ZTHttpTool postWithUrl:@"UserCenter/ExistPayPwd" param:parm success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        if ([responseObj[@"State"] integerValue]==0) {  //已设置密码
            JGPayPassWordView *payWordView = [[[NSBundle mainBundle] loadNibNamed:@"JGPayPassWordView" owner:self options:nil] lastObject];
            
            payWordView.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.payView = payWordView;
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [UIView animateWithDuration:0.3 animations:^{
                    payWordView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                }];
            } completion:^(BOOL finished) {
                
            }];
            
            //支付的金额
            //                payWordView.moneyLabel.text = [NSString stringWithFormat:@"%0.2f元",[self PayRealtotalMoney]];
            
            payWordView.moneyLabel.text = [NSString stringWithFormat:@"%0.2f元",[_dic[@"priceDeposit"] floatValue]];
            
            //            NSLog(@"%@",_dic[@"priceDeposit"])
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
            [self showHint:@"数据异常"];
            [self hideHud];
        }
        
    } failure:^(NSError *error) {
        [self showHint:@"数据异常"];
        [self hideHud];
    }];
    
}

- (void)removePayView{
    [self.payView removeFromSuperview];
}

- (void)forgetPwd{
    //跳转到更改密码
    [self.payView removeFromSuperview];
    JGSendCodeController *sendCode = [[JGSendCodeController alloc] init];
    [self.navigationController pushViewController:sendCode animated:YES];
}

- (void)sendRed{
    
    
    //    防止多次付款
    
    
    if (!self.payView.isPayed) {
        
        [self.payView removeFromSuperview];
        
        self.payView.isPayed = YES;
        NSString * actStr = [JGEncrypt encryptWithContent:self.payView.actStr type:kCCEncrypt key:TextKey];
        
        NSDictionary * param = @{@"proId":_dic[@"proId"],@"remark":@"",@"payPwd":actStr};
        NSLog(@"%@",param);
        
        [self showHUDWithMessage:@"正在提交..."];
        [ZTHttpTool postWithUrl:@"Goods/Buy" param:param success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if ([responseObj[@"State"] integerValue] == 0) {
                //            [self showHint:responseObj[@"Msg"]];
                //            [self.navigationController popViewControllerAnimated:YES];
                //付款成功
                //                [self.payView removeFromSuperview];
                self.successView = [[[NSBundle mainBundle] loadNibNamed:@"JGClickedPayButtonSuccessView" owner:self options:nil] lastObject];
                self.successView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                self.successView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                [[UIApplication sharedApplication].keyWindow addSubview:self.successView];
                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [UIView animateWithDuration:0.3 animations:^{
                        self.successView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                } completion:^(BOOL finished) {
                    
                }];
                
                self.view.alpha = 0.5;
                
                [self.successView.seeMyOrderButton addTarget:self action:@selector(pushToGoodsBuy) forControlEvents:UIControlEventTouchUpInside];
                [self.successView.finishButton addTarget:self action:@selector(finishButtonClicked) forControlEvents:UIControlEventTouchUpInside];
                
            }else if ([responseObj[@"State"] intValue] == 2){
                
                //跳转到设置密码界面
                
                JGSendCodeController *sendCode = [[JGSendCodeController alloc] init];
                [self.navigationController pushViewController:sendCode animated:YES];
                
                //                [self.payView removeFromSuperview];
            }else{
                //付款失败
                [self.payView removeFromSuperview];
                self.failedView = [[[NSBundle mainBundle] loadNibNamed:@"JGClickedPayButtonView" owner:self options:nil] lastObject];
                self.failedView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
                //                self.failedView.MSGLabel.text = [NSString stringWithFormat:@"%@",responseObj[@"Msg"]];
                self.failedView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                [[UIApplication sharedApplication].keyWindow addSubview:self.failedView];
                [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    [UIView animateWithDuration:0.3 animations:^{
                        self.failedView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                    }];
                } completion:^(BOOL finished) {
                    
                }];
                
                self.view.alpha = 0.5;
                [self.failedView.cancelButton addTarget:self action:@selector(failedCancelButtonCLicked) forControlEvents:UIControlEventTouchUpInside];
                [self.failedView.repayButton addTarget:self action:@selector(repayButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            [self hideHud];
        }];
        
    }
}

#pragma mark -- 我的订单
-(void)pushToGoodsBuy{
    [self.successView removeFromSuperview];
    self.view.alpha = 1;
    [StorageUserInfromation storageUserInformation].isPushedFromPayVC2 = YES;
    MyorderViewController * goodsButVC = [[MyorderViewController alloc] init];
    [self.navigationController pushViewController:goodsButVC animated:YES];
}

-(void)finishButtonClicked{
    [self.successView removeFromSuperview];
    self.view.alpha = 1;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)failedCancelButtonCLicked{
    [self.failedView removeFromSuperview];
    self.view.alpha = 1;
}
-(void)repayButtonClicked{
    [self.failedView removeFromSuperview];
    self.view.alpha = 1;
    
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
            //            payWordView.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[self PayRealtotalMoney]];
            payWordView.moneyLabel.text = [NSString stringWithFormat:@"%0.2f元",[_dic[@"priceDeposit"] floatValue]];
            
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
            [self hideHud];
            [EMAlertView showAlertWithTitle:@"温馨提示" message:@"你未设置支付密码" completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                if (buttonIndex) {
                    JGSendCodeController *sendCode = [[JGSendCodeController alloc] init];
                    [self.navigationController pushViewController:sendCode animated:YES];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"去设置",nil];
            
        }else{  //异常
            [self hideHud];
            [self showHint:@"数据异常"];
        }
        
    } failure:^(NSError *error) {
        [self showHint:@"数据异常"];
        [self hideHud];
    }];
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2 + _boomDic.allKeys.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * iden = @"iden";
        UserFirstCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[UserFirstCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.stastaticHttpUrl = _dic[@"stastaticHttpUrl"];
        cell.imageArr = _imgsArr;
        return cell;
    }else if (indexPath.row == 1){
        secondCell * cell;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"secondCell" owner:self options:nil] lastObject];
        }
//        @property (weak, nonatomic) IBOutlet UILabel *namelabel;
//        
//        
//        @property (weak, nonatomic) IBOutlet UILabel *moeylabel;
//        
//        
//        @property (weak, nonatomic) IBOutlet UILabel *dinglabel;
//        
//        
//        @property (weak, nonatomic) IBOutlet UILabel *dingrightlabel;
//        
//        @property (weak, nonatomic) IBOutlet UILabel *weileftlabel;
//        
//        
//        
//        @property (weak, nonatomic) IBOutlet UILabel *weiright;
        cell.namelabel.text = _dic[@"title"];
         cell.moeylabel.text = [NSString stringWithFormat:@"￥ %.2f 元",[_dic[@"price"] floatValue]];
        cell.dingrightlabel.text = _dic[@"tipsDeposit"];
        cell.weiright.text = _dic[@"tipsRemain"];
        
        return cell;
    }else{
        threeCell * cell;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"threeCell" owner:self options:nil] lastObject];
        }
//        cell.leftlabel.text = _leftArr[indexPath.row - 2];
//        cell.rightlabel.text = _rightArr[indexPath.row - 2];
        
        NSArray * keyArray = _boomDic.allKeys;
        cell.leftlabel.text = keyArray[indexPath.row - 2];
        cell.rightlabel.text = [_boomDic objectForKey:keyArray[indexPath.row - 2]];
        
        return cell;
    }


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 160;
    }else if (indexPath.row == 1){
        return 95;
    }else{
        return 38;
    }
}

@end
