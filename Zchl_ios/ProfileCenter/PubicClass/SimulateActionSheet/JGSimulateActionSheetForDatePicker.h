//
//  JGSimulateActionSheetForDatePicker.h
//  NDP_eHome
//
//  Created by 冠美 on 16/2/2.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGSimulateActionSheetForDatePickerDelegate <NSObject>

@optional
- (void)actionDone2;
- (void)actionCancle2;
@end

@interface JGSimulateActionSheetForDatePicker : UIView
@property (nonatomic,strong) id<JGSimulateActionSheetForDatePickerDelegate> delegate;
@property (nonatomic,strong)UIDatePicker * pickerView;
+(instancetype)styleDefault;
-(void)show:(UIViewController *)controller;
-(void)dismiss:(UIViewController *)controller;
//-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anime;
//-(NSInteger)selectedRowInComponent:(NSInteger)component;
@end