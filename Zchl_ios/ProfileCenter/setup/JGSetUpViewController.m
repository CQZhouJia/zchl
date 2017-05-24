//
//  JGSetUpViewController.m
//  NDP_eHome
//
//  Created by 冠美 on 16/2/1.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGSetUpViewController.h"
#import "JGSetUpTableViewCell.h"
#import "WdCleanCaches.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "JGUserFadeBackViewController.h"
#import "JGSafeSetUpRootViewController.h"
//#import "LSLogoViewController.h"
#import "AppDelegate.h"
//#import "JGPlayRulesViewController.h"

@interface JGSetUpViewController ()<UIActionSheetDelegate>
{
    NSArray * imageArray;
    NSArray * nameArray;
    UILabel         *_cacheLabel;
    NSString        *_cacheSize;
    UIActionSheet * actionSheet1;
    UIActionSheet * actionSheet2;

}
@end

@implementation JGSetUpViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = backGroundColor;
    imageArray = [[NSArray alloc]initWithObjects:@"my_set_fankui",@"my_set_anquan",@"my_set_huancun", @"my_set_xieyi",@"my_set_guanyu",nil];
    nameArray = [[NSArray alloc]initWithObjects:@"用户反馈",@"安全设置",@"清除缓存",@"用户协议",@"关于我们", nil];
    
    // 计算缓存大小
    NSString * cachesPath = [WdCleanCaches CachesDirectory];// 路径
    
    double size = [WdCleanCaches sizeWithFilePath:cachesPath]; // 缓存大小
    _cacheSize = [NSString stringWithFormat:@"%.2fM",size];
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    JGSetUpTableViewCell * cell ;
    cell = [[[NSBundle mainBundle] loadNibNamed:@"JGSetUpTableViewCell" owner:self options:nil] lastObject];
    NSInteger num = 0;
    if (indexPath.section == 0) {
        num = indexPath.row;
    }
    if (indexPath.section == 1) {
        num = 1 + indexPath.row;
    }
    if (indexPath.section == 2) {
        num = 4 + indexPath.row;
    }
    cell.logoImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:num]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:num] ];
    // cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.CellImageWidth.constant = [FlexibeFrame flexibleFloat:cell.contentView.height] - 9
    
    if (indexPath.row == 1 && indexPath.section == 1) {
        cell.dataLabel.hidden = NO;
        cell.dataLabel.text = _cacheSize;
        _cacheLabel = cell.dataLabel;
    }
    
    if((indexPath.section == 0 && indexPath.row == 0)||(indexPath.section == 1&& indexPath.row == 2)||(indexPath.section == 2&& indexPath.row == 0)){
        cell.lineView.hidden = YES;
    }else{
        cell.lineView.hidden = NO;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return 100;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [FlexibeFrame flexibleFloat:320], 15)];
    myView.backgroundColor = [UIColor clearColor];
    return myView;
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2) {
        UIView * myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [FlexibeFrame flexibleFloat:320], 100)];
        myView.backgroundColor = [UIColor clearColor];
        
        UIButton * myBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 30,[FlexibeFrame flexibleFloat:320]-40, 40)];
        [myBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [myBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [myBtn addTarget:self action:@selector(exitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        myBtn.backgroundColor = [UIColor whiteColor];
        myBtn.layer.borderColor = [UIColor grayColor].CGColor;
        myBtn.layer.borderWidth = 1;
        myBtn.layer.cornerRadius = 3;
        [myView addSubview:myBtn];
        return myView;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 0) {
        JGUserFadeBackViewController * page = [[JGUserFadeBackViewController alloc]init];
        page.titleStr=@"用户反馈";
        page.state=1;
        [self.navigationController pushViewController:page animated:YES];
    }
    if (indexPath.row == 0 && indexPath.section == 1) {
        JGSafeSetUpRootViewController * page = [[JGSafeSetUpRootViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }
    if (indexPath.row == 2 && indexPath.section == 1) {
        [self showHUD];
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        [ZTHttpTool postWithUrl:@"Common/QueryOutsideUrl" param:@{@"flag":@"1",@"uid":storage.userID} success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if ([responseObj[@"State"] integerValue] == 0) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseObj[@"Data"][@"url"]]];
                JGPlayRulesViewController * page = [[JGPlayRulesViewController alloc]init];
                page.myTitle = @"用户协议";
                page.playRulesUrl = responseObj[@"Data"][@"url"];
                [self.navigationController pushViewController:page animated:YES];
            }else{
//                [self showHint:responseObj[@"Msg"]];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            [self hideHud];
        }];
    }if (indexPath.row == 0 && indexPath.section == 2) {
        [self showHUD];
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        [ZTHttpTool postWithUrl:@"Common/QueryOutsideUrl" param:@{@"flag":@"2",@"uid":storage.userID} success:^(id responseObj) {
            if ([responseObj[@"State"] integerValue] == 0) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:responseObj[@"Data"][@"url"]]];
                JGPlayRulesViewController * page = [[JGPlayRulesViewController alloc]init];
                page.myTitle = @"关于我们";
                page.playRulesUrl = responseObj[@"Data"][@"url"];
                [self.navigationController pushViewController:page animated:YES];
            }else{
//                [self showHint:responseObj[@"Msg"]];
            }
            [self hideHud];
        } failure:^(NSError *error) {
            [self hideHud];
        }];
    }
   if (indexPath.row == 1 && indexPath.section == 1) {

       if ([[UIDevice currentDevice].systemVersion floatValue]>8.0) {
           
           // This code will compile on versions >= ios8.0
           
           UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
           
           UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
               
           }];
           UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"清除缓存数据" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
               [self deleteData];
           }];
           
           [alertController addAction:alertAction1];
           [alertController addAction:alertAction2];
           [self presentViewController:alertController animated:YES completion:nil];
           
       }
       else{
           // This code will compile on versions<8.0
           actionSheet1 = [[UIActionSheet alloc]initWithTitle:@"确定清除乐善在线本地的缓存数据？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"清除缓存数据", nil];
           
           [actionSheet1 showInView:self.view];
       }
        
       

   }
    
}


#pragma mark -UIActionSheet delegate-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // This code will compile on versions<8.0
    if (actionSheet == actionSheet1) {  //清除缓存按钮
        
        if(buttonIndex == 0){
            [self deleteData]; //清除数据
        }else if(buttonIndex == 1){
            
        }
    }else{  //退出按钮
        
        if(buttonIndex == 0){
             //退出登录
            [self exitLoading];
        }else if(buttonIndex == 1){
            //取消
        }
    }
    
}


    
#pragma mark -清除缓存-
-(void)deleteData{
    [self showHudInView:self.view hint:@"清理中..."];
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       //                               NSLog(@"files :%ld",[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
    

}
-(void)clearCacheSuccess
{
    [self hideHud];
    _cacheLabel.text = @"0.0M";
}


#pragma mark -退出按钮-
-(void)exitBtnClick:(id)sender{
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>8.0) {
        
        // This code will compile on versions >= ios8.0
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定退出乐善在线？" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self exitLoading];
        }];
        
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    
    else{
    
        // This code will compile on versions<8.0
        actionSheet2 = [[UIActionSheet alloc]initWithTitle:@"确定退出邻信？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [actionSheet2 showInView:self.view];
    }

    
}

#pragma mark -- 退出 

-(void)exitLoading{
    
    //清除用户密码
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passWord"];
    //设置自动登录
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"autoLogin"];

    [self saveContext];

    
    //退出登录
    LSLogoViewController *page  = [[LSLogoViewController alloc]initWithNibName:@"LSLogoViewController" bundle:nil];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:page];
    [self.tabBarController setSelectedIndex:0];
    NSSet *set = [NSSet setWithObject:@""];
   
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isTerminated"];

}


- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
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
@end
