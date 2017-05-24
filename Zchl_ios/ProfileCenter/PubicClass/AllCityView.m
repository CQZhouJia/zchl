//
//  AllCityView.m
//  LSOnline
//
//  Created by jglx on 17/4/24.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "AllCityView.h"

@interface AllCityView ()<UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,strong)NSArray * proArray;

@property (nonatomic,strong)NSArray * broArray;

@property (nonatomic,strong)UIPickerView * pickerView;

@property (nonatomic,strong)NSString * city; // 城市名字

@property (nonatomic,strong)NSString * cityId;

@property (nonatomic,strong)NSArray * cityArr;

@property (nonatomic,strong)NSString * conuty; // 城市名字

@property (nonatomic,strong)NSString * conutyId;

@property (nonatomic,strong)NSArray * conutyArr;

@property (nonatomic,strong)NSDictionary * countdic;


@end

@implementation AllCityView



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
  
    self.backgroundColor =  Color_RGBA(128, 128, 128, 0.5);
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 300, WIDTH, 300)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 10;
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), 30)];
    titleLabel.text = @"选择地区";
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.textColor = Color_RGBA(143, 143, 143, 1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:titleLabel];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(WIDTH - 60, 0, 60, 30);
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(countyclick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sureBtn];
    
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(backView.frame),CGRectGetHeight(backView.frame) - 30)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource =self;
    [backView addSubview:_pickerView];
    
}

-(void)cancelBtn:(UIButton *)sender{
    [_delegate LSCitycencelBtn:sender];
}

-(void)countyclick:(UIButton *)sender{

    
    if (_countdic.count == 0) {
        _countdic  = _conutyArr[0];
    }
    
    [_delegate LScountySureBtn:sender countyStrdic:_countdic];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _LSSArr.count;
    }else if (component == 1){
        if (_cityArr.count > 0) {
            return _cityArr.count;
        }else{
            return 1;
        }
    }else{
        if (_conutyArr.count > 0) {
            return _conutyArr.count;
        }else{
            return 1;
        }
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return _LSSArr[row][@"title"];
    }else if (component == 1){
       
        _city = _city.length > 0 ? _cityArr[row][@"title"] : @"城市";
        
        return _city;
    }else{
        _conuty = _conuty.length > 0 ? _conutyArr[row][@"title"] : @"县";
        return _conuty;
    }

}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSLog(@"%zd --- %zd",component,row);
    if (component == 0) {
        NSLog(@"%@",_LSSArr[row][@"provinceId"]);
        NSString * pid = _LSSArr[row][@"provinceId"];
        NSDictionary * param = @{@"platform":@"2",@"pId":pid};
        [ZTHttpTool postWithUrl:@"Common/CityQueryByPid" param:param success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if ([responseObj[@"State"] integerValue] == 0) {
                _city = @"success";
                _cityArr = responseObj[@"Data"];
                [_pickerView reloadComponent:1];
                
                if (_cityArr.count == 1) { // 至于一个自动获取区县
                    NSLog(@"%@",_cityArr[0][@"cityId"]);
                    NSString * cid = _cityArr[0][@"cityId"];
                    NSDictionary * param = @{@"platform":@"2",@"cId":cid};
                    NSLog(@"%@",param);
                    [ZTHttpTool postWithUrl:@"Common/DistrictQueryByCId" param:param success:^(id responseObj) {
                        NSLog(@"%@",responseObj);
                        if ([responseObj[@"State"] integerValue] == 0) {
                            _conuty = @"success";
                            _conutyArr = responseObj[@"Data"];
                            [_pickerView reloadComponent:2];
                        }
                    } failure:^(NSError *error) {
                        //
                    }];
                }
            }
        } failure:^(NSError *error) {
            //
        }];
    }else if (component == 1){
       
        if (_cityArr.count == 0) {
            return;
        }
        
        
        NSLog(@"%@",_cityArr[row][@"cityId"]);
        NSString * cid = _cityArr[row][@"cityId"];
        NSDictionary * param = @{@"platform":@"2",@"cId":cid};
        NSLog(@"%@",param);
        [ZTHttpTool postWithUrl:@"Common/DistrictQueryByCId" param:param success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            if ([responseObj[@"State"] integerValue] == 0) {
                _conuty = @"success";
                _conutyArr = responseObj[@"Data"];
                [_pickerView reloadComponent:2];
            }
        } failure:^(NSError *error) {
            //
        }];

        
    }else{
      
        if (_conutyArr.count > 0) {
            _countdic = _conutyArr[row];
        }else{
          
        }
        
    }
}

-(void)setLSSArr:(NSArray *)LSSArr{
    _LSSArr = LSSArr;
    [_pickerView reloadComponent:0];
}

@end
