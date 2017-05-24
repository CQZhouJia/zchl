//
//  searchViewController.h
//  Zchl_ios
//
//  Created by jglx on 17/5/2.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol gaojibackDelegate <NSObject>

-(void)gaojirefreshMessage:(NSString *)titleStr areaCode:(NSString *)areaCode minSalary:(NSString *)minSalary maxSalary:(NSString *)maxSalary;

@end

@interface searchViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nametex;

@property (weak, nonatomic) IBOutlet UITextField *moneyone;

@property (weak, nonatomic) IBOutlet UITextField *moneyteo;

@property (weak, nonatomic) IBOutlet UIButton *searchbtn;


@property (weak, nonatomic) IBOutlet UIButton *locationbutton;

@property (nonatomic,assign) id <gaojibackDelegate>delegate;

@end
