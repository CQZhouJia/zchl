//
//  zhaopingViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/4/28.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "zhaopingViewController.h"
#import "workfenbuViewController.h"
#import "mainboomCell.h"
#import "PartWorkViewController.h"
#import "searchViewController.h"
#import "workdetailController.h"

@interface zhaopingViewController ()<UITableViewDelegate,UITableViewDataSource,backDelegate,gaojibackDelegate>

@property (nonatomic,strong)UITableView * tableView;

@property (nonatomic,strong)NSMutableArray * myArray;

@property (nonatomic,strong)NSString * areaCode;

@property (nonatomic,strong)NSString * typeId;

@property (nonatomic,strong)NSString * titleStr;

@property (nonatomic,strong)NSString * minSalary;

@property (nonatomic,strong)NSString * maxSalary;

@end

@implementation zhaopingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTopView];
    [self initCollView];
   
    _myArray = [NSMutableArray array];
    
    _areaCode = @"";
    _typeId = @"0";
    _titleStr = @"";
    _minSalary = @"-1";
    _maxSalary = @"-1";
    
    [self initTableViewRefresh:_tableView Url:@"Job/Index" array:_myArray controller:self];
    [self.tableView.mj_header beginRefreshing];
}

- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTopView{

    NSArray * arr = @[@"zhiweifenlei",@"search"];
    NSArray * titArr = @[@"职位分类",@"高级搜索"];
    for (NSInteger i = 0; i < arr.count; i ++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(40 + i * (WIDTH - 80 - 2 * 71 + 71),64, 71, 83);
        [btn setImage:[UIImage imageNamed:arr[i]] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        btn.tag = 100 + i;
        [self.view addSubview:btn];
        
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(40 + i * (WIDTH - 80 - 2 * 71 + 71), CGRectGetMaxY(btn.frame) - 10, CGRectGetWidth(btn.frame), 25)];
        titlelabel.text  = titArr[i];
        titlelabel.textColor = [UIColor blackColor];
        [self.view addSubview:titlelabel];
        titlelabel.textAlignment = NSTextAlignmentCenter;
        titlelabel.font = [UIFont systemFontOfSize:14];
    }
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 64 + 71 + 30, WIDTH, 5)];
    lineView.backgroundColor = Color_RGBA(183, 183, 183, 1.0);
    [self.view addSubview:lineView];
}


-(void)buttonClick:(UIButton *)sender{
    if (sender.tag == 100) {
        //职位分布
        workfenbuViewController * page = [[workfenbuViewController alloc] init];
        page.delegate = self;
        [self.navigationController pushViewController:page animated:YES];
    }
    
    if (sender.tag == 101) {
//        //兼职
//        PartWorkViewController * page = [[PartWorkViewController alloc] init];
//        [self.navigationController pushViewController:page animated:YES];
        
        //高级搜索
        searchViewController * page = [[searchViewController alloc] init];
        page.delegate = self;
        [self.navigationController pushViewController:page animated:YES];
    }
    if (sender.tag == 102) {
//        //高级搜索
//        searchViewController * page = [[searchViewController alloc] init];
//        [self.navigationController pushViewController:page animated:YES];
        
        //兼职
        PartWorkViewController * page = [[PartWorkViewController alloc] init];
        [self.navigationController pushViewController:page animated:YES];
    }
    
}

-(void)refreshMessage:(NSString *)typeId{
    _typeId = typeId;
    [self.tableView.mj_header beginRefreshing];
}


-(void)gaojirefreshMessage:(NSString *)titleStr areaCode:(NSString *)areaCode minSalary:(NSString *)minSalary maxSalary:(NSString *)maxSalary{
    _titleStr = titleStr;
    _areaCode = areaCode;
    _minSalary = minSalary;
    _maxSalary = maxSalary;
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)initTableViewRefresh:(UITableView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller{
    static int i=1;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        i=1;
        // 进入刷新状态后会自动调用这个block
        NSDictionary * dcit =@{@"areaCode":_areaCode,@"typeId":_typeId,@"title":_titleStr,@"minSalary":_minSalary,@"maxSalary":_maxSalary,@"pn":@"1",@"rows":@"10"};
        NSLog(@"%@",dcit);
        [ZTHttpTool postWithUrl:url param:dcit success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"%@",responseObj[@"Msg"]);
            [myTableView.mj_header endRefreshing];
            if ([responseObj[@"State"] integerValue] == 0) {
                NSArray * dict = responseObj[@"Data"];
                if ([dict count]!=0) {
                    [array removeAllObjects];
                    [array addObjectsFromArray: dict];
                    [myTableView reloadData];
                }else{
                    //                    [controller showHint:@"没有数据~"];
                    [array removeAllObjects];
                    [myTableView reloadData];
                }
            }else if ([responseObj[@"State"] integerValue] == 1){
                //                [controller showHint:responseObj[@"Msg"]];
                [array removeAllObjects];
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
       NSDictionary * dcit =@{@"areaCode":_areaCode,@"typeId":_typeId,@"title":_titleStr,@"minSalary":_minSalary,@"maxSalary":_maxSalary,@"pn":@"1",@"rows":@"10"};
    [ZTHttpTool postWithUrl:url param:dcit success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"%@",responseObj[@"Msg"]);
            [myTableView.mj_footer endRefreshing];
            if ([responseObj[@"State"] integerValue] == 0) {
                NSArray * dict = responseObj[@"Data"];
                if ([dict count]!=0) {
                    [array addObjectsFromArray: dict];
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


-(void)initCollView{
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 165, WIDTH, HEIGHT - 165) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView tableViewGetFootEmptyView];
    [self.view addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    mainboomCell * cell;
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"mainboomCell" owner:self options:nil] lastObject];
    }
    NSDictionary * dict = _myArray[indexPath.row];
    cell.namelabel.text = dict[@"typeName"];
    cell.comlabel.text =  dict[@"companyName"];
    cell.citylabel.text =  dict[@"city"];
    cell.pricelabel.text = dict[@"salary"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    workdetailController * page = [[workdetailController alloc] init];
    
    NSDictionary * dict = _myArray[indexPath.row];
    page.proId = dict[@"id"];
    [self.navigationController pushViewController:page animated:YES];
}

@end
