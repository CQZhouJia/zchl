//
//  AllCityView.h
//  LSOnline
//
//  Created by jglx on 17/4/24.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol cityDelegatecheck <NSObject>

-(void)LSCitycencelBtn:(UIButton *)sender;

-(void)LScountySureBtn:(UIButton *)sender countyStrdic:(NSDictionary *)strdic;

@end

@interface AllCityView : UIView

@property (nonatomic,assign)id <cityDelegatecheck> delegate;

@property (nonatomic,strong)NSArray *LSSArr;

@end
