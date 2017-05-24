//
//  MyorderViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "MyorderViewController.h"
#import "foueCell.h"
#import "headerCell.h"

@interface MyorderViewController ()<UITableViewDelegate,UITableViewDataSource,checkDelegate,phoneDelegate>

@property (nonatomic,strong)UITableView *ordertableView;

@property (nonatomic,strong)headerCell * headerView;

@property (nonatomic,strong)NSArray * rowArr;

@property (nonatomic,strong)NSMutableArray * headerArr;

@property (nonatomic,strong)NSMutableArray * myArray;

@end

@implementation MyorderViewController


- (IBAction)buttonBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _rowArr = @[@"1.支付定金",@"2.预约看车",@"3.支付尾款",@"4.售后服务"];
//    NSNumber *  num = [NSNumber numberWithBool:NO];
//    _headerArr = [NSMutableArray arrayWithObjects:@"1",@"1", nil];
    
    _headerArr = [NSMutableArray array];
    
    _ordertableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH , HEIGHT - 64) style:UITableViewStylePlain];
    _ordertableView.delegate = self;
    _ordertableView.dataSource = self;
    _ordertableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_ordertableView tableViewGetFootEmptyView];
    [self.view addSubview:_ordertableView];
    
    [self initData];
}

-(void)initData{
    
    _myArray = [NSMutableArray array];
    [self initTableViewRefresh:_ordertableView Url:@"UserCenter/MyOrders" array:_myArray controller:self];
    [_ordertableView.mj_header beginRefreshing];
    
}


-(void)initTableViewRefresh:(UITableView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller{
    static int i=1;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        i=1;
        // 进入刷新状态后会自动调用这个block
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        NSDictionary * dcit =@{@"platform":@"2",@"uid":storage.userID,@"phone":storage.loginPhone,@"token":storage.token,@"pn":@"1",@"rows":@"10"};//
        [ZTHttpTool postWithUrl:url param:dcit success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"%@",responseObj[@"Msg"]);
            [myTableView.mj_header endRefreshing];
            if ([responseObj[@"State"] integerValue] == 0) {
                NSArray * dict = responseObj[@"Data"];
               
                if ([dict count]!=0) {
                    [array removeAllObjects];
                    [array addObjectsFromArray: dict];
                     [_headerArr removeAllObjects];
                    for (NSInteger i = 0; i < array.count; i ++) {
                        [_headerArr addObject:@"1"];
                    }
                    [myTableView reloadData];
                }else{
                    //                    [controller showHint:@"没有数据~"];
                    [array removeAllObjects];
                     [_headerArr removeAllObjects];
                    [myTableView reloadData];
                }
            }else if ([responseObj[@"State"] integerValue] == 1){
                //                [controller showHint:responseObj[@"Msg"]];
                [array removeAllObjects];
                 [_headerArr removeAllObjects];
                [myTableView reloadData];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [array removeAllObjects];
            [myTableView reloadData];
            [myTableView.mj_header endRefreshing];
        }];
    }];
    NSMutableArray * myRefreshArray = [[NSMutableArray alloc]init];
    for (int i=1; i<=8; i++) {
        NSString * str = [NSString stringWithFormat:@"cloud_%d",i];
        [myRefreshArray addObject:[UIImage imageNamed:str]];
    }
    // 设置普通状态的动画图片
    [header setImages:myRefreshArray forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:myRefreshArray forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:myRefreshArray forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 设置header
    myTableView.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        i++;
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        NSDictionary * dcit =@{@"platform":@"2",@"uid":storage.userID,@"phone":storage.loginPhone,@"token":storage.token,@"pn":[NSString stringWithFormat:@"%zd",i],@"rows":@"10"};
        [ZTHttpTool postWithUrl:url param:dcit success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"%@",responseObj[@"Msg"]);
            [myTableView.mj_footer endRefreshing];
            if ([responseObj[@"State"] integerValue] == 0) {
                NSArray * dict = responseObj[@"Data"];
                if ([dict count]!=0) {
                    [array addObjectsFromArray: dict];
                      [_headerArr removeAllObjects];
                    for (NSInteger i = 0; i < array.count; i ++) {
                        [_headerArr addObject:@"1"];
                    }
                    [myTableView reloadData];
                    i++;
                }else{
                    //                    [controller showHint:@"没有更多数据"];
                }
            }else if ([responseObj[@"State"] integerValue] == 1){
                //                [controller showHint:responseObj[@"Msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [myTableView.mj_footer endRefreshing];
        }];
    }];
    // 设置普通状态的动画图片
    [footer setImages:myRefreshArray forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [footer setImages:myRefreshArray forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:myRefreshArray forState:MJRefreshStateRefreshing];
    // 隐藏状态
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    // 设置footer
    myTableView.mj_footer = footer;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return _myArray.count;
//    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([_headerArr[section] integerValue] == 1) {
        return 0;
    }else{
        return 4;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    foueCell * cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"foueCell" owner:self options:nil] lastObject];
    }
    cell.delegate = self;
    cell.namelabel.text = _rowArr[indexPath.row];
    cell.phonebtn.tag = 900 + indexPath.section;
    return cell;
}

-(void)buttonphoneDelegate:(UIButton *)sender{
    NSDictionary * dic = _myArray[sender.tag - 900];
    NSString * phone = dic[@"phone"];
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _headerView = [[[NSBundle mainBundle] loadNibNamed:@"headerCell" owner:self options:nil] lastObject];
    _headerView.delegate = self;
    _headerView.btnClick.tag = 300 + section;
    
    
//    @property (weak, nonatomic) IBOutlet UIImageView *logo;
//    
//    
//    @property (weak, nonatomic) IBOutlet UILabel *name;
//    
//    @property (weak, nonatomic) IBOutlet UIButton *btnClick;
    
    NSDictionary * dic = _myArray[section];
    [_headerView.logo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dic[@"staticHttpUrl"],dic[@"img"]]] placeholderImage:[UIImage imageNamed:DefaultPictue]];
    _headerView.name.text = dic[@"title"];
    
    return _headerView;
}

-(void)lookButtonDelegate:(UIButton *)sender{
    for (NSInteger i = 0; i < _headerArr.count; i ++) {
        NSString * str = _headerArr[i];
        if (i == sender.tag - 300) {
            if ([str integerValue] == 1) {
                [_headerArr replaceObjectAtIndex:i withObject:@"0"];
            }else{
                [_headerArr replaceObjectAtIndex:i withObject:@"1"];
            }
        }
    }
    [_ordertableView reloadData];
    NSLog(@"123");
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}



@end
