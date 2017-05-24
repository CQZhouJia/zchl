//
//  jianliBoomView.m
//  Zchl_ios
//
//  Created by jglx on 17/5/5.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "jianliBoomView.h"

@interface jianliBoomView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UILabel * titleLabel;

@property (nonatomic,strong) NSString * rowStr;

@property (nonatomic,assign) NSInteger rowNumber;

@end

@implementation jianliBoomView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
       
    self.backgroundColor =  Color_RGBA(128, 128, 128, 0.5);
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 200, WIDTH, 300)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 10;
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(backView.frame), 30)];
    _titleLabel.text = _titleStr;
    _titleLabel.font = [UIFont systemFontOfSize:14.f];
    _titleLabel.textColor = [UIColor orangeColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:_titleLabel];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:btn];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(WIDTH - 60, 0, 60, 30);
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(countyclick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:sureBtn];
    
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(backView.frame),CGRectGetHeight(backView.frame) - 30)];
    _pickerView.showsSelectionIndicator = YES;
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [backView addSubview:_pickerView];
    

}


-(void)cancelBtn:(UIButton *)sender{
    [_delegate LSCitycencelBtn:sender];
}

-(void)countyclick:(UIButton *)sender{
    if (_rowStr.length == 0) {
        if (_flag == 8) {
            _rowStr = _Arr[4];
        }
        if (_flag == 9) {
            _rowStr = _Arr[0];
        }
        
        if (_flag == 11) {
            _rowStr = _Arr[0];
            _rowNumber = 0;
        }
        
        if (_flag == 12) {
            _rowStr = _Arr[0];
        }
        
        if (_flag == 13) {
            _rowStr = _Arr[0];
        }
    }
    [_delegate LScountySureBtn:sender countyStrdic:_rowStr andflag:_flag categoryId:_rowNumber];
}



-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _Arr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _Arr[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _rowStr = _Arr[row];
}

-(void)setArr:(NSArray *)Arr{
    _Arr = Arr;
    [_pickerView reloadAllComponents];
}

-(void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    _titleLabel.text = _titleStr;
}

-(void)setFlag:(NSInteger)flag{
    _flag = flag;
    if (_flag == 8) {
        [_pickerView selectRow:4 inComponent:0 animated:YES];
    }
}
@end
