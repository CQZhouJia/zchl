//
//  JGCodeDataModel.h
//  NDP_eHome
//
//  Created by zhuangtao on 16/2/19.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGCodeDataModel : NSObject
//‘phone’:’15636323636’，//手机
//’code’:’xxxxxxxx’,//发送的短信验证码（客户端验证）
//’time’:’2016-02-15 17:17:53’, //发送时间
//’sendCount’:’1’  //发送的总次数
@property (assign,nonatomic)int sendCount;
@property (copy,nonatomic)NSString *phone;
@property (copy,nonatomic)NSString *code;
@property (copy,nonatomic)NSString *time;
@end
