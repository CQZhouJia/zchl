//
//  PartWorkViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "PartWorkViewController.h"
#import "parkworkCell.h"

@interface PartWorkViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PartWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.parktableView tableViewGetFootEmptyView];
}

- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    parkworkCell * cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"parkworkCell" owner:self options:nil] lastObject];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
