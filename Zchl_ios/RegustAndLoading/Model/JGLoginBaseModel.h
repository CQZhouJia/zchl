//
//  JGLoginBaseModel.h
//  NDP_eHome
//
//  Created by zhuangtao on 16/2/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGLoginModel;
@interface JGLoginBaseModel : NSObject
@property (assign,nonatomic) int State;
@property (copy,nonatomic)NSString *Msg;
@property (strong,nonatomic)JGLoginModel *Data;
@end
