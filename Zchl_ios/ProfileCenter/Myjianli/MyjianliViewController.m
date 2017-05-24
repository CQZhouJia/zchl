//
//  MyjianliViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/5/3.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "MyjianliViewController.h"
#import "JLModel.h"
#import "jianlioneCell.h"
#import "jiantwoCell.h"
#import "MjianthreeCell.h"
#import "jianliBoomView.h"

@interface MyjianliViewController ()<UITableViewDelegate,UITableViewDataSource,JLcityDelegatecheck,UITextFieldDelegate>

@property (nonatomic,strong)NSArray * leftArr;

@property (nonatomic,strong)NSArray * rightArr;

@property (nonatomic,strong)UITextField * ageTextfield;

@property (nonatomic,strong)UITextField * workTextfield;

@property (nonatomic,strong)UITextField * addressText;

@property (nonatomic,strong)UITextField * linkPhoneText;

@property (nonatomic,strong)UITextField * emailtext;

@property (nonatomic,strong)jianliBoomView * jboomView;


@property (nonatomic,strong)NSString * salaryStr; // 工资

@property (nonatomic,strong)UITextField * exceptCityText;

@property (nonatomic,strong)NSString * pappersStr; // 有无操作证

@property (nonatomic,strong)NSString * exceptCityStr; // 期望工作地点\

@property (nonatomic,strong)NSString * categoryId;

@property (nonatomic,strong)NSString * categoryName;

@property (nonatomic,strong)NSArray * dataArr;

@property (nonatomic,strong)NSMutableDictionary * muDic;

@property (nonatomic,strong)NSString * overtimeStr;


@property (nonatomic,strong)NSString * traineeStr;


@property (nonatomic,strong)NSDictionary * mainDict;

@property (nonatomic,strong)JLModel *model;


//@property (nonatomic,strong)NSMutableDictionary * 

@end

@implementation MyjianliViewController


- (IBAction)backBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.jianlitableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _leftArr = @[@"期望工资:",@"有无操作:",@"期望地点:",@"驾驶车型:",@"是否接受加班:",@"是否接受带徒弟:",@"能否对车辆进行日常的维修和保养:"];
    
    _rightArr = @[@"7000/月",@"有",@"重庆",@"装载机",@"是",@"是",@"是"];
    
    
    
    [self initData];
}

- (IBAction)boomBtn:(UIButton *)sender {
    
    NSLog(@"%@",_model.age);
    NSLog(@"%@",_model.workExperience);
    NSLog(@"%@",_model.address);
    NSLog(@"%@",_model.linkPhone);
    NSLog(@"%@",_model.email);
    NSLog(@"%@",_model.exceptCity);
    
    if (_model.age.length == 0) {
        [self showHint:@"请填写年龄"];
        return;
    }
    
    if (_model.workExperience.length == 0) {
        [self showTextHUD:@"请填写工作经验"];
        return;
    }
    
    if (_model.address.length == 0) {
       [self showHint:@"请填写工作地址"];
        return;
    }
    
    if (_model.linkPhone.length == 0) {
        [self showHint:@"请填写联系方式"];
        return;
    }
    
    if (_model.email.length == 0) {
        [self showHint:@"请填写邮箱"];
        return;
    }
    if (_model.exceptCity.length == 0) {
        [self showHint:@"请填写期望工作地点"];
        return;
    }
    
        NSLog(@"%@ -- %@ -- %@ -- %@ -- %@ -- %@ -- %@ -- %@ -- %@ -- %@",_model.age,_model.workExperience,_model.address,_model.linkPhone,_model.email,_model.exceptCity,_model.categoryName,_model.categoryId,_model.overtimeStr,_model.trainee);
    
    NSDictionary * param = @{@"age":_model.age,@"workExperience":_model.workExperience,@"address":_model.address,@"linkPhone":_model.linkPhone,@"email":_model.email,@"salary":_salaryStr,@"pappers":_pappersStr,@"exceptCity":_model.exceptCity,@"categoryId":_model.categoryId,@"categoryName":_model.categoryName,@"overtime":_model.overtimeStr,@"trainee":_model.trainee};
    NSLog(@"%@",param);
    
    [ZTHttpTool postWithUrl:@"UserCenter/EditResume" param:param success:^(id responseObj) {
        //
        NSLog(@"%@",responseObj);
          NSLog(@"%@",responseObj[@"Msg"]);
        if ([responseObj[@"State"] integerValue] == 0) {
            [self showTextHUD:@"成功"];
        }else{
            [self showHint:@"失败"];
        }
    } failure:^(NSError *error) {
        //
        NSLog(@"%zd",error.code);
    }];
}

-(void)initData{
    
    [ZTHttpTool postWithUrl:@"UserCenter/Resume" param:@{} success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        _mainDict = responseObj[@"Data"];
        _categoryName = [NSString stringWithFormat:@"%@",_mainDict[@"categoryName"]];
        _categoryId = [NSString stringWithFormat:@"%@",_mainDict[@"categoryId"]];
         _overtimeStr = _mainDict[@"overtime"];
        _traineeStr = _mainDict[@"trainee"];
        
        _model = [[JLModel alloc] init];
        _model.age = [NSString stringWithFormat:@"%@",_mainDict[@"age"]];
        _model.workExperience = [NSString stringWithFormat:@"%@",_mainDict[@"workExperience"]];
        _model.address = _mainDict[@"address"];
        _model.linkPhone = [NSString stringWithFormat:@"%@",_mainDict[@"linkPhone"]];
        _model.email = _mainDict[@"email"];
        _model.exceptCity = _mainDict[@"exceptCity"];
        
        _model.categoryName = _mainDict[@"categoryName"];
        _model.categoryId = [NSString stringWithFormat:@"%@",_mainDict[@"categoryId"]];
        _model.overtimeStr = _mainDict[@"overtime"];
        _model.trainee = _mainDict[@"trainee"];
        
        NSLog(@"%@ -- %@ -- %@ -- %@ -- %@ -- %@ -- %@ -- %@ -- %@ -- %@",_model.age,_model.workExperience,_model.address,_model.linkPhone,_model.email,_model.exceptCity,_model.categoryName,_model.categoryId,_model.overtimeStr,_model.trainee);
        
        [self.jianlitableView reloadData];
    } failure:^(NSError *error) {
        //
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        jianlioneCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"jianlioneCell" owner:self options:nil] lastObject];
        cell.leftlabel.text = @"基本信息";
        return cell;
    }else if (indexPath.row == 1){
        jiantwoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"jiantwoCell" owner:self options:nil] lastObject];
        cell.leftlabel.text = @"年龄:";
        cell.rightlabel.text = @"岁";
        
       CGRect rect =  [self getStrHeight:@"年龄:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;

        cell.righttextfield.delegate = self;
        cell.righttextfield.tag = indexPath.row;
        cell.righttextfield.text = [NSString stringWithFormat:@"%@",_model.age];
        
        NSLog(@"%@", [NSString stringWithFormat:@"%@",_mainDict[@"age"]]);
        
        return cell;
    }else if (indexPath.row == 2){
        jiantwoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"jiantwoCell" owner:self options:nil] lastObject];
        cell.leftlabel.text = @"工作经验:";
        cell.rightlabel.text = @"年";
        
        CGRect rect =  [self getStrHeight:@"工作经验:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        cell.righttextfield.text = [NSString stringWithFormat:@"%@",_model.workExperience];
        cell.righttextfield.tag = indexPath.row;
        cell.righttextfield.delegate = self;
        
        return cell;
    }else if (indexPath.row == 3){
    

        jiantwoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"jiantwoCell" owner:self options:nil] lastObject];
        cell.leftlabel.text = @"工作地址:";
        cell.rightlabel.hidden = YES;
        
        CGRect rect =  [self getStrHeight:@"工作地址:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        
        CGRect recttext =  [self getStrHeight:@"重庆市江北区" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.textwidth.constant = recttext.size.width + 10;
        cell.righttextfield.text = @"重庆市江北区";
        cell.righttextfield.text = [NSString stringWithFormat:@"%@",_model.address];
        cell.righttextfield.delegate = self;
        cell.righttextfield.tag = indexPath.row;
  
        return cell;
    }else if (indexPath.row == 4){
    
        jianlioneCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"jianlioneCell" owner:self options:nil] lastObject];
        cell.leftlabel.text = @"联系方式";
        return cell;
    }else if (indexPath.row == 5){
        jiantwoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"jiantwoCell" owner:self options:nil] lastObject];
        cell.leftlabel.text = @"电话:";
        cell.rightlabel.hidden = YES;
        
        CGRect rect =  [self getStrHeight:@"电话:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        
         CGRect recttext =  [self getStrHeight:@"13656321523" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.textwidth.constant = recttext.size.width + 10;
        cell.righttextfield.text = @"13656321523";
        NSLog(@"%@",_model.linkPhone);
        cell.righttextfield.text = [NSString stringWithFormat:@"%@",_model.linkPhone];
        cell.righttextfield.delegate = self;
        cell.righttextfield.tag = indexPath.row;
        
        return cell;
    
    }else if (indexPath.row == 6){
      
        jiantwoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"jiantwoCell" owner:self options:nil] lastObject];
        cell.leftlabel.text = @"邮箱:";
        cell.rightlabel.hidden = YES;
        
        CGRect rect =  [self getStrHeight:@"邮箱:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        
        CGRect recttext =  [self getStrHeight:@"13656321523@qq.com" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.textwidth.constant = recttext.size.width + 10;
        cell.righttextfield.text = @"13656321523@qq.com";
        cell.righttextfield.text = [NSString stringWithFormat:@"%@",_model.email];
        cell.righttextfield.delegate = self;
        cell.righttextfield.tag = indexPath.row;
        
        return cell;
    
    }else if (indexPath.row == 7){
        jianlioneCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"jianlioneCell" owner:self options:nil] lastObject];
        cell.leftlabel.text = @"求职意向";
        return cell;
        
    }else if (indexPath.row == 8){
    
        MjianthreeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MjianthreeCell" owner:self options:nil] lastObject];
//        cell.leftlabel.text = _leftArr[indexPath.row - 8];
        cell.leftlabel.text = @"期望工资:";
        CGRect rect =  [self getStrHeight:@"期望工资:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        cell.rightlabel.text = _rightArr[indexPath.row - 8];
//        cell.rightlabel.text = @"7000元";
        _salaryStr = _mainDict[@"salary"];
        cell.rightlabel.text = _salaryStr;
        return cell;
        
    }else if (indexPath.row == 9){
        MjianthreeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MjianthreeCell" owner:self options:nil] lastObject];
        //        cell.leftlabel.text = _leftArr[indexPath.row - 8];
        cell.leftlabel.text = @"有无操作证:";
        CGRect rect =  [self getStrHeight:@"有无操作证:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        cell.rightlabel.text = _rightArr[indexPath.row - 8];
//        cell.rightlabel.text = @"有";
        _pappersStr = _mainDict[@"pappers"];
        cell.rightlabel.text = _pappersStr;
        
        return cell;
    }else if (indexPath.row == 10){
 
        jiantwoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"jiantwoCell" owner:self options:nil] lastObject];
        cell.leftlabel.text = @"期望地点:";
        cell.rightlabel.hidden = YES;
        
        CGRect rect =  [self getStrHeight:@"期望地点:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        
        CGRect recttext =  [self getStrHeight:@"重庆江北国际机场附近" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.textwidth.constant = recttext.size.width + 10;
        cell.righttextfield.text = @"重庆";
        cell.righttextfield.text = [NSString stringWithFormat:@"%@",_model.exceptCity];
        cell.righttextfield.delegate = self;
        cell.righttextfield.tag = indexPath.row;
        
        return cell;
    }else if (indexPath.row == 11){
        MjianthreeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MjianthreeCell" owner:self options:nil] lastObject];
        //        cell.leftlabel.text = _leftArr[indexPath.row - 8];
        cell.leftlabel.text = @"驾驶车型:";
        CGRect rect =  [self getStrHeight:@"驾驶车型:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        cell.rightlabel.text = _rightArr[indexPath.row - 8];
//        cell.rightlabel.text = @"无敌大机器";
        _categoryName = [NSString stringWithFormat:@"%@",_model.categoryName];
        _categoryId = [NSString stringWithFormat:@"%@",_mainDict[@"categoryId"]];
        NSLog(@"%@",[NSString stringWithFormat:@"%@",_mainDict[@"categoryId"]]);
        cell.rightlabel.text = _categoryName;
        
        return cell;

      
    }else if (indexPath.row == 12){
        MjianthreeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MjianthreeCell" owner:self options:nil] lastObject];
        //        cell.leftlabel.text = _leftArr[indexPath.row - 8];
        cell.leftlabel.text = @"是否接受加班:";
        CGRect rect =  [self getStrHeight:@"是否接受加班:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        cell.rightlabel.text = _rightArr[indexPath.row - 8];
//        cell.rightlabel.text = @"是";
        _overtimeStr = [NSString stringWithFormat:@"%@",_model.overtimeStr];
        cell.rightlabel.text = _overtimeStr;
        
        return cell;
    }else if (indexPath.row == 13){
        MjianthreeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MjianthreeCell" owner:self options:nil] lastObject];
        //        cell.leftlabel.text = _leftArr[indexPath.row - 8];
        cell.leftlabel.text = @"是否带徒弟:";
        CGRect rect =  [self getStrHeight:@"是否带徒弟:" size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
        cell.rightlabel.text = _rightArr[indexPath.row - 8];
        cell.rightlabel.text = @"否";
        _traineeStr = [NSString stringWithFormat:@"%@",_model.trainee];
        cell.rightlabel.text = _traineeStr;
        
        return cell;

      
    }
    else{
        MjianthreeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"MjianthreeCell" owner:self options:nil] lastObject];
//        cell.leftlabel.text = _leftArr[indexPath.row - 8];
        CGRect rect =  [self getStrHeight:_leftArr[indexPath.row - 8] size:CGSizeMake(MAXFLOAT, 20) strfont:[UIFont systemFontOfSize:14]];
        cell.leftlabelwidth.constant = rect.size.width + 5;
//        cell.rightlabel.text = _rightArr[indexPath.row - 8];
        
        return cell;

    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    NSLog(@"%zd",textField.tag);
    
    if (textField.tag == 1) {
        _model.age = textField.text;
    }else if (textField.tag == 2){
        _model.workExperience = textField.text;
    }else if (textField.tag == 3){
        _model.address = textField.text;
    }else if (textField.tag == 5){
        _model.linkPhone = textField.text;
    }else if (textField.tag == 6){
        _model.email = textField.text;
    }else{
        _model.exceptCity = textField.text;
    }
    
     NSIndexPath * indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
        [self.jianlitableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [textField endEditing:YES];
    
    return YES;

}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%@",textField.text);
    NSLog(@"%zd",textField.tag);
    
    if (textField.tag == 1) {
        _model.age = textField.text;
    }else if (textField.tag == 2){
        _model.workExperience = textField.text;
    }else if (textField.tag == 3){
        _model.address = textField.text;
    }else if (textField.tag == 5){
        _model.linkPhone = textField.text;
    }else if (textField.tag == 6){
        _model.email = textField.text;
    }else{
        _model.exceptCity = textField.text;
    }
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
    [self.jianlitableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [textField endEditing:YES];
    



}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 8) {
        //
        _jboomView = [[jianliBoomView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _jboomView.titleStr = @"期望工资";
        _jboomView.Arr = @[@"1000元",@"2000元",@"3000元",@"4000元",@"5000元",@"6000元",@"7000元",@"8000元",@"9000元",@"10000元",@"11000元"];
        _jboomView.flag = indexPath.row;
        _jboomView.delegate = self;
        [self.view addSubview:_jboomView];
    }
    if (indexPath.row == 9) {
        //
        _jboomView = [[jianliBoomView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _jboomView.titleStr = @"有无操作证:";
        _jboomView.Arr = @[@"有",@"无"];
        _jboomView.flag = indexPath.row;
        _jboomView.delegate = self;
        [self.view addSubview:_jboomView];
    }
    
    if (indexPath.row == 11) {
        //
        
        NSDictionary * param = @{@"flag":@"0"};
        [ZTHttpTool postWithUrl:@"Common/CategoryQuery" param:param success:^(id responseObj) {
            //
            NSLog(@"%@",responseObj);

            _jboomView = [[jianliBoomView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            _jboomView.titleStr = @"驾驶车型:";
//            _jboomView.Arr = @[@"起重机",@"推土机",@"装载机"];

            
            NSMutableArray * muArr = [NSMutableArray array];
            _muDic = [[NSMutableDictionary alloc] init];
            NSArray * Arr = responseObj[@"Data"];
            _dataArr = Arr;
            for (NSInteger i = 0; i < Arr.count; i ++) {
                NSDictionary * dic = Arr[i];
                NSLog(@"%@",dic[@"proId"]);
                NSLog(@"%@",dic[@"title"]);
                [_muDic setObject:dic[@"proId"] forKey:dic[@"title"]];
                [muArr addObject:dic[@"title"]];
            }
            
            _jboomView.Arr = muArr;
            
            _jboomView.flag = indexPath.row;
            _jboomView.delegate = self;
            [self.view addSubview:_jboomView];
            
        } failure:^(NSError *error) {
            //
        }];
    }
    
    if (indexPath.row == 12) {
        //
        _jboomView = [[jianliBoomView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _jboomView.titleStr = @"是否接受加班:";
        _jboomView.Arr = @[@"是",@"否"];
        _jboomView.flag = indexPath.row;
        _jboomView.delegate = self;
        [self.view addSubview:_jboomView];
    }
    
    if (indexPath.row == 13) {
        _jboomView = [[jianliBoomView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _jboomView.titleStr = @"是否带徒弟:";
        _jboomView.Arr = @[@"是",@"否"];
        _jboomView.flag = indexPath.row;
        _jboomView.delegate = self;
        [self.view addSubview:_jboomView];
    }
  
}

-(void)LSCitycencelBtn:(UIButton *)sender{
    [_jboomView removeFromSuperview];
}

-(void)LScountySureBtn:(UIButton *)sender countyStrdic:(NSString *)str andflag:(NSInteger)flag categoryId:(NSInteger)categoryId{
    [_jboomView removeFromSuperview];
    NSLog(@"%@",str);
    if (flag == 8) {
        _salaryStr = str;
        NSIndexPath * index = [NSIndexPath indexPathForRow:8 inSection:0];
//        MjianthreeCell * cell = [self.jianlitableView cellForRowAtIndexPath:index];
//        cell.leftlabel.text = str;
//        [self.jianlitableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];
        
        MjianthreeCell * cell = [self.jianlitableView cellForRowAtIndexPath:index];
        cell.rightlabel.text = str;
    }
    if (flag == 9) {
        _pappersStr = str;
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:flag inSection:0];
        MjianthreeCell * cell = [self.jianlitableView cellForRowAtIndexPath:index];
        cell.rightlabel.text = str;
    }
    if (flag == 11) {
        _categoryId = [_muDic objectForKey:str];
        _categoryName = str;
        _model.categoryName = str;
        _model.categoryId = _categoryId;
        
        NSLog(@"%@ --- %@", _categoryName,_categoryId);
//        NSIndexPath * index = [NSIndexPath indexPathWithIndex:11];
//        MjianthreeCell * cell = [self.jianlitableView cellForRowAtIndexPath:index];
//        cell.leftlabel.text = str;
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:flag inSection:0];
        MjianthreeCell * cell = [self.jianlitableView cellForRowAtIndexPath:index];
         cell.rightlabel.text = str;
    }
    
    if (flag == 12) {
        //
        _overtimeStr = str;
        _model.overtimeStr = str;
        NSIndexPath * index = [NSIndexPath indexPathForRow:flag inSection:0];
        MjianthreeCell * cell = [self.jianlitableView cellForRowAtIndexPath:index];
        cell.rightlabel.text = _model.overtimeStr;
    }
    
    if (flag == 13) {
        //
        _traineeStr = str;
        _model.trainee = str;
        NSIndexPath * index = [NSIndexPath indexPathForRow:flag inSection:0];
        MjianthreeCell * cell = [self.jianlitableView cellForRowAtIndexPath:index];
        cell.rightlabel.text = _model.trainee;
    }
    
//    [self.jianlitableView reloadData];
}

@end
