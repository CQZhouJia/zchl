//
//  JGBaseViewController.m
//  NDP_eHome
//
//  Created by 冠美 on 15/12/29.
//  Copyright © 2015年 JGeHome. All rights reserved.
//

#import "JGBaseViewController.h"
#import "UIView+Toast.h"
//#import <EaseMobSDKFull/EaseMob.h>
@interface JGBaseViewController ()
{
//    MBProgressHUD *HUD;
}
@property (strong,nonatomic) MBProgressHUD *HUD;
@end

@implementation JGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"my controller");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)showTextHUD:(NSString *)text{
    [self.view makeToast:text duration:1.0 position:[NSValue valueWithCGPoint:CGPointMake(self.view.bounds.size.width/2, SCREEN_HEIGHT - 100)]];
}
//保存到userDefault
- (void)saveToDefaults:(id)object key:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//取出
- (id)getObjectFromUserDefaults:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

-(void)hideHUD{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}
-(void)showHUD{
   self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.transform = CGAffineTransformMakeScale(0, 0);
    self.HUD.labelText = @"正在加载中...";
    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.HUD.transform = CGAffineTransformMakeScale(1, 1);
        }];
    } completion:^(BOOL finished) {
    }];
}
-(void)showHUDWithMessage:(NSString *)msg{
    
    self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.transform = CGAffineTransformMakeScale(0, 0);
    self.HUD.labelText = msg;
    
    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.HUD.transform = CGAffineTransformMakeScale(1, 1);
        }];
    } completion:^(BOOL finished) {
    }];
}
-(MBProgressHUD *)showHUD:(NSString *)msg {
    self.HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.HUD.labelText = msg;
    return self.HUD;
}



-(void)viewChangeColorWithTwoColor:(UIColor *)colorone anotherColor:(UIColor *)colorTwo andView:(UIView *)userView{
    CAGradientLayer * gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorone.CGColor,(__bridge id)colorTwo.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = CGRectMake(0, 0, userView.frame.size.width, userView.frame.size.height);
    [userView.layer addSublayer:gradientLayer];
}

-(CGRect)getStrHeight:(NSString *)str size:(CGSize)size strfont:(UIFont *)font{
    
//    CGSize size = CGSizeMake(WIDTH - 20, MAXFLOAT);
//    NSString * strings = [NSString stringWithFormat:@"jdlsadjhaslkd"];
//    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
//    CGRect rects = [strings boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
    
    NSDictionary * attributes = @{NSFontAttributeName:font};
     CGRect rects = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics attributes:attributes context:nil];
    return rects;
    
}

@end
