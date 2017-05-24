//
//  completeView.h
//  Zchl_ios
//
//  Created by jglx on 17/5/4.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol completeDelegate <NSObject>


-(void)comepleteClickPass:(NSString *)flag;

@end

@interface completeView : UIView

@property (nonatomic,strong)NSMutableArray * Arr;

@property (nonatomic,strong)NSString * flag;

@property (nonatomic,assign)id <completeDelegate>delegate;

@end
