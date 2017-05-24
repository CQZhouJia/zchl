//
//  JGSendCodeController.h
//  NDP_eHome
//
//  Created by zhuangtao on 16/3/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGBaseViewController.h"

@interface JGSendCodeController : JGBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *codetextfield;
@property (nonatomic,strong)NSString * code;
@end
