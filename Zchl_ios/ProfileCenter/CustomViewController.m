//
//  CustomViewController.m
//  Zchl_ios
//
//  Created by jglx on 17/5/4.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "CustomViewController.h"

@interface CustomViewController ()

@end

@implementation CustomViewController


- (IBAction)buttonClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.boomView.layer.cornerRadius = 3;
    self.boomView.layer.borderWidth = 1;
    self.boomView.layer.borderColor = Color_RGBA(224, 224, 224, 1.0).CGColor;
    [self initData];
}


-(void)initData{

    [ZTHttpTool postWithUrl:@"UserCenter/ServiceHelp" param:@{} success:^(id responseObj) {
        //
        NSLog(@"%@",responseObj);
        self.phonelabel.text = responseObj[@"Data"][@"phone"];
        self.youxianglabel.text = responseObj[@"Data"][@"email"];
        self.location.text = responseObj[@"Data"][@"address"];
    } failure:^(NSError *error) {
        //
    }];
}


@end
