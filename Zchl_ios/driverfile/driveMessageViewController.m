//
//  driveMessageViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "driveMessageViewController.h"
#import "photoCell.h"
#import "driboomCell.h"

@interface driveMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray * leftArr;

@property (nonatomic,strong)NSArray * rightArr;

@property (nonatomic,strong)NSDictionary * dict;

@property (nonatomic,strong)NSMutableArray * rightMuArray;

@end

@implementation driveMessageViewController


- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)phoneClick:(UIButton *)sender {
    
    NSString * phone = [NSString stringWithFormat:@"%zd",[_dict[@"linkPhone"] integerValue]];
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    _leftArr = @[@"工作类型",@"期望工资",@"有无操作证",@"期望工作地点",@"车型要求",@"是否接受加班",@"是否接受带徒弟"];
    _rightMuArray = [NSMutableArray array];
//     _rightArr = @[@"全职",@"7000/月",@"有",@"重庆",@"装载机",@"是",@"是",@"是"];
    
    [self.drivetableView tableViewGetFootEmptyView];
    self.drivetableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setNav];
    [self initData];
}

-(void)setNav{
    UIColor * colorOne = Color_RGBA(248, 185, 103, 1.0);
    UIColor * colorTwo = Color_RGBA(254, 105, 124, 1.0);
    [self viewChangeColorWithTwoColor:colorOne anotherColor:colorTwo andView:self.topview];
    
    [self.topview addSubview:self.backbtn];
    [self.topview addSubview:self.titlelabel];
}

-(void)initData{
    NSDictionary * param = @{@"uid":_uid};
   [ZTHttpTool postWithUrl:@"Driver/Show" param:param success:^(id responseObj) {
       //
       NSLog(@"%@",responseObj);
       _dict = responseObj[@"Data"];
       [_rightMuArray addObject:@"全职"];
       NSString * salary = [NSString stringWithFormat:@"%@/月",_dict[@"salary"]];
       [_rightMuArray addObject:salary];
       [_rightMuArray addObject:_dict[@"pappers"]];
       [_rightMuArray addObject:_dict[@"exceptCity"]];
       [_rightMuArray addObject:_dict[@"categoryName"]];
       [_rightMuArray addObject:_dict[@"overtime"]];
       [_rightMuArray addObject:_dict[@"trainee"]];
       
       [_drivetableView reloadData];
   } failure:^(NSError *error) {
       //
   }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1 + _rightMuArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString * iden = @"iden";
        photoCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[photoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.dict = _dict;
        return cell;
    }
//    else if (indexPath.row == 1){
//    
//    }
    else{
        driboomCell * cell;
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"driboomCell" owner:self options:nil] lastObject];
        }
        
        cell.leftlabel.text = _leftArr[indexPath.row - 1];
        
      
        CGSize size = CGSizeMake(MAXFLOAT, 20);
        NSString * string = _leftArr[indexPath.row - 1];
        
        NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGRect rects = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
        
        cell.leftwidth.constant = rects.size.width;
        
          cell.rightlabel.text = _rightMuArray[indexPath.row - 1];
        NSLog(@"%@ -- %@ -- %@ --- %@ -- %@",_dict[@"categoryName"],_dict[@"exceptCity"],_dict[@"pappers"],_dict[@"overtime"],_dict[@"salary"])
        
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 260;
    }else{
        return 32;
    }
}


@end
