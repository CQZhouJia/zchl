//
//  JGLoginModel.h
//  NDP_eHome
//
//  Created by zhuangtao on 16/2/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGLoginModel : NSObject
@property (copy,nonatomic)NSString * staticHttpUrl;
@property (copy,nonatomic)NSString * level; // 用户等级
@property (copy,nonatomic)NSString * score; // 积分
@property (copy,nonatomic)NSString *logo;
@property (copy,nonatomic)NSString *huanxin;//环信id
@property (copy,nonatomic)NSString *nickName;
@property (copy,nonatomic)NSString *sex;
@property (copy,nonatomic)NSString *age;
@property (copy,nonatomic)NSString *birthday;
@property (copy,nonatomic)NSString *signatures;
@property (copy,nonatomic)NSString *buildingId;//小区id
@property (copy,nonatomic)NSString *buildingName;
@property (assign,nonatomic)int state;//（0正常 1冻结 2禁言）
@property (copy,nonatomic)NSString *auditingState;
@property (copy,nonatomic)NSString *areaCode;
@property (copy,nonatomic)NSString *regTime;
@property (copy,nonatomic)NSString *phone;
@property (copy,nonatomic)NSString *uid;
@property (copy,nonatomic)NSString *token;
@property (copy,nonatomic)NSString *buildingChatId;
@property (copy,nonatomic)NSString *auditingManager;//1认证成功，2，认证失败，3认证中（管理员）
@property (copy,nonatomic)NSString *trueName;
@property (copy,nonatomic)NSString *buildingImg;

@property (nonatomic, assign)int            blockGroupMsg;  //是否提示群组消息（1不提示，其他提示）
@end
