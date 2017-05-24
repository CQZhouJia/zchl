//
//  MyTabController.m
//  LSOnline
//
//  Created by jglx on 17/3/14.
//  Copyright © 2017年 zhoujia. All rights reserved.
//


#import "MyTabController.h"
#import "LSProfileTableViewCell.h"
#import "JGSetUpViewController.h"
#import "LSPreMessagViewController.h"
#import "CerMessageViewController.h"
#import "MyorderViewController.h"
#import "CustomViewController.h"

@interface MyTabController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView * _tableView;
    NSArray * imageArray;
    NSArray * nameArray;
    UIImageView * tableHeaderBackgrouandView;
    UIImageView * headerImageView;
    UILabel * nameLabel;
    UILabel * dengjiLabel;
    UILabel * dengjiNunberLabel;
    UILabel * scoreLabel;
    UILabel * scoreNumLabel;
    
    UIImageView * levelImageView;
    UILabel * levelText;

}

@end

@implementation MyTabController


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateHeader];
}

#pragma mark -更新头部小区数据
-(void)updateHeader{

    
//   StorageUserInfromation * storge = [StorageUserInfromation storageUserInformation];
//    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",storge.userHeadImage]] placeholderImage:[UIImage imageNamed:@"photode"]];
//    nameLabel.text = storge.nickName;
    
    
    StorageUserInfromation * storge = [StorageUserInfromation storageUserInformation];
    [headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",storge.userHeadImage]] placeholderImage:[UIImage imageNamed:@"photode"]];
    nameLabel.text = storge.nickName;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _tableView.contentOffset = CGPointMake(0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    imageArray = [[NSArray alloc] initWithObjects:@"renzhenziliao",@"wowallet",@"Mydingdan",@"MyCustom", nil];
    nameArray = [[NSArray alloc] initWithObjects:@"认证资料",@"我的钱包",@"我的订单",@"客服中心", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = Color_RGBA(239, 239, 245, 1);
    [self.view addSubview:_tableView];
 
//    _tableView.tableHeaderView = ({
        CGFloat xiuzhengHight = 0;
        UIView * mytableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 170)];
        tableHeaderBackgrouandView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 170)];
        tableHeaderBackgrouandView.image = [UIImage imageNamed:@"header"];
        tableHeaderBackgrouandView.userInteractionEnabled = YES;
        tableHeaderBackgrouandView.layer.masksToBounds = YES;
        tableHeaderBackgrouandView.center = CGPointMake(WIDTH/2.0, 170/2.0);
        
        //圆形头像背景
        UIImageView * headerBackGrouandImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2.0-78.0/2.0 - 2, 40+xiuzhengHight, 82, 82)];
        headerBackGrouandImageView.image = [UIImage imageNamed:@"black_1"];
        
        headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH/2.0 - 78/2.0, 42 + xiuzhengHight, 78, 78)];
        headerImageView.image = [UIImage imageNamed:@"photo"];
        headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        headerImageView.layer.borderWidth = 2.0;
        headerImageView.layer.cornerRadius = 78/2.0;
        headerImageView.layer.masksToBounds = YES;
        headerImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerTapClick:)];
        [headerImageView addGestureRecognizer:tap];
    
       UIImageView * nameBackGroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 123, WIDTH, 50)];
       nameBackGroundImage.image = [UIImage imageNamed:@"nameBackGround"];
       nameBackGroundImage.alpha = 0.3;
    
    dengjiLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/4 - 50, 125, 50, 20)];
    dengjiLabel.text = @"等级";
    dengjiLabel.textColor = [UIColor whiteColor];
    dengjiLabel.textAlignment = NSTextAlignmentCenter;
    dengjiLabel.font = [UIFont systemFontOfSize:12];
    
    dengjiNunberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(dengjiLabel.frame), CGRectGetMaxY(dengjiLabel.frame), CGRectGetWidth(dengjiLabel.frame), 20)];
    dengjiNunberLabel.textColor = [UIColor whiteColor];
    StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
    NSLog(@"%@",storage.level);
    dengjiNunberLabel.text = storage.level;
    dengjiNunberLabel.textAlignment = NSTextAlignmentCenter;
    dengjiNunberLabel.font = [UIFont systemFontOfSize:12];
    
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH - 80)/2, 130, 80, 20)];
//        nameLabel.text = @"李小娜";
    nameLabel.text = storage.nickName;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:17];
        nameLabel.textAlignment =NSTextAlignmentCenter;
    
//       CGRect nameRect = [self autoWidthForString:@"李小娜" font:17];
//       NSLog(@"%f",nameRect.size.width);
//       levelImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - nameRect.size.width)/2.0 - 5, CGRectGetMaxY(nameLabel.frame) + 2, 25, 18)];
//    levelImageView.image = [UIImage imageNamed:@"等级0"];
// 
//    
//    
//    levelText = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(levelImageView.frame), CGRectGetMinY(levelImageView.frame), 200, 20)];
//    levelText.textAlignment = NSTextAlignmentLeft;
//    levelText.text = @"乐善大使";
//    levelText.textColor = [UIColor whiteColor];
//    levelText.font = [UIFont systemFontOfSize:14];
    
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/4 * 3, CGRectGetMinY(dengjiLabel.frame), CGRectGetWidth(dengjiLabel.frame), 20)];
    scoreLabel.text = @"积分";
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.font = [UIFont systemFontOfSize:12];
    
    scoreNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(scoreLabel.frame), CGRectGetMinY(dengjiNunberLabel.frame), CGRectGetWidth(scoreLabel.frame), 20)];
    scoreNumLabel.textColor = [UIColor whiteColor];
    NSLog(@"%@",storage.score);
//    scoreNumLabel.text = @"299";
    scoreNumLabel.text = storage.score;
    scoreNumLabel.font = [UIFont systemFontOfSize:12];
    scoreNumLabel.textAlignment = NSTextAlignmentCenter;
    
        [mytableHeaderView addSubview:tableHeaderBackgrouandView];
        [mytableHeaderView addSubview:headerBackGrouandImageView];
        [mytableHeaderView addSubview:headerImageView];
        [mytableHeaderView addSubview:nameBackGroundImage];
    [mytableHeaderView addSubview:dengjiLabel];
    [mytableHeaderView addSubview:dengjiNunberLabel];
    
        [mytableHeaderView addSubview:nameLabel];
    [mytableHeaderView addSubview:scoreLabel];
    [mytableHeaderView addSubview:scoreNumLabel];
        [mytableHeaderView addSubview:levelImageView];
    [mytableHeaderView addSubview:levelText];
        [self updateHeader];
        
//        mytableHeaderView;
//    });
    _tableView.tableHeaderView = mytableHeaderView;

 
}

-(CGRect)autoWidthForString:(NSString *)string font:(CGFloat)font{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:font]} context:nil];
    return rect;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return imageArray.count;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%zd",indexPath.section);
  if (indexPath.section == 0){
        LSProfileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LSProfileTableViewCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LSProfileTableViewCell" owner:self options:nil] lastObject];;
        }
        cell.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",[imageArray objectAtIndex:indexPath.row]]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",[nameArray objectAtIndex:indexPath.row]];
        if (indexPath.row == imageArray.count) {
            cell.MoreImage.hidden = YES;
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 200, 10, 170, 21)];
            label.text = @"周一至周日 08:00-22:00";
            label.font = [UIFont systemFontOfSize:12.0];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = Color_RGBA(198, 198, 198, 1);
            label.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:label];
        }
        return cell;
    }else{
        LSProfileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LSProfileTableViewCell"];
        if (cell == nil) {
             cell = [[[NSBundle mainBundle] loadNibNamed:@"LSProfileTableViewCell" owner:self options:nil] lastObject];
        }
            cell.logoImageView.image = [UIImage imageNamed:@"setting"];
            cell.nameLabel.text = [NSString stringWithFormat:@"设置"];
            cell.lineView.hidden = YES;
            return cell;
        }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else{
        return 2;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 10)];
    view.backgroundColor = Color_RGBA(239, 239, 245, 1);
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
        return 42;
  
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%zd  -- %zd",indexPath.section,indexPath.row);
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
//        // 认证资料
        CerMessageViewController * page = [[CerMessageViewController alloc] init];
        page.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:page animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 1){
//       // 我的钱包
        JGMyWalletViewController * walletVC = [[JGMyWalletViewController alloc] init];
        walletVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:walletVC animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 2){
      // 我的订单
        MyorderViewController * orderPage = [[MyorderViewController alloc] init];
        orderPage.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderPage animated:YES];
        
    }else if (indexPath.section == 0 && indexPath.row == 3){
      // 客服热线
//        NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt:400717767"];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        CustomViewController * customVC = [[CustomViewController alloc] init];
        customVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:customVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 0){
      //  设置
        JGSetUpViewController * page = [[JGSetUpViewController alloc]init];
        page.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:page animated:YES];
    }
}

#pragma mark pushto免费物业
-(void)LSPrefileCenterButtonPrefilePressButton{
//    LSEstateViewController * lseVC = [[LSEstateViewController alloc] init];
//    lseVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:lseVC animated:YES];
}

#pragma mark -- 根据scrollview.contentoffset 按比例放大headerView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGRect  rect = tableHeaderBackgrouandView.frame;
    if (scrollView.contentOffset.y>=0) {
        return;
    }
    rect.size.height=170 -(scrollView.contentOffset.y);
    rect.size.width = ([UIScreen mainScreen].bounds.size.width/170)*rect.size.height;
    tableHeaderBackgrouandView.frame = rect;
    tableHeaderBackgrouandView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, rect.size.height/2.0 + (scrollView.contentOffset.y));

}

-(void)headerTapClick:(UITapGestureRecognizer*)tap{
    LSPreMessagViewController * PreMessageVC = [[LSPreMessagViewController alloc] init];
    PreMessageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:PreMessageVC animated:YES];
    
}

@end
