//
//  JG SimulateActionSheet.h
//  NDP_eHome
//
//  Created by 冠美 on 16/2/1.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SimulateActionSheetDelegate <NSObject>

@optional
- (void)actionDone;
- (void)actionCancle;
@end

@interface JG_SimulateActionSheet : UIView
@property (nonatomic,strong) id<SimulateActionSheetDelegate> delegate;
+(instancetype)styleDefault;
-(void)show:(UIViewController *)controller;
-(void)dismiss:(UIViewController *)controller;
-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anime;
-(NSInteger)selectedRowInComponent:(NSInteger)component;
@end
