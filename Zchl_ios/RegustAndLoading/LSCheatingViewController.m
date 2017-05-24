//
//  LSCheatingViewController.m
//  LSOnline
//
//  Created by jglx on 17/4/14.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "LSCheatingViewController.h"
#import "AppDelegate.h"
#import "JGLoginModel.h"
#import "JGLoginBaseModel.h"


@interface LSCheatingViewController ()

@property (nonatomic,strong)UIButton * adTimerBtn;
@property (nonatomic,assign) int secondLB; // 广告倒计时

@property (nonatomic,strong)dispatch_source_t myTimer;

@property (nonatomic,assign)int state; //登录状态 0-成功，1-9999网络请求成功，参数错误等，10000为网络请求失败

@end

@implementation LSCheatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.secondLB = 5; //广告倒计时
    
    self.adTimerBtn.backgroundColor = [UIColor clearColor]; // 让用户看不见这个按钮 图片上有了
    [self.adTimerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //根据机型选择登陆图片
    [self imageForDifferentDevices];
    
    [self loginOurServers];
    
}

//开启定时器
- (void) startTimer{
    
    //===================创建GCD定时器============================
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 创建一个定时器(dispatch_source_t本质还是个OC对象)
    self.myTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
    uint64_t interval = (uint64_t)(1.0 * NSEC_PER_SEC);
    dispatch_source_set_timer(self.myTimer, start, interval, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(self.myTimer, ^{
        
        if (self.secondLB == 1) {
            
//            NSLog(@"========%d====%@======",self.secondLB,[StorageUserInfromation storageUserInformation].userID);
            
            [self.adTimerBtn setTitle:[NSString stringWithFormat:@"跳过(%d)", self.secondLB] forState:UIControlStateNormal];
            self.adTimerBtn.hidden = YES;
            
            // 取消定时器
            dispatch_cancel(self.myTimer);
            self.myTimer = nil;
            [self successInMainVC];
            
            if (self.state == 0) { //state - 0 登录服务器已经成功，等待定时器 到点 进入主界面
                [self successInMainVC];
                
            }else{  //均为 登录失败
                
                [self failedInLoginVC];
            }
            
        }else{
//            NSLog(@"========%d====%@======",self.secondLB,[StorageUserInfromation storageUserInformation].userID);
            self.secondLB--;
            
            [self.adTimerBtn setTitle:[NSString stringWithFormat:@"跳过(%d)", self.secondLB] forState:UIControlStateNormal];
            
        }
        
    });
    
    // 启动定时器
    dispatch_resume(self.myTimer);
    
    //===============================================
}


//登录自己服务器
- (void)loginOurServers{
    
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    NSString *passWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"];
    
    StorageUserInfromation *Storage = [StorageUserInfromation storageUserInformation];
    if (!Storage.dingweiCity) {
        Storage.dingweiCity = @"重庆";
        Storage.coordX = @"0";
        Storage.coordY = @"0";
    }
    NSString *pwdEncrypt = [JGEncrypt encryptWithContent:passWord type:kCCEncrypt key:TextKey];
    NSDictionary *dict = @{@"platform":@"2",@"phone":userName,@"pwd":pwdEncrypt,@"coordX": Storage.coordX,@"coordY":Storage.coordY,@"cityName":Storage.dingweiCity};
    NSLog(@"%@",dict);
    [ZTHttpTool postWithUrl:@"User/Login" param:dict success:^(id responseObj) {
        NSLog(@"%@",responseObj);
        JGLoginBaseModel *baseModel = [JGLoginBaseModel mj_objectWithKeyValues:responseObj];
        self.state = baseModel.State; //保存请求服务器状态
    
        //开启定时器
        [self startTimer];
        
        if (!baseModel.State) { // State - 0 为成功
            
//            NSLog(@"%@",responseObj[@"Data"]);
            
            JGLoginModel *login = [JGLoginModel mj_objectWithKeyValues:baseModel.Data];
            StorageUserInfromation *storage = [StorageUserInfromation storageUserInformation];
            storage.level = login.level;
            storage.score = login.score;
            storage.Huanxin = login.huanxin;
            storage.pwd = pwdEncrypt;
            storage.areaCode = login.areaCode;
            storage.buildingID = login.buildingId;
            storage.buildingChatId = login.buildingChatId;
            storage.token = login.token;
            storage.userID = login.uid;
            storage.auditingManager = [login.auditingManager intValue];
            storage.loginPhone = login.phone;
            Storage.nickName = login.nickName;
            Storage.auditingState = login.auditingState;
            Storage.state = login.state;
            
            Storage.buildingName =login.buildingName;
            Storage.gender = login.sex;
            Storage.age = login.age;
            Storage.userHeadImage = [NSString stringWithFormat:@"%@%@",login.staticHttpUrl,login.logo];
            storage.birthday = login.birthday;
            storage.trueName = login.trueName;
            storage.buildingImageUrl = login.buildingImg;
            storage.blockGroupMsg=login.blockGroupMsg;
            
            if (self.secondLB == 1) { //登录时间已经超过 5s，直接进入
                
                [self successInMainVC];
            }
            
        }else{
            
          
            if (self.secondLB == 1) { //登录时间已经超过 5s，直接进入
                
                [self failedInLoginVC];
            }
        }
        
    } failure:^(NSError *error) {
        self.state =10000; //用于表示登录失败
        
        //登录失败，未开启定时器 直接进入
        [self failedInLoginVC];
        
    }];
}

//登录主界面
-(void)successInMainVC{
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    delegate.window.rootViewController = mainStoryboard.instantiateInitialViewController;
    
    //推送通知
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

//登录输入密码界面
-(void)failedInLoginVC{
    
    LSLogoViewController *loginVC = [[LSLogoViewController alloc]init];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:loginVC];
}

#pragma mark -跳过按钮回调-
-(void)jumpAction:(UIButton *) button{ //直接登录
    
    [self successInMainVC];
    
    if (self.state == 0) { //state - 0 登录服务器已经成功，等待定时器 到点 进入主界面
        [self successInMainVC];
    }
}

-(void)imageForDifferentDevices{
    
    self.adTimerBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-90, 60, 70, 40)];
    self.adTimerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    
    self.adTimerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.adTimerBtn.layer.cornerRadius =5;
    self.adTimerBtn.layer.masksToBounds = YES;
//    self.adTimerBtn.backgroundColor = [UIColor colorWithRed:178/255.0f green:178/255.0f blue:178/255.0f alpha:0.5];
    self.adTimerBtn.backgroundColor = [UIColor greenColor];
    [self.adTimerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    [self.adTimerBtn setTitle:[NSString stringWithFormat:@"跳过(%d)", self.secondLB] forState:UIControlStateNormal];
    [self.adTimerBtn addTarget:self action:@selector(jumpAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.adTimerBtn];
    
    self.adTimerBtn.backgroundColor = [UIColor clearColor];
    [self.adTimerBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    
    //查看本地是否有存储的启动图片
    NSUserDefaults * setupPic =[NSUserDefaults standardUserDefaults];
    
    NSData * imageDate =[setupPic objectForKey:@"setupPic"];
    
    if (imageDate) {
        UIImage * image =[UIImage imageWithData:imageDate];
        
        self.cheatImageView.image=image;
    }
    
    
    else{
        
//        if (SCREEN_WIDTH == 320) {
//            self.cheatImageView.image = [UIImage imageNamed:@"c640x1136"];
//        }else if (SCREEN_WIDTH == 375){
//            
//            UIImage * enterImage=[UIImage imageNamed:@"c750x1136"];
//            self.cheatImageView.image = enterImage;
//        }else if (SCREEN_WIDTH == 414){
//            self.cheatImageView.image = [UIImage imageNamed:@"c750x1136"];
//        }else{
//            self.cheatImageView.image = [UIImage imageNamed:@"c1242x1334"];
//        }
        
    }
    
    
}


@end
