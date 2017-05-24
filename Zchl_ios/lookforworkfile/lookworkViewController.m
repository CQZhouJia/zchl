//
//  lookworkViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/4/28.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "lookworkViewController.h"
#import "looworkCell.h"
#import "driveMessageViewController.h"

@interface lookworkViewController ()<UITableViewDelegate,UITableViewDataSource,rightButtondelegatelook>

@property (nonatomic,strong)NSMutableArray * myArray;

@end

@implementation lookworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.lookworktableView tableViewGetFootEmptyView];
    _myArray = [NSMutableArray array];
    
    [StorageUserInfromation initTableViewRefresh:_lookworktableView Url:@"Driver/Hire" array:_myArray controller:self];
    [_lookworktableView.mj_header beginRefreshing];
}

- (IBAction)buttonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    looworkCell * cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"looworkCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.checkbutton.tag = 400 + indexPath.row;
    
    
    NSDictionary * dict = _myArray[indexPath.row];
    [cell.logoimage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"staticHttpUrl"],dict[@"img"]]] placeholderImage:[UIImage imageNamed:DefaultPictue]];
    NSString * time = [NSString stringWithFormat:@"%@",dict[@"time"]];
    cell.phoneLabel.text = [NSString stringWithFormat:@"%@",dict[@"phone"]];
    cell.timelabel.text = [time substringWithRange:NSMakeRange(0, 10)];

    if ([dict[@"typeName"] isKindOfClass:[NSString class]]) {
       cell.jiqilabel.text = dict[@"typeName"];
    }else{
        cell.jiqilabel.text = @"推土机";
    }
    cell.localabel.text = dict[@"city"];
    
    
//    NSString *time = [NSString stringWithFormat:@"%@",dict[@"time"]];
//    ((JGMyNeiborhoodGroupTableViewCell *)cell).time.text =[time substringWithRange:NSMakeRange(0, 10)];
    return cell;

}

-(void)rightbuttondelegate:(UIButton *)sender{
    NSDictionary * dict = _myArray[sender.tag - 400];
    driveMessageViewController * messVC = [[driveMessageViewController alloc] init];
    messVC.uid = dict[@"id"];
    [self.navigationController pushViewController:messVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

@end
