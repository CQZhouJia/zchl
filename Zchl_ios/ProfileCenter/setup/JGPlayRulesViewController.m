//
//  JGPlayRulesViewController.m
//  NDP_eHome
//
//  Created by 冠美 on 16/4/18.
//  Copyright © 2016年 JGeHome. All rights reserved.
//

#import "JGPlayRulesViewController.h"

@interface JGPlayRulesViewController ()
@property (strong,nonatomic) MBProgressHUD *HUD;
@end

@implementation JGPlayRulesViewController

-(void)forcePortrait{
    //强制竖屏
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val = UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self forcePortrait];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SocialActivitySharedCallBack" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //--bb----------------------------------------------
    //添加观察者，接收分享后回调的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveSharedCallBack) name:@"SocialActivitySharedCallBack" object:nil];
    //--bb----------------------------------------------
    
    if(self.playRulesUrl){
       
//        //背景色
        [self.myWebView setBackgroundColor:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1]];
//        self.myWebView.backgroundColor = [UIColor whiteColor];
        //定义标题
        self.navigationTitleLabel.text = self.myTitle;
        self.myWebView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
        //判断是否显示分享按钮
        if (self.isShareButtonShow) {
            self.shareButton.hidden = NO;
        }else{
            self.shareButton.hidden = YES;
        }
        //加载网页
        if(self.playRulesUrl){
            
            NSURL * url;
            
            //-----------------------------------------
//            //1.self.shareCallBackStr 为@“”时，表示从活动进入，同时分享没奖励
//            if ([self.shareCallBackStr isEqualToString:@""]) {
//                
//                //其他的则不需拼接
//                url = [NSURL URLWithString:self.playRulesUrl];
//  
//            }
            
            
            //2.self.shareCallBackStr 为nil时，表示从邻友圈广告进入，网址中有？，拼接&uid=xxx
            //3.如果为特定（self.shareCallBackStr 有值）的分享后需上传数据的cell，网址中无？时，在其url后面拼接?uid=xxx
//            else{
                NSRange range=[self.playRulesUrl rangeOfString:@"?"];
                
                NSString * appendStr;
                if (range.length==0) { //url中没有？
                    //拼接
                    appendStr=[NSString stringWithFormat:@"?uid=%@",[StorageUserInfromation storageUserInformation].userID];
                }else{  //有？
                    //拼接
                    appendStr=[NSString stringWithFormat:@"&uid=%@",[StorageUserInfromation storageUserInformation].userID];
                }
                
                //未修改self.playRulesUrl的值，否则会修改分享时的链接
                NSString * urlStr= [self.playRulesUrl stringByAppendingString:appendStr];
                
                url = [NSURL URLWithString:urlStr];
                
//            }

            NSURLRequest *requset = [NSURLRequest requestWithURL:url];
            [self showHUDWithMessage:@"正在加载中..."];
            [self.myWebView loadRequest:requset];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{

    [MBProgressHUD hideHUDForView:self.myWebView animated:YES];
}

-(void)showHUDWithMessage:(NSString *)msg{
    
    self.HUD.mode = MBProgressHUDModeAnnularDeterminate;
    self.HUD = [MBProgressHUD showHUDAddedTo:self.myWebView animated:YES];
    self.HUD.transform = CGAffineTransformMakeScale(0, 0);
    self.HUD.labelText = msg;
    
    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [UIView animateWithDuration:0.5 animations:^{
            self.HUD.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:^(BOOL finished) {
    }];
}


- (IBAction)shareButtonClicked:(UIButton *)sender {
    
    //分享出去的内容
//    NSString *shareText = self.shareText?self.shareText:self.myTitle;
    
    NSString *shareText = @"邻信分享"; // -bb--
    
//    UIImage *image = self.shareImgStr?[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImgStr]]]:[UIImage imageNamed:@"60x60"];
    
    
    //-----------------------------------
    
    //这样分享的时候就不必先去下载图片 再跳出分享界面了
    UIImage * image;
    if (self.shareImage == [UIImage imageNamed:DefaultPictue]||self.shareImage == nil) {
        image=[UIImage imageNamed:@"60x60"];
    }
    else{
        image=self.shareImage;
    }
    //-----------------------------------
    
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"5654175467e58e84330009e1"
//                                      shareText:shareText
//                                     shareImage:image
//                                shareToSnsNames:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina]
//                                       delegate:self];
//    [UMSocialConfig hiddenNotInstallPlatforms:nil];

    
}

//点击分享按钮之后
//-(void)didSelectSocialPlatform:(NSString *)platformName withSocialData:(UMSocialData *)socialData{
//    
//    [self haveSharedCallBack];
//    
//    //分享出去的标题
////    NSString *shareTitle = self.shareText?self.myTitle:@"邻信分享";
//    
//     NSString *shareTitle = self.shareText?self.shareText:self.myTitle; //-bb-
//    
//    
//    NSRange range=[self.playRulesUrl rangeOfString:@"?"];
//     NSString *tailStr;
//    if (range.length==0) { //url中没有？
//        
//        tailStr = [NSString stringWithFormat:@"?uid=%@&tip=1",[StorageUserInfromation storageUserInformation].userID];
//        
//    }else{ //有？
//        tailStr = [NSString stringWithFormat:@"&uid=%@&tip=1",[StorageUserInfromation storageUserInformation].userID];
//    }
//    
////    NSString *tailStr;
////    if (self.tail && [self.tail isEqualToString:@"&tip=1"]) {
////        tailStr = @"&tip=1";
////    }else{
////        tailStr = @"?tip=1";
////    }
//    
////    if ([platformName isEqualToString:UMShareToQQ]) {
////        socialData.extConfig.qqData.url = [NSString stringWithFormat:@"%@%@",self.playRulesUrl,tailStr];
////        socialData.extConfig.qqData.title = shareTitle;
////    }else if ([platformName isEqualToString:UMShareToQzone]){
////        socialData.extConfig.qzoneData.url = [NSString stringWithFormat:@"%@%@",self.playRulesUrl,tailStr];
////        socialData.extConfig.qzoneData.title = shareTitle;
////    }else if ([platformName isEqualToString:UMShareToWechatSession]){
////        socialData.extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@%@",self.playRulesUrl,tailStr];
////        socialData.extConfig.wechatSessionData.title = shareTitle;
////    }else if ([platformName isEqualToString:UMShareToWechatTimeline]){
////        socialData.extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@%@",self.playRulesUrl,tailStr];
////        socialData.extConfig.wechatTimelineData.title = shareTitle;
////    }else if ([platformName isEqualToString:UMShareToWechatFavorite]){
////        socialData.extConfig.wechatFavoriteData.url = [NSString stringWithFormat:@"%@%@",self.playRulesUrl,tailStr];
////        socialData.extConfig.wechatFavoriteData.title = shareTitle;
////    }else if (platformName == UMShareToSina){
////        [[UMSocialData defaultData].extConfig.sinaData.urlResource setResourceType:UMSocialUrlResourceTypeWeb url:[NSString stringWithFormat:@"%@%@",self.playRulesUrl,tailStr]];
////    }
//}

//分享后返回APP 的通知回调（自己写的，非友盟的回调）
-(void)haveSharedCallBack
{
    //回调字符串不为空时才上传数据到服务端
    if ((![self.shareCallBackStr isEqualToString:@""])&&self.shareCallBackStr!=nil) {
        NSDictionary *dict = @{@"uid":[StorageUserInfromation storageUserInformation].userID};
        [ZTHttpTool postWithUrl:self.shareCallBackStr param:dict success:^(id responseObj) {
            
            //把uid上传给服务端就行了，不用其他操作
            NSLog(@"上传数据 成功");
        } failure:^(NSError *error) {
            NSLog(@"上传失败");
        }];
    }
    
}


- (IBAction)returnButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
