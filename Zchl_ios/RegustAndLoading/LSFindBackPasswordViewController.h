//
//  LSFindBackPasswordViewController.h
//  LSOnline
//
//  Created by jglx on 17/4/12.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "JGBaseViewController.h"
#import "HomeTextField.h"

@interface LSFindBackPasswordViewController : JGBaseViewController

@property (weak, nonatomic) IBOutlet UIView *topView;


@property (weak, nonatomic) IBOutlet UIView *mainView;


@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;


@property (weak, nonatomic) IBOutlet UITextField *codeTextField;




@property (weak, nonatomic) IBOutlet UITextField *userPsdTextField;

@property (weak, nonatomic) IBOutlet HomeTextField *userPsdReqTextField;



@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextClick;




@end
