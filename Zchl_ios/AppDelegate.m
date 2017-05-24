//
//  AppDelegate.m
//  Zchl_ios
//
//  Created by jglx on 17/4/25.
//  Copyright © 2017年 zhoujia. All rights reserved.
//

#import "AppDelegate.h"
#import "JZLocationConverter.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface AppDelegate ()


{
    NSDictionary * alipayDic;
}

@property (nonatomic,strong)CLLocationManager   * locationManager;

@end

@implementation AppDelegate

-(void)AlipayMoneyInfo:(NSNotification *)text{
    
    if (alipayDic == nil) {
        alipayDic =[[NSMutableDictionary alloc]init];
    }
    alipayDic = text.userInfo;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     [self setIQKeyBoard];
    
    //添加观察者 接收支付宝回调的信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AlipayMoneyInfo:) name:@"AlipayMoneyInfo" object:nil];
    

    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoLogin"]) {
        // 已经登录后 自动登录 过去选择有跳过的启动图
        LSCheatingViewController * cheatVC = [[LSCheatingViewController alloc] init];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:cheatVC];
        [self.window makeKeyAndVisible];
    }else{
        //未开启自动登录
        LSLogoViewController *page  = [[LSLogoViewController alloc]initWithNibName:@"LSLogoViewController" bundle:nil];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:page];
        [self.window makeKeyAndVisible];
        [self startLocation];
    }

    return YES;
}

-(void)setIQKeyBoard{
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}

- (void)startLocation
{
    
    if ([CLLocationManager locationServicesEnabled]) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //控制定位精度,越高耗电量越大。
        
        _locationManager.distanceFilter = 1; //控制定位服务更新频率。单位是“米”
        
        [_locationManager startUpdatingLocation];
        
        //在ios 8.0下要授权
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
            
            [_locationManager requestWhenInUseAuthorization];  //调用了这句,就会弹出允许框了.
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation * currLocation = [locations firstObject];
    // CLLocationCoordinate2D coordinate = locations.coordinate;//位置坐标
    
    //单例存值
    StorageUserInfromation *Loacition = [StorageUserInfromation storageUserInformation];
    
    //得到newLocation
    CLLocation *loc = currLocation;
    CLLocationCoordinate2D coord = [loc coordinate];
    coord = [JZLocationConverter wgs84ToBd09:coord];
    Loacition.coordX = [[NSString alloc] initWithFormat:@"%.6f",coord.longitude];
    Loacition.coordY = [NSString stringWithFormat:@"%.6f",coord.latitude];
    
    NSLog(@"longitude -- %@  latitude  -- %@",Loacition.coordX,Loacition.coordY);
    
    NSString * string1 = [NSString stringWithFormat:@"%.6f",coord.longitude];
    NSString *  string2 = [NSString stringWithFormat:@"%.6f",coord.latitude];
    
    //    NSLog(@"KKKKK____________%@%@",string1,string2);
    
    //    [self.deleOfModel addObserver:self forKeyPath:@"dataListArray" options:NSKeyValueObservingOptionNew context:nil];
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:currLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *place in placemarks) {
            NSDictionary * location = [place addressDictionary];
            NSLog(@"国家:%@",[location objectForKey:@"Country"]);
            NSLog(@"城市:%@",[location objectForKey:@"State"]);
            NSLog(@"区:%@",[location objectForKey:@"SubLocality"]);
            NSLog(@"位置:%@",place.name);
            NSLog(@"国家:%@",place.country);
            NSLog(@"城市:%@",place.locality);
            NSLog(@"区:%@",place.subLocality);
            NSLog(@"街道:%@",place.thoroughfare);
            NSLog(@"子街道:%@",place.subThoroughfare);
            StorageUserInfromation *user = [StorageUserInfromation storageUserInformation];
            user.dingweiCity=[[NSString stringWithFormat:@"%@",[location objectForKey:@"State"]] substringToIndex: [[location objectForKey:@"State"] length]-1];
            user.city = [NSString stringWithFormat:@"%@%@",[location objectForKey:@"State"],[location objectForKey:@"SubLocality"]];
        }
    }];
    [self.locationManager stopUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"获取定位失败");
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    //如果极简开发包不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给开 发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                  standbyCallback:^(NSDictionary *resultDic) {
                                                      //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了,所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就是在这个方 法里面处理跟 callback 一样的逻辑】
                                                      NSLog(@"result = %@",resultDic);
                                                      
                                                      //将回调结果传送到支付页面显示结果
                                                      
                                                      NSDictionary * showOneDic = @{@"resultStatus":resultDic[@"resultStatus"]};
                                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"PostToZhiFuPageToShow" object:nil userInfo:showOneDic];
                                                      
                                                      if([[resultDic valueForKey:@"resultStatus"] integerValue] == 9000){
                                                          NSString *orderEncode = alipayDic[@"orderNo"];
                                                          NSString *moneyEncode = [JGEncrypt encryptWithContent:alipayDic[@"money"] type:kCCEncrypt key:TextKey];
                                                          
                                                          NSDictionary  *dic = @{@"order":orderEncode,@"money":moneyEncode};
                                                          [ZTHttpTool postWithUrl:@"UserCenter/Recharge" param:dic success:^(id responseObj) {
                                                              
                                                              NSLog(@"%@",responseObj);
                                                              
                                                              //--此部分显示支付回调结果 通过发送通知到支付页面去显示--
                                                              
                                                              //                                                             [self showHint:responseObj[@"Msg"]];
                                                              //                                                              if ([responseObj[@"State"] integerValue] == 0||[responseObj[@"State"] integerValue] == 1) {
                                                              //                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              //                                                              }
                                                              
                                                          } failure:^(NSError *error) {
                                                              
                                                              
                                                          }];
                                                          
                                                          
                                                      }else{
                                                          
                                                          
                                                          //                                                          [self showHint:@"支付失败"];
                                                      }
                                                      
                                                  }];
    }
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中,商户 app 在后台很可能被系统 kill 了, 所以 pay 接口的 callback 就会失效,请商户对 standbyCallback 返回的回调结果进行处理,就 是在这个方法里面处理跟 callback 一样的逻辑】
            NSLog(@"result = %@",resultDic);
            
            //将回调结果传送到支付页面显示结果
            
            NSDictionary * showOneDic = @{@"resultStatus":resultDic[@"resultStatus"]};            [[NSNotificationCenter defaultCenter] postNotificationName:@"PostToZhiFuPageToShow" object:nil userInfo:showOneDic];
            
            if([[resultDic valueForKey:@"resultStatus"] integerValue] == 9000){
                NSString *orderEncode = alipayDic[@"orderNo"];
                NSString *moneyEncode = [JGEncrypt encryptWithContent:alipayDic[@"money"] type:kCCEncrypt key:TextKey];
                
                NSDictionary  *dic = @{@"order":orderEncode,@"money":moneyEncode};
                [ZTHttpTool postWithUrl:@"UserCenter/Recharge" param:dic success:^(id responseObj) {
                    
                    NSLog(@"%@",responseObj);
                    
                    //--此部分显示支付回调结果 通过发送通知到支付页面去显示--
                    
                    //                    [self showHint:responseObj[@"Msg"]];
                    //                    if ([responseObj[@"State"] integerValue] == 0||[responseObj[@"State"] integerValue] == 1) {
                    //                        [self.navigationController popViewControllerAnimated:YES];
                    //                    }
                    
                } failure:^(NSError *error) {
                    
                    
                }];
                
                
            }else{
                
                
                //                                                          [self showHint:@"支付失败"];
            }
            
        }];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
