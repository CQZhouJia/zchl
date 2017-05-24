//
//  photoCell.m
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "photoCell.h"

@interface photoCell ()

@property (nonatomic,strong)UIImageView * photoImage;

@property (nonatomic,strong)UILabel * name;

@property (nonatomic,strong)UILabel * sexla;

@property (nonatomic,strong)UILabel * yearlabe;

@property (nonatomic,strong)UILabel * workla;

@property (nonatomic,strong)UILabel * workjinyan;

@property (nonatomic,strong)UILabel * workstate;

@property (nonatomic,strong)UILabel * localla;

@property (nonatomic,strong)UILabel * CallLabel;

@property (nonatomic,strong)UILabel * youxianglabel;


@end

@implementation photoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI{
    _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 80)/2, 10, 80, 80)];
    _photoImage.image = [UIImage imageNamed:@"timg"];
    [self.contentView addSubview:_photoImage];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH - 80)/2, CGRectGetMaxY(_photoImage.frame), 80, 20)];
    _name.textAlignment = NSTextAlignmentCenter;
    _name.textColor = [UIColor orangeColor];
    _name.text = @"曹操";
    [self.contentView addSubview:_name];
    
    _sexla = [[UILabel alloc] initWithFrame:CGRectMake(70, CGRectGetMaxY(_name.frame), 30, 20)];
    _sexla.text = @"男";
    _sexla.font = [UIFont systemFontOfSize:14];
    _sexla.textColor = Color_RGBA(187, 187, 187, 1.0);
    _sexla.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_sexla];
    
    UILabel * labe = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_sexla.frame), CGRectGetMinY(_sexla.frame) + 3, 1, 14)];
    labe.backgroundColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:labe];
    
    _yearlabe = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labe.frame), CGRectGetMinY(_sexla.frame), 50, 20)];
    _yearlabe.textAlignment = NSTextAlignmentCenter;
    _yearlabe.text = @"35岁";
    _yearlabe.font = [UIFont systemFontOfSize:14];
    _yearlabe.textColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:_yearlabe];
    
    UILabel * labe1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_yearlabe.frame), CGRectGetMinY(_yearlabe.frame) + 3, 1, 14)];
    labe1.backgroundColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:labe1];
    
    _workla = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(labe1.frame), CGRectGetMinY(_yearlabe.frame), 60, 20)];
    _workla.text = @"装载机";
    _workla.font = [UIFont systemFontOfSize:14];
    _workla.textAlignment = NSTextAlignmentCenter;
    _workla.textColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:_workla];
    
    UILabel * labe2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_workla.frame), CGRectGetMinY(_workla.frame) + 3, 1, 14)];
    labe2.backgroundColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:labe2];
    
    _workjinyan = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(labe2.frame), CGRectGetMinY(_yearlabe.frame), 100, 20)];
    _workjinyan.text = @"3-5年经验";
    _workjinyan.font = [UIFont systemFontOfSize:14];
    _workjinyan.textAlignment = NSTextAlignmentCenter;
    _workjinyan.textColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:_workjinyan];
    
    
  
    _workstate = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2 - 100, CGRectGetMaxY(_workjinyan.frame), 100, 20)];
    _workstate.text = @"正在找工作";
    _workstate.font = [UIFont systemFontOfSize:14];
    _workstate.textColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:_workstate];
    _workstate.textAlignment = NSTextAlignmentCenter;
    
    UILabel * lin1 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2, CGRectGetMinY(_workstate.frame) + 3, 1, 14)];
    lin1.backgroundColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:lin1];
    
    _localla = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH/2 + 1, CGRectGetMinY(_workstate.frame), 100, 20)];
    _localla.textColor = Color_RGBA(187, 187, 187, 1.0);
    _localla.textAlignment = NSTextAlignmentCenter;
    _localla.text = @"重庆-江北区";
    _localla.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_localla];
  
    
    
    UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_localla.frame) + 20, 150, 20)];
    phoneLabel.text = @"联系方式";
    phoneLabel.font = [UIFont systemFontOfSize:14];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.textColor = [UIColor orangeColor];
    [self.contentView addSubview:phoneLabel];
    
    UILabel * lin2 = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(phoneLabel.frame), WIDTH - 16, 1)];
    lin2.backgroundColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:lin2];
    
    UILabel * dianhuala = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(lin2.frame), 60,20)];
    dianhuala.textColor = Color_RGBA(187, 187, 187, 1.0);
    dianhuala.text = @"电话:";
    dianhuala.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:dianhuala];
    
    _CallLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dianhuala.frame), CGRectGetMinY(dianhuala.frame), WIDTH, 20)];
    _CallLabel.textAlignment=  NSTextAlignmentLeft;
    _CallLabel.text = @"13656321523-";
    _CallLabel.textColor = Color_RGBA(187, 187, 187, 1.0);
    _CallLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:_CallLabel];
    
    UILabel * youlabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_CallLabel.frame), 60, 20)];
    youlabel.text = @"邮箱:";
    youlabel.textColor = Color_RGBA(187, 187, 187, 1.0);
    youlabel.font = [UIFont systemFontOfSize:14];
    youlabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:youlabel];
    
    _youxianglabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(youlabel.frame), CGRectGetMinY(youlabel.frame), WIDTH, 20)];
    _youxianglabel.textAlignment = NSTextAlignmentLeft;
    _youxianglabel.textColor = Color_RGBA(187, 187, 187, 1.0);
    _youxianglabel.text = @"36582695@qq.com-";
    [self.contentView addSubview:_youxianglabel];
    
    UILabel * workforlabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(_youxianglabel.frame), WIDTH, 20)];
    workforlabel.textAlignment = NSTextAlignmentLeft;
    workforlabel.text = @"求职意向";
    workforlabel.textColor = [UIColor orangeColor];
    workforlabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:workforlabel];
 
    UILabel * lin3 = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(workforlabel.frame), WIDTH - 16, 1)];
    lin3.backgroundColor = Color_RGBA(187, 187, 187, 1.0);
    [self.contentView addSubview:lin3];
}

-(void)setDict:(NSDictionary *)dict{
    _dict = dict;
    [_photoImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",dict[@"staticHttpUrl"],dict[@"img"]]] placeholderImage:[UIImage imageNamed:DefaultPictue]];
    if ([_dict[@"title"] isKindOfClass:[NSString class]]) {
         _name.text = _dict[@"title"];
    }else{
         _name.text = @"";
    }

    switch ([_dict[@"sex"] integerValue]) {
        case 0:
            _sexla.text = @"女";
            break;
        case 1:
            _sexla.text = @"男";
            break;
        case 2:
            _sexla.text = @"未知";
            break;
        default:
            break;
    }
   
    _yearlabe.text = [NSString stringWithFormat:@"%.0f",[_dict[@"age"] floatValue]];
    _workla.text = dict[@"typeName"];
    _workjinyan.text = [NSString stringWithFormat:@"%@年工作经验",_dict[@"workTips"]];
    
    switch ([_dict[@"workstate"] integerValue]) {
        case 0:
            _workstate.text = @"正在找工作";
            break;
        case 1:
            _workstate.text = @"已找到工作";
            break;
        default:
            break;
    }
    
    _localla.text = _dict[@"address"];
    
    _CallLabel.text = [NSString stringWithFormat:@"%@",_dict[@"phone"]];
    _youxianglabel.text = [NSString stringWithFormat:@"%@",_dict[@"email"]];

}

@end
