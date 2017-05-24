//
//  JGBaseViewController.h
//  NDP_eHome
//
//  Created by 冠美 on 15/12/29.
//  Copyright © 2015年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JGBaseViewController : UIViewController

-(void)showTextHUD:(NSString *)text;
//保存取出（userDefaults）
- (void)saveToDefaults:(id)object key:(NSString *)key;
- (id)getObjectFromUserDefaults:(NSString *)key;
-(void)showHUD;
- (void)hideHud;
-(void)showHUDWithMessage:(NSString *)msg;

-(void)viewChangeColorWithTwoColor:(UIColor *)colorone anotherColor:(UIColor *)colorTwo andView:(UIView *)userView;

-(CGRect)getStrHeight:(NSString *)str size:(CGSize)size strfont:(UIFont *)font;

@end
