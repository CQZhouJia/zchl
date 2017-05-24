//
//  JGUserFadeBackViewController.h
//  NDP_eHome
//
//  Created by 冠美 on 16/2/2.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGUserFadeBackViewController : UIViewController
/**
 *  1.用户反馈 2.举报
 */
@property (assign,nonatomic)int state;

@property (strong,nonatomic) NSString *titleStr;
@property (weak, nonatomic) IBOutlet UILabel *myTitle;

@property (weak, nonatomic) IBOutlet UITextView *myTextView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

- (IBAction)backBtnClick:(id)sender;
- (IBAction)commitBtnClick:(id)sender;
@end
