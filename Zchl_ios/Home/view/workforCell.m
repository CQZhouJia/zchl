//
//  workforCell.m
//  Zchl_ios
//
//  Created by jglx on 17/4/27.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "workforCell.h"

//@interface workforCell ()
//
//@property ()
//
//@end

@implementation workforCell

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
    return self;
}

-(void)createUI{
  
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.frame.size.height)];
    [self.contentView addSubview:backView];
    
    UIColor * colorOne = Color_RGBA(245, 182, 101, 1.0);
    UIColor * colorTwo = Color_RGBA(255, 106, 125, 1.0);
    [self viewChangeColorWithTwoColor:colorOne anotherColor:colorTwo andView:backView];
    
    _leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftbutton.frame = CGRectMake(0, 0, WIDTH/2-1, self.frame.size.height);
    [_leftbutton setTitle:@"求职" forState:UIControlStateNormal];
    _leftbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_leftbutton setImage:[UIImage imageNamed:@"peopleleft"] forState:UIControlStateNormal];
    [_leftbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, _leftbutton.imageView.frame.size.width - 15, 0, 0)];
    [_leftbutton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, _leftbutton.titleLabel.bounds.size.width - 15)];
    _leftbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [backView addSubview:_leftbutton];
    [_leftbutton addTarget:self action:@selector(leftclick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH/2, 10, 1, self.frame.size.height - 20)];
    lineView.backgroundColor = Color_RGBA(161, 161, 161, 1.0);
    [backView addSubview:lineView];
    
    _rightbutton  = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightbutton.frame = CGRectMake(WIDTH/2, 0, WIDTH/2, self.frame.size.height);
    [_rightbutton setTitle:@"招聘" forState:UIControlStateNormal];
    _rightbutton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightbutton setImage:[UIImage imageNamed:@"forright"] forState:UIControlStateNormal];
    _rightbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_rightbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, _rightbutton.imageView.frame.size.width - 15, 0, 0)];
    [_rightbutton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, _rightbutton.titleLabel.bounds.size.width - 15)];
    [_rightbutton addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:_rightbutton];
    
//    [_locationbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_locationbutton.imageView.frame.size.width - 10, 0, _locationbutton.imageView.frame.size.width)];
//    [_locationbutton setImageEdgeInsets:UIEdgeInsetsMake(0, _locationbutton.titleLabel.bounds.size.width - 10, 0, -_locationbutton.titleLabel.bounds.size.width)];

    
}


-(void)viewChangeColorWithTwoColor:(UIColor *)colorone anotherColor:(UIColor *)colorTwo andView:(UIView *)userView{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorone.CGColor,(__bridge id)colorTwo.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, userView.frame.size.width, userView.frame.size.height);
    [userView.layer addSublayer:gradientLayer];
}

-(void)leftclick:(UIButton *)sender{
    [_delegate leftServericsCollectionViewClick:sender];
}

-(void)rightClick:(UIButton *)sender{
    [_delegate rightServericsCollectionViewClick:sender];
}

@end
