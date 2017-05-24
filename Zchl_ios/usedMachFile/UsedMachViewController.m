//
//  UsedMachViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/4/28.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "UsedMachViewController.h"
#import "peileftCell.h"
#import "peirightCell.h"
#import "UsedetaiController.h"

#define leftWith 80

@interface UsedMachViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UIButton * locationbutton;
@property (nonatomic,strong)UIButton * topbutton;
@property (nonatomic,strong)UITableView * lefttableView;
@property (nonatomic,strong)UICollectionView * rightcollectionView;
@property (nonatomic,strong)NSArray * myArray;
@property (nonatomic,strong)NSArray * leftArray;
@property (nonatomic,strong)NSMutableArray * leftFlagArray; // 标示

@property (nonatomic,strong)NSMutableArray * myMuArray;
@property (nonatomic,strong)NSString * flag;

@property (nonatomic,strong)NSString *categoryId;



@end

@implementation UsedMachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _myArray = @[@"erdemo1",@"erdemo2",@"erdemo3"];
//    _leftArray = @[@"装载机",@"推土机",@"起重机",@"混泥土车",@"压路机"];
    [self setNav];
    [self initMainView];
    
    
    _leftFlagArray = [NSMutableArray array];
    [self initleftData];
    
    _myMuArray = [NSMutableArray array];
    _flag = @"0";
    _categoryId = @"0";
    [self initColletionViewRefresh:_rightcollectionView Url:@"Goods/Index" array:_myMuArray controller:self];
}

-(void)setNav{
    
    UIView * Nabview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    //    Nabview.backgroundColor = Color_RGBA(32, 40, 93, 1.0);
    [self.view addSubview:Nabview];
    
    UIColor * colorOne = Color_RGBA(94, 205, 100, 1.0);
    UIColor * colorTwo = Color_RGBA(57, 117, 69, 1.0);
    [self viewChangeColorWithTwoColor:colorOne anotherColor:colorTwo andView:Nabview];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [Nabview addSubview:button];
    [button setImage:[UIImage imageNamed:@"backhei"] forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(Nabview).with.offset(20);
        make.left.equalTo(Nabview).with.offset(0);
        make.bottom.equalTo(Nabview).with.offset(0);
        make.width.mas_equalTo(@50);
    }];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];

    
    UILabel * titleLabel = [[UILabel alloc] init];
    [Nabview addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Nabview).with.offset(30);
        make.left.equalTo(Nabview).with.offset(81);
        make.bottom.equalTo(Nabview).with.offset(-4);
        make.right.equalTo(Nabview).with.offset(-81);
    }];
    titleLabel.text = @"二手机";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [Nabview addSubview:titleLabel];
    
    
    
    _locationbutton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 90, 24, 80, 40)];
    [_locationbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_locationbutton setTitle:@"重庆" forState:UIControlStateNormal];
    [_locationbutton setTintColor:[UIColor blackColor]];
    _locationbutton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [_locationbutton addTarget:self action:@selector(LSNbutton:) forControlEvents:UIControlEventTouchUpInside];
    [_locationbutton setImage:[UIImage imageNamed:@"boomhei"] forState:UIControlStateNormal];
    _locationbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [Nabview addSubview:_locationbutton];
    
    [_locationbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_locationbutton.imageView.frame.size.width - 10, 0, _locationbutton.imageView.frame.size.width)];
    [_locationbutton setImageEdgeInsets:UIEdgeInsetsMake(0, _locationbutton.titleLabel.bounds.size.width - 10, 0, -_locationbutton.titleLabel.bounds.size.width)];
    
}

-(void)initleftData{
   
    NSDictionary * param  = @{@"flag":@"0"};
    [ZTHttpTool postWithUrl:@"Common/CategoryQuery" param:param success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        _leftArray = responseObj[@"Data"];
        for (NSInteger i = 0; i < _leftArray.count; i ++) {
            [_leftFlagArray addObject:[NSNumber numberWithBool:NO]];
        }
        
        [self.lefttableView reloadData];
        NSIndexPath * defaultIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:_lefttableView didSelectRowAtIndexPath:defaultIndexPath];
     
    } failure:^(NSError *error) {
        //
    }];
}

-(void)initColletionViewRefresh:(UICollectionView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller{
    static int i=1;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        i=1;
        // 进入刷新状态后会自动调用这个block
        NSDictionary * dcit =@{@"flag":_flag,@"categoryId":_categoryId,@"pn":@"1",@"rows":@"10"};//
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
                }
            }else if ([responseObj[@"State"] integerValue] == 1){
                //                [controller showHint:responseObj[@"Msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
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
        NSDictionary * dcit =@{@"flag":_flag,@"categoryId":_categoryId,@"pn":[NSString stringWithFormat:@"%zd",i],@"rows":@"10"};//
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


-(void)backClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)LSNbutton:(UIButton *)sender{
  
}

-(void)initMainView{
    _topbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    _topbutton.frame = CGRectMake(0, 64, leftWith, 42);
    [_topbutton setTitle:@"分类" forState:UIControlStateNormal];
    [_topbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _topbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_topbutton];
    
    _lefttableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64 + 42, leftWith, HEIGHT - 64  - 42) style:UITableViewStylePlain];
    _lefttableView.delegate = self;
    _lefttableView.dataSource = self;
    _lefttableView.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self.view addSubview:_lefttableView];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(leftWith, 64, 1, HEIGHT - 64)];
    lineView.backgroundColor = Color_RGBA(215, 215, 215, 1.0);
    [self.view addSubview:lineView];
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _rightcollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(leftWith + 1, 64, WIDTH - leftWith - 1, HEIGHT - 64) collectionViewLayout:flowLayout];
    _rightcollectionView.delegate = self;
    _rightcollectionView.dataSource = self;
    _rightcollectionView.bounces = NO;
    _rightcollectionView.showsVerticalScrollIndicator = NO;
    _rightcollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_rightcollectionView];
    
    UINib * nib = [UINib nibWithNibName:@"peirightCell" bundle:[NSBundle mainBundle]];
    [_rightcollectionView registerNib:nib forCellWithReuseIdentifier:@"peirightCell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _leftArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * iden = @"iden";
    peileftCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"peileftCell" owner:self options:nil] lastObject];
    }
//    cell.namelabel.text = _leftArray[indexPath.row];
    
    
    
    NSDictionary * dict = _leftArray[indexPath.row];
    cell.namelabel.text = dict[@"title"];
    NSNumber * flagBool = _leftFlagArray[indexPath.row];
    if ([flagBool boolValue]) {
        cell.flagView.hidden = NO;
        cell.namelabel.textColor = [UIColor blackColor];
    }else{
        cell.namelabel.textColor = Color_RGBA(198, 198, 198, 1.0);
        cell.flagView.hidden = YES;
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (NSInteger i = 0; i < _leftFlagArray.count ; i ++) {
        if (i == indexPath.row) {
            [_leftFlagArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:YES]];
        }else{
           [_leftFlagArray replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
        }
        NSLog(@"%@",_leftFlagArray[i]);
    }
    [self.lefttableView reloadData];

    
    NSDictionary * dict = _leftArray[indexPath.row];
    NSLog(@"%@",dict[@"proId"]);
    _categoryId = dict[@"proId"];
    [_rightcollectionView.mj_header beginRefreshing];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}


#pragma mark delegateFolelayout
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _myMuArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * iden = @"peirightCell";
    peirightCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
//    cell.logoImage.image = [UIImage imageNamed:_myArray[indexPath.row%3]];
    
    NSDictionary * dict = _myMuArray[indexPath.row];
    [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"staticHttpUrl"],dict[@"img"]]] placeholderImage:[UIImage imageNamed:DefaultPictue]];
    cell.textLabel.text = dict[@"title"];
    
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return CGSizeMake((WIDTH - leftWith - 1)/3.0, 100);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    NSLog(@"%ld",section);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dict = _myMuArray[indexPath.row];
    NSString * proId = dict[@"proId"];
    
    UsedetaiController * page = [[UsedetaiController alloc] init];
    page.proId = proId;
    page.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:page animated:YES];
}

@end
