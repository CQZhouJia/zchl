//
//  JGPayResultView.h
//  NDP_eHome
//
//  Created by zhuangtao on 16/3/22.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGPayResultView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *ResultImageView;
@property (weak, nonatomic) IBOutlet UILabel *resultText;
@property (weak, nonatomic) IBOutlet UIButton *completeOrAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
