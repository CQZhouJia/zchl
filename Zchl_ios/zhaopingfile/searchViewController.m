//
//  searchViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "searchViewController.h"

@interface searchViewController ()<cityDelegatecheck>

@property (nonatomic,strong)AllCityView * cityView;

@property (nonatomic,strong)NSString * titleStr;

@property (nonatomic,strong)NSString * areaCode;

@property (nonatomic,strong)NSString * minSalary;

@property (nonatomic,strong)NSString * maxSalary;

@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _titleStr = @"";
    _areaCode = @"";
    _minSalary = @"-1";
    _maxSalary = @"-1";
   
}



- (IBAction)buttonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)locationbutton:(UIButton *)sender {
    NSDictionary * param = @{@"platform":@"2"};
    [ZTHttpTool postWithUrl:@"Common/ProvinceQuery" param:param success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        _cityView = [[AllCityView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _cityView.delegate = self;
        _cityView.LSSArr = responseObj[@"Data"];
        [self.view addSubview:_cityView];
    } failure:^(NSError *error) {
        //
    }];
    return;
}
#pragma mark -- 代理 --确定
-(void)LScountySureBtn:(UIButton *)sender countyStrdic:(NSDictionary *)strdic{
    NSLog(@"%@",strdic[@"title"]);
    [_cityView removeFromSuperview];
    NSString * countStr = strdic[@"title"];
    if (countStr.length == 0) {
        NSLog(@"11");
        return;
    }
    NSString * adStr = strdic[@"title"];
    NSLog(@"%@",strdic);
    _areaCode = strdic[@"areaCode"];
    [_locationbutton setTitle:adStr forState:UIControlStateNormal];
}

#pragma mark -- 代理 --取消

-(void)LSCitycencelBtn:(UIButton *)sender{
    [_cityView removeFromSuperview];
}

- (IBAction)searchbutton:(UIButton *)sender {
    
    _titleStr = _nametex.text;
    if (_moneyone.text.length > 0) {
        _minSalary = _moneyone.text;
    }
    
    if (_moneyteo.text.length > 0) {
         _maxSalary = _moneyteo.text;
    }
    
    [_delegate gaojirefreshMessage:_titleStr areaCode:_areaCode minSalary:_minSalary maxSalary:_maxSalary];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
