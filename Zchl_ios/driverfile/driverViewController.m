//
//  driverViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/4/26.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "driverViewController.h"
#import "driveleftCell.h"
#import "driverightCell.h"
#import "driveMessageViewController.h"

#define  WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface driverViewController ()<UITableViewDelegate,UITableViewDataSource,cityDelegatecheck>


@property (nonatomic,strong)UIButton * locationbutton;

@property (nonatomic,strong)UITableView * lefttableView;

@property (nonatomic,strong)UITableView * righttableView;

@property (strong,nonatomic)NSString *currentCityStr; //当前城市

@property (strong,nonatomic)NSMutableArray * ColorModelArr;

@property (strong,nonatomic)NSArray * leftArr;

@property (strong,nonatomic)NSMutableArray * rightArr;

@property (strong,nonatomic)NSString * typeId;

@property (nonatomic,strong)AllCityView * allCityView;

@property (nonatomic,strong)NSString * areaCode;

@end

@implementation driverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
//    WS(ws);
//    UIView * sv = [[UIView alloc] init];
//    [self.view addSubview:sv];
//    sv.backgroundColor = [UIColor blackColor];
//    [sv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(ws.view);
//        make.size.mas_equalTo(CGSizeMake(300, 300));
//    }];
   
    
    _ColorModelArr = [NSMutableArray array];
    _rightArr = [[NSMutableArray alloc] init];
    
    [self setNav];
    [self initMainView];
    
    _typeId = @"";
    _areaCode = @"";
     [self initTableViewRefresh:_righttableView Url:@"Driver/Index" array:_rightArr controller:self];
    
    [self initData];
}

-(void)setNav{
    UIView * Nabview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    Nabview.backgroundColor = Color_RGBA(13, 120, 63, 1);
    [self.view addSubview:Nabview];
    
    UIColor * colorOne = Color_RGBA(245, 182, 101, 1.0);
    UIColor * colorTwo = Color_RGBA(255, 106, 125, 1.0);
    [self viewChangeColorWithTwoColor:colorOne anotherColor:colorTwo andView:Nabview];
    
    
    UILabel * titleLabel = [[UILabel alloc] init];
    [Nabview addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Nabview).with.offset(30);
        make.left.equalTo(Nabview).with.offset(81);
        make.bottom.equalTo(Nabview).with.offset(-4);
        make.right.equalTo(Nabview).with.offset(-81);
    }];
    titleLabel.text = @"驾驶员";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [Nabview addSubview:titleLabel];
    
    
//    self.currentCityStr = [StorageUserInfromation storageUserInformation].dingweiCity?[StorageUserInfromation storageUserInformation].dingweiCity:@"重庆";
    self.currentCityStr = @"重庆";
    _locationbutton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 90, 24, 80, 40)];
    [_locationbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_locationbutton setTitle:@"重庆" forState:UIControlStateNormal];
    _locationbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_locationbutton addTarget:self action:@selector(LSNbutton:) forControlEvents:UIControlEventTouchUpInside];
    [_locationbutton setImage:[UIImage imageNamed:@"boomhei"] forState:UIControlStateNormal];
    _locationbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [Nabview addSubview:_locationbutton];
    
    [_locationbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_locationbutton.imageView.frame.size.width - 10, 0, _locationbutton.imageView.frame.size.width)];
    [_locationbutton setImageEdgeInsets:UIEdgeInsetsMake(0, _locationbutton.titleLabel.bounds.size.width - 10, 0, -_locationbutton.titleLabel.bounds.size.width)];
}

-(void)LSNbutton:(UIButton *)sender{
    self.tabBarController.tabBar.hidden = YES;
    NSDictionary * param = @{@"platform":@"2"};
    [ZTHttpTool postWithUrl:@"Common/ProvinceQuery" param:param success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        _allCityView = [[AllCityView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _allCityView.delegate = self;
        _allCityView.LSSArr = responseObj[@"Data"];
        [self.view addSubview:_allCityView];
    } failure:^(NSError *error) {
        //
    }];
}

#pragma mark --城市选择代理

-(void)LSCitycencelBtn:(UIButton *)sender{
    self.tabBarController.tabBar.hidden = NO;
    [self.allCityView removeFromSuperview];
    
}

-(void)LScountySureBtn:(UIButton *)sender countyStrdic:(NSDictionary *)strdic{
    self.tabBarController.tabBar.hidden = NO;
    NSLog(@"%@",strdic);
    NSString * adStr = strdic[@"title"];
    NSString * areaCode = strdic[@"areaCode"];
    [_locationbutton setTitle:adStr forState:UIControlStateNormal];
    [_locationbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_locationbutton.imageView.frame.size.width - 10, 0, _locationbutton.imageView.frame.size.width)];
    [_locationbutton setImageEdgeInsets:UIEdgeInsetsMake(0, _locationbutton.titleLabel.bounds.size.width - 10, 0, -_locationbutton.titleLabel.bounds.size.width)];
    _allCityView.hidden = YES;
    
    _areaCode = areaCode;
    [_righttableView.mj_header beginRefreshing];
    
}

-(void)initData{
    NSDictionary * param = @{@"flag":@"0"};
    [ZTHttpTool postWithUrl:@"Common/CategoryQuery" param:param success:^(id responseObj) {
        //
        NSLog(@"%@",responseObj);
        _leftArr = responseObj[@"Data"];
        for (NSInteger i = 0; i <_leftArr.count; i ++) {
            [_ColorModelArr addObject:@"1"];
        }
        NSIndexPath * defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:_lefttableView didSelectRowAtIndexPath:defaultIndexPath];
    } failure:^(NSError *error) {
        //
    }];
    
   

}

-(void)initTableViewRefresh:(UITableView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller{
    static int i=1;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        i=1;
        // 进入刷新状态后会自动调用这个block
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        NSDictionary * dcit =@{@"platform":@"2",@"uid":storage.userID,@"phone":storage.loginPhone,@"token":storage.token,@"areaCode":_areaCode,@"typeId":_typeId,@"pn":@"1",@"rows":@"10"};
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
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        NSDictionary * dcit =@{@"platform":@"2",@"uid":storage.userID,@"phone":storage.loginPhone,@"token":storage.token,@"areaCode":_areaCode,@"typeId":_typeId,@"pn":[NSString stringWithFormat:@"%zd",i],@"rows":@"10"};
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



-(void)initMainView{
    _lefttableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, 80, HEIGHT - 64 - 49) style:UITableViewStylePlain];
    _lefttableView.delegate = self;
    _lefttableView.dataSource = self;
    _lefttableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_lefttableView tableViewGetFootEmptyView];
    [self.view addSubview:_lefttableView];
    
    _righttableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lefttableView.frame), 64, WIDTH - CGRectGetMaxX(_lefttableView.frame), HEIGHT - 64 - 49) style:UITableViewStylePlain];
    _righttableView.delegate = self;
    _righttableView.dataSource = self;
    [_righttableView tableViewGetFootEmptyView];
    [self.view addSubview:_righttableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _lefttableView) {
        return _leftArr.count;
    }else{
//        if (_rightArr.count == 0) {
//            return 3;
//        }else{
            return _rightArr.count;
//        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _lefttableView) {
        driveleftCell * cell;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"driveleftCell" owner:self options:nil] lastObject];
        }
        NSString * colorStr = _ColorModelArr[indexPath.row];
        if ([colorStr isEqualToString:@"0"]) {
            cell.Namelabel.backgroundColor = [UIColor orangeColor];
        }else{
            cell.Namelabel.backgroundColor = [UIColor whiteColor];
        }
        NSDictionary * dict = _leftArr[indexPath.row];
        cell.Namelabel.text = dict[@"title"];
        return cell;
    }else{
        driverightCell * cell;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"driverightCell" owner:self options:nil] lastObject];
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 80, 0, 0);
        
        NSDictionary * dict = _rightArr[indexPath.row];
        
        [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"staticHttpUrl"],dict[@"img"]]] placeholderImage:[UIImage imageNamed:DefaultPictue]];
        if ([dict[@"title"] isKindOfClass:[NSString class]]) {
            cell.namelabel.text = dict[@"title"];
        }else{
          cell.namelabel.text = @"";
        }
        
        cell.marlabel.text = dict[@"typeName"];
        
        cell.yearlabel.text = [NSString stringWithFormat:@"%zd年经验",[dict[@"tips"] integerValue]];

        return cell;
      
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _lefttableView) {
        return 60;
    }else{
        return 80;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _lefttableView) {
        for (NSInteger i = 0; i < _ColorModelArr.count ; i ++) {
            if (i == indexPath.row) {
                [_ColorModelArr replaceObjectAtIndex:indexPath.row withObject:@"0"];
            }else{
                [_ColorModelArr replaceObjectAtIndex:i withObject:@"1"];
            }
        }
        NSDictionary * dict = _leftArr[indexPath.row];
        [_lefttableView reloadData];
        
        _typeId = dict[@"proId"];
        NSLog(@"%@",_typeId);
        [_righttableView.mj_header beginRefreshing];
    }
    
    if (tableView == _righttableView) {
        NSDictionary * dict = _rightArr[indexPath.row];
        driveMessageViewController * page = [[driveMessageViewController alloc] init];
        page.uid = dict[@"id"];
        page.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:page animated:YES];
    }
}



@end
