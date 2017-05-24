//
//  workdetailController.m
//  Zchl_ios
//
//  Created by jglx on 17/5/3.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "workdetailController.h"
#import "workOneCell.h"
#import "worktwoCell.h"
#import "workthreeCell.h"
#import "workfourCell.h"
#import "workfiveCell.h"
#import "workSixCell.h"

@interface workdetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSDictionary * param;

@end

@implementation workdetailController


- (IBAction)backbutton:(UIButton *)sender {
   [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftbutton:(UIButton *)sender {
    
    NSString * phoneLine = _param[@"linkPhone"];
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",phoneLine];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}



- (IBAction)rightbutton:(UIButton *)sender {
    NSString * jianliId = _param[@"id"];
    NSDictionary * param = @{@"proId":jianliId};
    [ZTHttpTool postWithUrl:@"Job/Send" param:param success:^(id responseObj) {
        //
        NSLog(@"%@",responseObj);
        if ([responseObj[@"State"] integerValue] == 0) {
            [self showTextHUD:@"简历投递成功"];
        }else{
           [self showTextHUD:@"简历投递失败"];
        }
    } failure:^(NSError *error) {
        //
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.worktableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.worktableView tableViewGetFootEmptyView];
    self.boomleft.layer.borderWidth = 1;
    self.boomleft.layer.borderColor = Color_RGBA(128, 224, 227, 1.0).CGColor;
    self.boomleft.layer.cornerRadius = 5;
    
    self.boomright.layer.borderWidth = 1;
    self.boomright.layer.borderColor = Color_RGBA(128, 224, 227, 1.0).CGColor;
    self.boomright.layer.cornerRadius = 5;
    [self initData];
}

-(void)initData{
    NSDictionary * dict = @{@"proId":_proId};
    [ZTHttpTool postWithUrl:@"Job/Show" param:dict success:^(id responseObj) {
        //
        NSLog(@"%@",responseObj);
        _param = responseObj[@"Data"];
        [_worktableView reloadData];
    } failure:^(NSError *error) {
        //
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        workOneCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"workOneCell" owner:self options:nil] lastObject];
        cell.nameLabe.text = _param[@"title"];
        cell.money.text = _param[@"salary"];
        return cell;
    }else if (indexPath.row == 1){
        worktwoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"worktwoCell" owner:self options:nil] lastObject];
        cell.workAge.text = _param[@"workAge"];
        cell.count.text = [NSString stringWithFormat:@"%zd",[_param[@"count"] integerValue]];
        cell.education.text = _param[@"education"];
        cell.agelabel.text = _param[@"age"];
        if ([_param[@"sex"] integerValue] == 0) {
            cell.sexLabel.text = @"女";
        }else if ([_param[@"sex"] integerValue] == 1){
            cell.sexLabel.text = @"男";
        }else{
           cell.sexLabel.text = @"不限";
        }
        return cell;
    }else if (indexPath.row == 2){
       
        workthreeCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"workthreeCell" owner:self options:nil] lastObject];
        return cell;
    }else if (indexPath.row == 3){
    
        workfourCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"workfourCell" owner:self options:nil] lastObject];
        cell.comname.text = _param[@"companyName"];
        cell.comIndustry.text = _param[@"companyIndustry"];
        cell.comScale.text = _param[@"companyScale"];
        return cell;
    }else if (indexPath.row == 4){
    
        workfiveCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"workfiveCell" owner:self options:nil] lastObject];
        cell.responsiLabel.text = _param[@"responsibility"];
        return cell;
    }else if (indexPath.row == 5){
    
        workSixCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"workSixCell" owner:self options:nil] lastObject];
        cell.elseTip.text = _param[@"elseTip"];
        return cell;
    }else {
        worktwoCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"worktwoCell" owner:self options:nil] lastObject];
        return cell;
    }
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 60;
    }else if (indexPath.row == 1){
        return 70;
    }else if (indexPath.row == 2){
        
        return 70;
    }else if (indexPath.row == 3){
        
        return 95;
    }else if (indexPath.row == 4){
        
        return 80;
//        return 110;
    }else if (indexPath.row == 5){
        
        return 50;
//        return 95;
    }else {
        return 0;
    }

}


@end
