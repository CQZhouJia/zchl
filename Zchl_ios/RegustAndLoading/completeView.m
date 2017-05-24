//
//  completeView.m
//  Zchl_ios
//
//  Created by jglx on 17/5/4.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "completeView.h"

@implementation completeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _flag = @"0";
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        backView.backgroundColor = Color_RGBA(64, 74, 74, 1.0);
        backView.alpha = 0.2;
        [self addSubview:backView];
        
        UIView * centerView = [[UIView alloc] initWithFrame:CGRectMake((WIDTH - 150)/2.0, 200, 150, 180)];
        centerView.backgroundColor = [UIColor whiteColor];
        centerView.layer.cornerRadius = 5;
        [self addSubview:centerView];
        
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 150, 25)];
        title.text = @"请选择您的身份:";
        title.font = [UIFont systemFontOfSize:14];
        title.textColor = [UIColor blackColor];
        title.textAlignment = NSTextAlignmentCenter;
        [centerView addSubview:title];
        
        _Arr = [NSMutableArray array];
        
        NSArray * arr = @[@"驾驶员",@"商家",@"维修工"];
        for (NSInteger i = 0; i < 3; i ++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30 + 5 + 6 + i * 33, 11, 11)];
            imageView.image = [UIImage imageNamed:@"yuanhui"];
            [centerView addSubview:imageView];
            imageView.tag = 1000 + i;
            [_Arr addObject:imageView];
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(40, 30 + i * 33, 150 - 30, 33);
            [btn setTitle:arr[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [centerView addSubview:btn];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            btn.tag = 400 + i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(20, 130, 110, 30);
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor orangeColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [centerView addSubview:btn];
        btn.layer.cornerRadius = 5;
        [btn addTarget:self action:@selector(comClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)btnClick:(UIButton *)sender{

    for (NSInteger i = 0; i < _Arr.count; i ++) {
        if (i == sender.tag - 400) {
            UIImageView * imageView = _Arr[i];
            imageView.image = [UIImage imageNamed:@"yuanred"];
            
        }else{
            UIImageView * imageView = _Arr[i];
            imageView.image = [UIImage imageNamed:@"yuanhui"];
        }
        _flag = [NSString stringWithFormat:@"%zd",sender.tag - 400];
        NSLog(@"%@",_flag);
    }
}

-(void)comClick:(UIButton *)sender{
    [_delegate comepleteClickPass:_flag];
}

@end
