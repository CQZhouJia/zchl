//
//  weixiuViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/4/28.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "weixiuViewController.h"
#import "weixiubutton.h"
#import "weixiucollCell.h"
#import "FootCollectionReusableView.h"


@interface weixiuViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,cityDelegatecheck>

@property (nonatomic,strong)UIButton * locationbutton;

@property (nonatomic,strong)weixiubutton * leftbutton;

@property (nonatomic,strong)weixiubutton * rightbutton;

@property (nonatomic,strong)UICollectionView * collectionView;

//@property (nonatomic,strong)NSArray * myArray;

@property (nonatomic,assign)BOOL locationBool;

@property (nonatomic,strong)NSString * areaCode;

@property (nonatomic,strong)AllCityView * allCityView;

@property (nonatomic,strong)NSString * flag;

@property (nonatomic,strong)NSArray * myArray;

@end

@implementation weixiuViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationBool = NO;
    [self setNav];
    [self initScView];
    [self initCollerView];
//    [self setAdSystemData]; // 获取维修广告
    
    _areaCode = @"";
    _flag = @"";
   
    [self initDataareaCode:@"" flag:@"0"];
}


-(void)initDataareaCode:(NSString *)areaCode flag:(NSString *)flag{
    NSDictionary * param = @{@"areaCode":areaCode,@"flag":flag};
    NSLog(@"%@",param);
    [ZTHttpTool postWithUrl:@"Common/ServicePointQueryByAreaCode" param:param success:^(id responseObj) {
        //
        NSLog(@"%@",responseObj);
        NSLog(@"%@",responseObj[@"Msg"]);
        _myArray = responseObj[@"Data"];
        NSLog(@"%zd",_myArray.count);
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        //
    }];
}

-(void)setNav{
    UIView * Nabview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    [self.view addSubview:Nabview];
    UIColor * colorOne = Color_RGBA(252, 255, 63, 1.0);
    UIColor * colorTwo = Color_RGBA(244, 166, 47, 1.0);
    [self viewChangeColorWithTwoColor:colorOne anotherColor:colorTwo andView:Nabview];

    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [Nabview addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(Nabview).with.offset(20);
        make.left.equalTo(Nabview).with.offset(0);
        make.bottom.equalTo(Nabview).with.offset(0);
        make.width.mas_equalTo(@50);
    }];
    [button setImage:[UIImage imageNamed:@"backhei"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    [Nabview addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(Nabview).with.offset(30);
        make.left.equalTo(Nabview).with.offset(81);
        make.bottom.equalTo(Nabview).with.offset(-4);
        make.right.equalTo(Nabview).with.offset(-81);
    }];
    titleLabel.text = @"维修";
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [Nabview addSubview:titleLabel];
    
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
    [self.allCityView removeFromSuperview];

}

-(void)LScountySureBtn:(UIButton *)sender countyStrdic:(NSDictionary *)strdic{

    NSLog(@"%@",strdic);
    NSString * adStr = strdic[@"title"];
    NSString * areaCode = strdic[@"areaCode"];
    [_locationbutton setTitle:adStr forState:UIControlStateNormal];
    [_locationbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_locationbutton.imageView.frame.size.width - 10, 0, _locationbutton.imageView.frame.size.width)];
    [_locationbutton setImageEdgeInsets:UIEdgeInsetsMake(0, _locationbutton.titleLabel.bounds.size.width - 10, 0, -_locationbutton.titleLabel.bounds.size.width)];
    _allCityView.hidden = YES;
    
    [self initDataareaCode:areaCode flag:_flag];
    
}

-(void)backClick:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setAdSystemData{
    NSDictionary * param = @{@"placeId":@"1"};
    [ZTHttpTool postWithUrl:@"AdSystem/Main" param:param success:^(id responseObj) {
        //
        NSLog(@"%@",responseObj);
      
    } failure:^(NSError *error) {
        //
    }];
}

-(void)initScView{
    float Sheight = 160;
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, Sheight)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(WIDTH * 3, Sheight);
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    NSArray * arr = @[@"weixiudemo1",@"weixiudemo2",@"weixiudemo3"];
    for (NSInteger i = 0; i < 3; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, Sheight)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",arr[i]]];
        [scrollView addSubview:imageView];
    }
    [self.view addSubview:scrollView];

    
    _leftbutton = [weixiubutton buttonWithType:UIButtonTypeCustom];
    _leftbutton.frame = CGRectMake(0, CGRectGetMaxY(scrollView.frame), WIDTH/2, 40);
    [_leftbutton setTitle:@"综合" forState:UIControlStateNormal];
    [_leftbutton setTitleColor:Color_RGBA(254, 171, 41, 1.0) forState:UIControlStateNormal];
    _leftbutton.select = YES;
    [_leftbutton addTarget:self action:@selector(leftbutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftbutton];
    
    _rightbutton = [weixiubutton buttonWithType:UIButtonTypeCustom];
    _rightbutton.frame = CGRectMake(WIDTH/2, CGRectGetMaxY(scrollView.frame), WIDTH/2, 40);
    [_rightbutton setTitle:@"附近" forState:UIControlStateNormal];
    [_rightbutton setTitleColor:Color_RGBA(161, 161, 161, 1.0) forState:UIControlStateNormal];
    _rightbutton.select = NO;
    [_rightbutton addTarget:self action:@selector(ributtonclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightbutton];
    
}

-(void)leftbutton:(weixiubutton *)sender{
    [sender setTitleColor:Color_RGBA(254, 171, 41, 1.0) forState:UIControlStateNormal];
    sender.select = YES;
    
    [_rightbutton setTitleColor:Color_RGBA(161, 161, 161, 1.0) forState:UIControlStateNormal];
    _rightbutton.select = NO;
    
    _locationBool = NO;
    _flag = @"0";
    [self initDataareaCode:_areaCode flag:@"0"];
    [_collectionView reloadData];
}

-(void)ributtonclick:(UIButton *)sender{
   
    [_rightbutton setTitleColor:Color_RGBA(254, 171, 41, 1.0) forState:UIControlStateNormal];
    _rightbutton.select = YES;
    
    [_leftbutton setTitleColor:Color_RGBA(161, 161, 161, 1.0) forState:UIControlStateNormal];
    _leftbutton.select = NO;
    
    _flag = @"1";
    [self initDataareaCode:_areaCode flag:@"1"];

    _locationBool = YES;
    [_collectionView reloadData];
}

-(void)initCollerView{
  
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_leftbutton.frame), WIDTH , HEIGHT - CGRectGetMaxY(_leftbutton.frame)) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = Color_RGBA(238, 238, 238, 1.0);
    self.tabBarController.tabBar.backgroundColor = [UIColor redColor];
    UIView * boomView = [[UIView alloc] init];
    boomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectionView];
    
   
    UINib * nib = [UINib nibWithNibName:@"weixiucollCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:@"weixiucollCell"];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"FootCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FootCollectionReusableView"];
    
    
//    UIView * tabView = [[UIView alloc] init];
//    tabView.backgroundColor = Color_RGBA(238, 238, 238, 1.0);
//    [self.view addSubview:tabView];
//    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).with.offset(0);
//        make.left.equalTo(self.view).with.offset(0);
//        make.right.equalTo(self.view).with.offset(0);
//        make.height.mas_equalTo(@49);
//    }];
}

#pragma mark delegateFolelayout
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _myArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * iden = @"weixiucollCell";
    weixiucollCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
//    cell.logoImage.image = [UIImage imageNamed:_myArray[indexPath.row%3]];
//    cell.namelabel.text = @"重庆渝北";
//    cell.textLabel.text = @"专业维修,保养装载机";
    
    NSDictionary * dict = _myArray[indexPath.row];
    
    [cell.logoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"staticHttpUrl"],dict[@"img"]]] placeholderImage:[UIImage imageNamed:DefaultPictue]];
    
    cell.namelabel.text = dict[@"address"];
//    NSString * title = dict[@"title"];
    if ([dict[@"title"] isKindOfClass:[NSString class]]) {
        cell.textLabel.text = dict[@"title"];
    }else{
        cell.textLabel.text = @"";
    }
    
    NSInteger starnum = [dict[@"star"] integerValue];
    
    for (NSInteger i = 0; i < starnum ; i ++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3 +  i * (15 + 3), 3, 15, 15)];
        imageView.image = [UIImage imageNamed:@"stare"];
        [cell.boomView addSubview:imageView];
    }
    
    if (_locationBool == YES) {
        cell.localabel.hidden = NO;
        cell.localabel.backgroundColor = Color_RGBA(212, 212, 212, 1.0);
        cell.localabel.alpha = 0.9;
        NSDictionary * dict = _myArray[indexPath.row];
        cell.localabel.text = [NSString stringWithFormat:@"距离%@",dict[@"distance"]];
        [cell.localabel sizeToFit];
    }else{
        cell.localabel.hidden = YES;
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    return CGSizeMake(WIDTH/3.0 - 2, 150);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    NSLog(@"%ld",section);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 2;
}


@end
