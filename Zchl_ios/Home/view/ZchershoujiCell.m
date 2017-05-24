//
//  ZchershoujiCell.m
//  Zchl_ios
//
//  Created by jglx on 17/4/27.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "ZchershoujiCell.h"

@implementation ZchershoujiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return  self;
}

-(void)createUI{
  
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    topView.backgroundColor = Color_RGBA(255, 171, 40, 1.0);
    [self.contentView addSubview:topView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 12, 30, 16)];
    imageView.image = [UIImage imageNamed:@"homeershouji"];
    [topView addSubview:imageView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 0, 200, 40)];
    label.text = @"二手机";
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    [topView addSubview:label];
    
    
    UIView * boomView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, WIDTH, 80)];
    boomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:boomView];
    
    _centerView = [[UIView alloc] initWithFrame:CGRectMake(30, 10, WIDTH - 60, 60)];
//    _centerView.backgroundColor = [UIColor greenColor];
    [boomView addSubview:_centerView];
    
    UIView * boomViewColor = [[UIView alloc] initWithFrame:CGRectMake(0, 75, WIDTH, 5)];
    boomViewColor.backgroundColor =  Color_RGBA(227, 228, 229, 1);
    [boomView addSubview:boomViewColor];
}

-(void)setNameArr:(NSArray *)nameArr{
    _nameArr = nameArr;
    
    NSArray * priceArr = @[@"5万以下",@"5万-10万",@"10万-15万",@"15万-20万",@"20万以上"];
    for (NSInteger i = 0; i < _nameArr.count; i ++) {
        UILabel * namelabel = [[UILabel alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(_centerView.frame)/5, 0, CGRectGetWidth(_centerView.frame)/5, 20)];
        namelabel.text = _nameArr[i];
        namelabel.font = [UIFont systemFontOfSize:14];
        namelabel.textAlignment = NSTextAlignmentCenter;
        namelabel.textColor = Color_RGBA(98, 103, 140, 1.0);
        [_centerView addSubview:namelabel];
        
        UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(_centerView.frame)/5, CGRectGetMaxY(namelabel.frame) + 10, CGRectGetWidth(_centerView.frame)/5, 20)];
        priceLabel.text = priceArr[i];;
        priceLabel.textColor = Color_RGBA(207, 207, 207, 1.0);
        priceLabel.font = [UIFont systemFontOfSize:10];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        [_centerView addSubview:priceLabel];
        
        
        UILabel *lineLabel  = [[UILabel alloc] initWithFrame:CGRectMake(i * CGRectGetWidth(_centerView.frame)/5 + CGRectGetWidth(_centerView.frame)/5 - 1, 20, 1, 20)];
        lineLabel.backgroundColor = Color_RGBA(207, 207, 207, 1.0);
        [_centerView addSubview:lineLabel];
        if (i == 4) {
            lineLabel.hidden = YES;
        }
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(i * CGRectGetWidth(_centerView.frame)/5 , 0, CGRectGetWidth(_centerView.frame)/5, CGRectGetHeight(_centerView.frame));
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 100 + i;
        [_centerView addSubview:btn];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

-(void)buttonClick:(UIButton *)sender{
    [_delegate ershoujibuttonDelegatebutton:sender];
}



@end
