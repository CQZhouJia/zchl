//
//  JGRegisterModel.h
//  NDP_eHome
//
//  Created by zhuangtao on 16/2/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface JGRegisterModel : NSObject
@property (copy,nonatomic)NSString *logo;
@property (copy,nonatomic)NSString *huanxin;//环信id
@property (copy,nonatomic)NSString *nickName;
@property (copy,nonatomic)NSString *sex;
@property (copy,nonatomic)NSString *age;
@property (copy,nonatomic)NSString *birthday;
@property (copy,nonatomic)NSString *signatures;
@property (copy,nonatomic)NSString *buildingId;//小区id
@property (assign,nonatomic)int state;//（0正常 1冻结 2禁言）
@property (copy,nonatomic)NSString *auditingState;
@property (copy,nonatomic)NSString *areaCode;
@property (copy,nonatomic)NSString *regTime;
@property (copy,nonatomic)NSString *phone;
@property (copy,nonatomic)NSString *uid;
@property (copy,nonatomic)NSString *token;
@property (copy,nonatomic)NSString *buildingChatId;
@end
