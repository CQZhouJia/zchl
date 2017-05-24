//
//  JGCodeDataBaseModel.m
//  NDP_eHome
//
//  Created by zhuangtao on 16/2/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGCodeDataBaseModel.h"
#import "JGCodeDataModel.h"
@implementation JGCodeDataBaseModel
+ (NSDictionary *)objectClassInArray{
    return @{@"Data":[JGCodeDataModel class]};
}
@end
