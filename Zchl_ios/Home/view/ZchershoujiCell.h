//
//  ZchershoujiCell.h
//  Zchl_ios
//
//  Created by jglx on 17/4/27.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ershoujibuttonDelegate <NSObject>


-(void)ershoujibuttonDelegatebutton:(UIButton *)sender;

@end

@interface ZchershoujiCell : UITableViewCell

@property (nonatomic,strong)UIView * centerView;

@property (nonatomic,strong)NSArray * nameArr;

@property (nonatomic,strong)NSArray * priceArr;

@property (nonatomic,assign)id <ershoujibuttonDelegate> delegate;

@end
