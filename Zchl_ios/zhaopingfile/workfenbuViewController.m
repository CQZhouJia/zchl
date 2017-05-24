//
//  workfenbuViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "workfenbuViewController.h"
#import "feileiCell.h"

@interface workfenbuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray * feileArr;

@property (nonatomic,strong)NSArray * myArray;

@end

@implementation workfenbuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    _feileArr = @[@"装载机",@"推土机",@"起重机",@"压路机",@"混泥土及"];
    [self.feileiworktableView tableViewGetFootEmptyView];
    [self initData];
}

-(void)initData{
  
    NSDictionary * dict = @{@"flag":@"0"};
    [ZTHttpTool postWithUrl:@"Common/CategoryQuery" param:dict success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        _myArray = responseObj[@"Data"];
        [self.feileiworktableView reloadData];
    } failure:^(NSError *error) {
        //
    }];
}

- (IBAction)sender:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    feileiCell * cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"feileiCell" owner:self options:nil] lastObject];
    }
//    cell.feileiLabel.text = _feileArr[indexPath.row];
    NSDictionary * dict = _myArray[indexPath.row];
    cell.feileiLabel.text = dict[@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary * dict = _myArray[indexPath.row];
   NSString * proId = dict[@"proId"];
    [_delegate refreshMessage:proId];
    [self.navigationController popViewControllerAnimated:YES];
}







@end
