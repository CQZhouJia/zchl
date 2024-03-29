//
//  JGSimulateActionSheetForDatePicker.m
//  NDP_eHome
//
//  Created by 冠美 on 16/2/2.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#import "JGSimulateActionSheetForDatePicker.h"



@interface JGSimulateActionSheetForDatePicker()
{
    UIColor *toolBarColor;
    UIColor *textColorNormal;
    UIColor *textColorPressed;
    UIColor *pickerBgColor;
}
@property (nonatomic,strong)UIView * toolBar;

@end

@implementation JGSimulateActionSheetForDatePicker
+(instancetype)styleDefault{
    JGSimulateActionSheetForDatePicker* sheet = [[JGSimulateActionSheetForDatePicker alloc]initWithFrame:CGRectMake(
                                                                                            0,
                                                                                            0,
                                                                                            UIScreen.mainScreen.bounds.size.width,
                                                                                            UIScreen.mainScreen.bounds.size.height)];
    
    [sheet setBackgroundColor:[UIColor clearColor]];
    sheet.toolBar = [sheet actionToolBar];
    sheet.pickerView = [sheet actionPicker];
    [sheet addSubview:sheet.toolBar];
    [sheet addSubview:sheet.pickerView];
    
    return sheet;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        toolBarColor = RGBACOLOR(240.0, 240.0, 240.0, 0.9);
        textColorNormal = RGBACOLOR(0, 146.0, 255.0, 1);
        textColorPressed = RGBACOLOR(209.0, 213.0, 219.0, 0.9);
        pickerBgColor = textColorPressed;
    }
    
    return self;
}
-(void)setupInitPostion:(UIViewController *)controller{
    [UIApplication.sharedApplication.keyWindow?UIApplication.sharedApplication.keyWindow:UIApplication.sharedApplication.windows[0]
                                                                              addSubview:self];
    [self.superview bringSubviewToFront:self];
    CGFloat pickerViewYpositionHidden = UIScreen.mainScreen.bounds.size.height;
    [self.pickerView setFrame:CGRectMake(self.pickerView.frame.origin.x,
                                         pickerViewYpositionHidden,
                                         self.pickerView.frame.size.width,
                                         self.pickerView.frame.size.height)];
    [self.toolBar setFrame:CGRectMake(self.toolBar.frame.origin.x,
                                      pickerViewYpositionHidden,
                                      self.toolBar.frame.size.width,
                                      self.toolBar.frame.size.height)];
}
-(void)show:(UIViewController *)controller{
    [self setupInitPostion:controller];
    
    CGFloat toolBarYposition = UIScreen.mainScreen.bounds.size.height -
    (self.pickerView.frame.size.height + self.toolBar.frame.size.height);
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];
                         [controller.view setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
                         [controller.navigationController.navigationBar setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
                         
                         [self.toolBar setFrame:CGRectMake(self.toolBar.frame.origin.x,
                                                           toolBarYposition,
                                                           self.toolBar.frame.size.width,
                                                           self.toolBar.frame.size.height)];
                         
                         [self.pickerView setFrame:CGRectMake(self.pickerView.frame.origin.x,
                                                              toolBarYposition+self.toolBar.frame.size.height,
                                                              self.pickerView.frame.size.width,
                                                              self.pickerView.frame.size.height)];
                     }
                     completion:nil];
    
}
-(void)dismiss:(UIViewController *)controller{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self setBackgroundColor:[UIColor clearColor]];
                         [controller.view setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
                         [controller.navigationController.navigationBar setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
                         [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                             UIView* v = (UIView*)obj;
                             [v setFrame:CGRectMake(v.frame.origin.x,
                                                    UIScreen.mainScreen.bounds.size.height,
                                                    v.frame.size.width,
                                                    v.frame.size.height)];
                         }];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
    
}

-(UIView *)actionToolBar{
    UIView *tools = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [FlexibeFrame flexibleFloat: 320], 44)];
    tools.backgroundColor = toolBarColor;
    UIButton *cancle = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:textColorPressed forState:UIControlStateHighlighted];
    [cancle setTitleColor:textColorNormal forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(actionCancle2) forControlEvents:UIControlEventTouchUpInside];
    [cancle sizeToFit];
    [tools addSubview:cancle];
    
    cancle.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cancleConstraintLeft = [NSLayoutConstraint constraintWithItem:cancle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10.0f];
    NSLayoutConstraint *cancleConstrainY = [NSLayoutConstraint constraintWithItem:cancle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    [tools addConstraint:cancleConstraintLeft];
    [tools addConstraint:cancleConstrainY];
    
    UIButton *ok = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [ok setTitle:@"确定" forState:UIControlStateNormal];
    [ok setTitleColor:textColorNormal forState:UIControlStateNormal];
    [ok setTitleColor:textColorPressed forState:UIControlStateHighlighted];
    [ok addTarget:self action:@selector(actionDone2) forControlEvents:UIControlEventTouchUpInside];
    [ok sizeToFit];
    [tools addSubview:ok];
    
    ok.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *okConstraintRight = [NSLayoutConstraint constraintWithItem:ok attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-10.0f];
    NSLayoutConstraint *okConstraintY = [NSLayoutConstraint constraintWithItem:ok attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    [tools addConstraint:okConstraintRight];
    [tools addConstraint:okConstraintY];
    
    return tools;
}

-(UIDatePicker *)actionPicker;{
    UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44,SCREEN_WIDTH,200)];
    [picker setBackgroundColor:pickerBgColor];
    return picker;
}

//-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anime{
//    [_pickerView selectRow:row inComponent:component animated:anime];
//}
//
//-(NSInteger)selectedRowInComponent:(NSInteger)component{
//    return [_pickerView selectedRowInComponent:component];
//}

-(void)actionDone2{
    if([_delegate respondsToSelector:@selector(actionDone2)]){
        [_delegate actionDone2];
    }
}

-(void)actionCancle2{
    if ([_delegate respondsToSelector:@selector(actionCancle2)]) {
        [_delegate actionCancle2];
    }
}
-(void)setDelegate:(id<JGSimulateActionSheetForDatePickerDelegate>)delegate{
    _delegate = delegate;
}
@end