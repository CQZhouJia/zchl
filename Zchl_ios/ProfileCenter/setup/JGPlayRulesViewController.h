//
//  JGPlayRulesViewController.h
//  NDP_eHome
//
//  Created by 冠美 on 16/4/18.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGPlayRulesViewController : UIViewController

@property (nonatomic,assign) BOOL isShareButtonShow; //是否显示分享按钮

@property (nonatomic,copy)NSString *playRulesUrl;

@property (nonatomic,copy) NSString *myTitle;//标题

@property (weak, nonatomic) IBOutlet UILabel *navigationTitleLabel;

@property (weak, nonatomic) IBOutlet UIWebView *myWebView;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (nonatomic,copy) NSString *tail;//分享地址尾部拼接字符串

@property (nonatomic,copy) NSString *shareText; //分享的标题

@property (nonatomic,copy) NSString *shareImgStr;   //分享图片的网址

//----------------------------
@property (nonatomic,copy) NSString * shareCallBackStr; //新增 - 分享成功后回传数据地址

@property (nonatomic,strong) UIImage * shareImage;

@end
