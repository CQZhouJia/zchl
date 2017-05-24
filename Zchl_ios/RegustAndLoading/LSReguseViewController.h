//
//  LSReguseViewController.h
//  LSOnline
//
//  Created by jglx on 17/4/12.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "JGBaseViewController.h"

@interface LSReguseViewController : JGBaseViewController

@property (nonatomic,strong)NSString * toptitleStr;

@property (nonatomic,strong)NSString * boomButtonStr;

@property (weak, nonatomic) IBOutlet UIView *topview;

@property (weak, nonatomic) IBOutlet UILabel *toptitileLabel;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UITextField *phoneNIckName;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;

@property (weak, nonatomic) IBOutlet UITextField *phoneCodetTextfield;

@property (weak, nonatomic) IBOutlet UIButton *getphonebutton;

@property (weak, nonatomic) IBOutlet UITextField *passwordtextfield;

@property (weak, nonatomic) IBOutlet UITextField *anthorpasstextfield;

@property (weak, nonatomic) IBOutlet UIButton *newcompletebutton;

@property (weak, nonatomic) IBOutlet UILabel *boomLabel;



@end
