//
//  HomeViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/4/27.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "HomeViewController.h"
#import "HomePageFirstTableViewCell.h"
#import "ZchershoujiCell.h"
#import "workforCell.h"
#import "detaiMessageCell.h"
#import "UsedMachViewController.h"
#import "weixiuViewController.h"
#import "lookworkViewController.h"
#import "zhaopingViewController.h"
#import "driveMessageViewController.h"


@interface HomeViewController () <UITableViewDelegate,UITableViewDataSource,HomePageHeaderTableViewCellDelegate,ershoujibuttonDelegate,leftrightbuttonDelegate>

@property (nonatomic,strong)UIButton * locationbutton;

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSArray * boobArray;

@property (nonatomic,strong)NSArray * myArray;

@property (nonatomic,strong)NSString * staticHttpUrl;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self setNav];
    [self initTableView];
    
    [self initData];
    [self setAdSystemData];// 获取首页广告
    
    [self initBoomData];
}

-(void)setNav{
    UIView * Nabview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    Nabview.backgroundColor = Color_RGBA(32, 40, 93, 1.0);
    [self.view addSubview:Nabview];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    [Nabview addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Nabview).with.offset(30);
        make.left.equalTo(Nabview).with.offset(81);
        make.bottom.equalTo(Nabview).with.offset(-4);
        make.right.equalTo(Nabview).with.offset(-81);
    }];
    titleLabel.text = @"智诚互联";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [Nabview addSubview:titleLabel];
    
    _locationbutton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 90, 24, 80, 40)];
    [_locationbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_locationbutton setTitle:@"重庆" forState:UIControlStateNormal];
    _locationbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_locationbutton addTarget:self action:@selector(LSNbutton:) forControlEvents:UIControlEventTouchUpInside];
    [_locationbutton setImage:[UIImage imageNamed:@"boom"] forState:UIControlStateNormal];
    _locationbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [Nabview addSubview:_locationbutton];
    
    [_locationbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_locationbutton.imageView.frame.size.width - 10, 0, _locationbutton.imageView.frame.size.width)];
    [_locationbutton setImageEdgeInsets:UIEdgeInsetsMake(0, _locationbutton.titleLabel.bounds.size.width - 10, 0, -_locationbutton.titleLabel.bounds.size.width)];
}

-(void)initData{
 
    [ZTHttpTool postWithUrl:@"main/index" param:@{} success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        _staticHttpUrl = responseObj[@"Data"][@"staticHttpUrl"];
        _myArray = responseObj[@"Data"][@"activity"];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        //
    }];
}

-(void)initBoomData{
    NSDictionary * param = @{@"pn":@"1",@"rows":@"10"};
   [ZTHttpTool postWithUrl:@"Driver/Hire" param:param success:^(id responseObj) {
       NSLog(@"%@",responseObj);
       _boobArray = responseObj[@"Data"];
       [self.tableView reloadData];
   } failure:^(NSError *error) {
       //
   }];
}

-(void)setAdSystemData{
    NSDictionary * param = @{@"placeId":@"0"};
    [ZTHttpTool postWithUrl:@"AdSystem/Main" param:param success:^(id responseObj) {
        //
        NSLog(@"%@",responseObj);
    } failure:^(NSError *error) {
        //
    }];
}

-(void)LSNbutton:(UIButton *)sender{
    
}

-(void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 113) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_boobArray.count > 3) {
        return 6;
    }else{
        return 3 + _boobArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * iden = @"iden";
        HomePageFirstTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[HomePageFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.stastaticHttpUrl = _staticHttpUrl;
        cell.AdimageArray = _myArray;
        cell.delegate = self;
        return cell;

    }else if (indexPath.row == 1){
       static NSString * iden = @"zc";
        ZchershoujiCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[ZchershoujiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
    
        NSArray * nameArr = @[@"装载机",@"推土机",@"起重机",@"混泥土机",@"压路机"];
        
        cell.nameArr = nameArr;
        cell.delegate = self;
        return cell;
        
    }else if (indexPath.row == 2){
       static NSString * iden = @"workcell";
        workforCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[workforCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.delegate = self;
        return cell;
    }else{
        detaiMessageCell * cell;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"detaiMessageCell" owner:self options:nil] lastObject];
        }
        NSDictionary * dict = _boobArray[indexPath.row - 3];
        
        [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"staticHttpUrl"],dict[@"img"]]] placeholderImage:[UIImage imageNamed:DefaultPictue]];
        NSString * time = [NSString stringWithFormat:@"%@",dict[@"time"]];
        cell.phonelale.text = [NSString stringWithFormat:@"%@",dict[@"phone"]];
        cell.timelabel.text = [time substringWithRange:NSMakeRange(0, 10)];

        if ([dict[@"typeName"] isKindOfClass:[NSString class]]) {
            cell.jiqilabel.text = dict[@"typeName"];
        }else{
            cell.jiqilabel.text = @"推土机";
        }
        cell.localLabel.text = dict[@"city"];

        
        return cell;
    }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row >= 3) {
        NSDictionary * dic = _boobArray[indexPath.row - 3];
        NSString * uid = dic[@"id"];
        driveMessageViewController * messVC = [[driveMessageViewController alloc] init];
        messVC.uid = uid;
        [self.navigationController pushViewController:messVC animated:YES];
    }


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 250.f;
    }else if (indexPath.row == 1){
        return 120;
    }else if (indexPath.row == 2){
        return 44;
    }else{
        return 80;
    }
}

#pragma mark -- 驾驶员 维修 代理
-(void)ServericsCollectionViewClick:(NSInteger)indexPathRow{
    if (indexPathRow == 0) {
        // 驾驶员
//        [self LStoActiveVC];
        self.tabBarController.selectedIndex = 1;
    }else if (indexPathRow == 1){
// 二手机
        UsedMachViewController * page = [[UsedMachViewController alloc] init];
        page.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:page animated:YES];
    }else if (indexPathRow == 2){
//        维修
        weixiuViewController * page = [[weixiuViewController alloc] init];
//        page.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:page animated:YES];
        
    }else if (indexPathRow == 3){
//        [self LStoLoveVC];
        self.tabBarController.selectedIndex = 2;
    }

}

-(void)ershoujibuttonDelegatebutton:(UIButton *)sender{
    UsedMachViewController * page = [[UsedMachViewController alloc] init];
    page.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:page animated:YES];
    NSInteger tag = sender.tag;
    switch (tag) {
        case 100:
        {
            // 装载机
        }
            break;
        case 101:
        {
        }
            break;
        case 102:
        {
        }
            break;
        case 103:
        {
        }
            break;
        case 104:
        {
        }
            break;
            
        default:
            break;
    }
}

-(void)leftServericsCollectionViewClick:(UIButton *)sender{
    lookworkViewController * page = [[lookworkViewController alloc] init];
    page.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:page animated:YES];
}

-(void)rightServericsCollectionViewClick:(UIButton *)sender{
    zhaopingViewController * page = [[zhaopingViewController alloc] init];
    page.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:page animated:YES];
}

@end
