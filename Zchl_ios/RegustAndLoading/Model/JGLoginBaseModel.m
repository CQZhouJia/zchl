//
//  JGLoginBaseModel.m
//  NDP_eHome
//
//  Created by zhuangtao on 16/2/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGLoginBaseModel.h"
#import "JGLoginModel.h"
@implementation JGLoginBaseModel
+ (NSDictionary *)objectClassInArray{
    return @{@"Data":[JGLoginModel class]};
}
@end
