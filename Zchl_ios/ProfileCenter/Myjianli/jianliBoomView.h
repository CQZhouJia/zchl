//
//  jianliBoomView.h
//  Zchl_ios
//
//  Created by jglx on 17/5/5.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLcityDelegatecheck <NSObject>

-(void)LSCitycencelBtn:(UIButton *)sender;

-(void)LScountySureBtn:(UIButton *)sender countyStrdic:(NSString *)str andflag:(NSInteger)flag categoryId:(NSInteger)categoryId;

@end

@interface jianliBoomView : UIView

@property (nonatomic,assign)id <JLcityDelegatecheck> delegate;

@property (nonatomic,assign)NSInteger flag;

@property (nonatomic,strong)UIPickerView * pickerView;

@property (nonatomic,strong)NSArray * Arr;

@property (nonatomic,strong)NSString * titleStr;

@end
