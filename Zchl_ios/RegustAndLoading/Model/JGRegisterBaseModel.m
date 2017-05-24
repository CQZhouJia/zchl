//
//  JGRegisterBaseModel.m
//  NDP_eHome
//
//  Created by zhuangtao on 16/2/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGRegisterBaseModel.h"
#import "JGRegisterModel.h"
@implementation JGRegisterBaseModel
+ (NSDictionary *)objectClassInArray{
    return @{@"Data":[JGRegisterModel class]};
}
@end
