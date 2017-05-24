//
//  CerMessageViewController.h
//  Zchl_ios
//
//  Created by jglx on 17/4/26.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CerMessageViewController : JGBaseViewController


@property (weak, nonatomic) IBOutlet UITextField *username;


@property (weak, nonatomic) IBOutlet UITextField *idcard;


@property (weak, nonatomic) IBOutlet UIView *backView;


@property (weak, nonatomic) IBOutlet UIButton *upphotoBtn;



@property (weak, nonatomic) IBOutlet UIImageView *photoImage;


@property (weak, nonatomic) IBOutlet UIButton *ephotobutton;


@property (weak, nonatomic) IBOutlet UIButton *boomcerbutton;

@end
