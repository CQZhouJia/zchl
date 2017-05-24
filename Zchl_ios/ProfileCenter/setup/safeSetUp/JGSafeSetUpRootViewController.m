//
//  JGSafeSetUpRootViewController.m
//  NDP_eHome
//
//  Created by 钟亮 on 16/3/23.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGSafeSetUpRootViewController.h"
#import "JGProfileTableViewCell.h"
#import "JGSafeSetUpViewController.h"
//#import "JGSendCodeController.h"
@interface JGSafeSetUpRootViewController ()
{
    NSArray * imageArray;
    NSArray * nameArray;
}
@end

@implementation JGSafeSetUpRootViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    imageArray = [[NSArray alloc]initWithObjects:@"set_icon_password",@"set_icon_pay",nil];
    nameArray = [[NSArray alloc]initWithObjects:@"管理登陆密码",@"管理支付密码", nil];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = backGroundColor;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JGProfileTableViewCell * cell ;
    cell = [[[NSBundle mainBundle] loadNibNamed:@"JGProfileTableViewCell" owner:self options:nil] lastObject];
    cell.logoImageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:indexPath.row] ];
//    cell.CellImageWidth.constant = [FlexibeFrame flexibleFloat:cell.contentView.height] - 9;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        JGSafeSetUpViewController * page = [[JGSafeSetUpViewController alloc]init];
        [self.navigationController pushViewController:page animated:YES];
    }else{
//        JGSendCodeController * page = [[JGSendCodeController alloc]init];
//        [self.navigationController pushViewController:page animated:YES];
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [FlexibeFrame flexibleFloat:320], 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
