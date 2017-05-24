//
//  JGMyWalletViewController.m
//  NDP_eHome
//
//  Created by 冠美 on 16/2/3.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGMyWalletViewController.h"

#import "JGPayMoenyFromWalletViewController.h"
#import "JGGetMoneyFromWalletViewController.h"

@interface JGMyWalletViewController ()<UIActionSheetDelegate>
{
    UIActionSheet * actionSheet1;
}
@end

@implementation JGMyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.PayToWalletBtn.layer.cornerRadius = 20;
    self.getOutMoneyFromWalletBtn.layer.cornerRadius = 20;
    self.getOutMoneyFromWalletBtn.layer.borderWidth = 1;
    self.getOutMoneyFromWalletBtn.layer.borderColor = backGroundColor.CGColor;
    self.walletImageConstraint.constant = (SCREEN_WIDTH-87)/2.0;
    [self reloadData];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
//    [self reloadData];
}
-(void)reloadData{
    [ZTHttpTool postWithUrl:@"UserCenter/MyMoney" param:@{} success:^(id responseObj) {
        if ([responseObj[@"State"] integerValue] == 0) {
            NSLog(@"%@",[responseObj mj_JSONObject]);
            NSLog(@"%@",responseObj[@"Msg"]);
            self.moneyLabel.text = [NSString stringWithFormat:@"¥%@",responseObj[@"Data"][@"balance"]];
            
        }else{
            [self showHint:responseObj[@"Msg"]];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
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

- (IBAction)recordListBtnClick:(id)sender {
//    if ([[UIDevice currentDevice].systemVersion floatValue]>8.0) {
//        
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        
//        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"交易记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            JGMyBillListViewController * page = [[JGMyBillListViewController alloc]init];
//            [self.navigationController pushViewController:page animated:YES];
//        }];
//        UIAlertAction * alertAction3 = [UIAlertAction actionWithTitle:@"红包记录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            JGMyRedBagRecordViewController * page = [[JGMyRedBagRecordViewController alloc]init];
//            [self.navigationController pushViewController:page animated:YES];
//        }];
//        [alertController addAction:alertAction1];
//        [alertController addAction:alertAction2];
//        [alertController addAction:alertAction3];
//        [self presentViewController:alertController animated:YES completion:nil];
//       
//    }
//    //#else
//    else{
//        // This code will compile on versions<8.0
//        actionSheet1 = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"交易记录",@"红包记录", nil];
//
//    }
}

- (IBAction)payToWalletBtnClick:(id)sender {
    JGPayMoenyFromWalletViewController * page = [[JGPayMoenyFromWalletViewController alloc]init];
 //   [self presentViewController:page animated:YES completion:nil];
    [self.navigationController pushViewController:page animated:YES];
}

#pragma mark -提现-
- (IBAction)getOutMoneyFromWalletBtnClick:(id)sender {
    JGGetMoneyFromWalletViewController * page = [[JGGetMoneyFromWalletViewController alloc]init];
 //   [self presentViewController:page animated:YES completion:nil];
    [self.navigationController pushViewController:page animated:YES];
}
#pragma mark --UIActionSheetDelegate-

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%zd",buttonIndex);
//    if (actionSheet == actionSheet1) { //上传的sheet
//        
//        if (buttonIndex==0) {
//            JGMyBillListViewController * page = [[JGMyBillListViewController alloc]init];
//            [self.navigationController pushViewController:page animated:YES];
//        }
//        if (buttonIndex==1) {
//            JGMyRedBagRecordViewController * page = [[JGMyRedBagRecordViewController alloc]init];
//            [self.navigationController pushViewController:page animated:YES];
//        }
//    }

}

@end
