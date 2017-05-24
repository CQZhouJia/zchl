//
//  StorageUserInfromation.m
//  letter
//
//  Created by 钟亮 on 15/8/13.
//  Copyright (c) 2015年 huangcen. All rights reserved.
//

#import "StorageUserInfromation.h"
#import <UIKit/UIKit.h>
#import "sys/sysctl.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation StorageUserInfromation

- (UIInterfaceOrientationMask)interfaceOrientationMask {
    if (self.flag == 1) {
        return UIInterfaceOrientationMaskLandscape;
    }else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

+ (StorageUserInfromation *)storageUserInformation
{
    static  StorageUserInfromation *user = nil;
    if (!user) {
        user = [[StorageUserInfromation alloc] init];
    }
    return user;
}

+(UIImage*)scaleToSize:(CGSize)size image:(id)self2
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, YES, 2.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // 绘制改变大小的图片
    [self2 drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

-(UIImage*)convertViewToImage:(UIView*)v
{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (NSString*)doDevicePlatform //判断机型
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        
        platform = @"iPhone";
        
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        
        platform = @"iPhone 3G";
        
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        
        platform = @"iPhone 3GS";
        
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        
        platform = @"iPhone 4";
        
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        
        platform = @"iPhone 4S";
        
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        
        platform = @"iPhone 5";
        
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        
        platform = @"iPhone 5C";
        
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        
        platform = @"iPhone 5S";
        
    }else if ([platform isEqualToString:@"iPhone7,1"]) {
        
        platform = @"iPhone 6";
       
    }else if ([platform isEqualToString:@"iPhone7,2"]) {
        
        platform = @"iPhone 6S";
        
    }else if ([platform isEqualToString:@"iPod4,1"]) {
        
        platform = @"iPod touch 4";
        
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        
        platform = @"iPod touch 5";
        
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        
        platform = @"iPod touch 3";
        
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        
        platform = @"iPod touch 2";
        
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        
        platform = @"iPod touch";
        
    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {
        
        platform = @"iPad 3";
        
    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        
        platform = @"iPad 2";
        
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        
        platform = @"iPad 1";
        
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        
        platform = @"ipad mini";
        
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        
        platform = @"ipad 3";
        
    }
    
    return platform;
}

//storyBoard view自动适配
+ (void)storyBoradAutoLay:(UIView *)allView
{
    for (UIView *temp in allView.subviews) {
        temp.frame = CGRectMake(temp.frame.origin.x, temp.frame.origin.y, temp.frame.size.width, temp.frame.size.height);
        for (UIView *temp1 in temp.subviews) {
            temp1.frame = CGRectMake(temp1.frame.origin.x, temp1.frame.origin.y, temp1.frame.size.width, temp1.frame.size.height);
        }
    }
}
//等比压缩
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *) imageCompressForWidth2:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth
{
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) * height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

-(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}
-(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}
-(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}
-(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *)stringFromDataString:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString2:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd  HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString3:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString33:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SS"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MM-dd"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString4:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString5:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
//        [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)mystringFromDataString5:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+(NSString *)stringFromDataString6:(NSString *)str{
    NSString *dateString=str;
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd'T'HH:mm:ss"];
    NSDate *date2=[dateFormatter dateFromString:dateString];
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"MM-dd HH:mm"];
    NSString *dateString2=[dateFormatter2 stringFromDate:date2];
    return dateString2;
}
+ (NSString *)minuteDescription:(NSString *)dateSting
{
    NSString *dateString=dateSting;
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    NSDate *date2=[dateFormatter2 dateFromString:dateString];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date2];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay]) {//当天
        return @"今天";
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        return @"昨天";
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 365) {//间隔一年内
        [dateFormatter setDateFormat:@"MM-dd"];
        return [dateFormatter stringFromDate:date2];
    } else {//一年以前
        NSInteger inter = [[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]];
        inter = inter/(86400 * 365);
        return [NSString stringWithFormat:@"%ld年前",inter];
    }
}
+ (NSString *)minuteDescription2:(NSString *)dateSting
{
    NSString *dateString=dateSting;
    NSDateFormatter *dateFormatter2=[[NSDateFormatter alloc]init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date2=[dateFormatter2 dateFromString:dateString];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:date2];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    if ([theDay isEqualToString:currentDay]) {//当天
        return @"今天";
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == 86400) {//昨天
        return @"昨天";
    } else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < 86400 * 365) {//间隔一年内
        [dateFormatter setDateFormat:@"MM-dd"];
        return [dateFormatter stringFromDate:date2];
    } else {//一年以前
        NSInteger inter = [[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]];
        inter = inter/(86400 * 365);
        return [NSString stringWithFormat:@"%ld年前",inter];
    }
}
+(void)initTableViewRefresh:(UITableView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller{
    static int i=1;
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
        i=1;
        // 进入刷新状态后会自动调用这个block
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        NSDictionary * dcit =@{@"platform":@"2",@"uid":storage.userID,@"phone":storage.loginPhone,@"token":storage.token,@"pn":@"1",@"rows":@"10"};//
        [ZTHttpTool postWithUrl:url param:dcit success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"%@",responseObj[@"Msg"]);
            [myTableView.mj_header endRefreshing];
            if ([responseObj[@"State"] integerValue] == 0) {
                NSArray * dict = responseObj[@"Data"];
                if ([dict count]!=0) {
                    [array removeAllObjects];
                    [array addObjectsFromArray: dict];
                    [myTableView reloadData];
                }else{
//                    [controller showHint:@"没有数据~"];
                    [array removeAllObjects];
                    [myTableView reloadData];
                }
            }else if ([responseObj[@"State"] integerValue] == 1){
//                [controller showHint:responseObj[@"Msg"]];
                [array removeAllObjects];
                [myTableView reloadData];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [array removeAllObjects];
            [myTableView reloadData];
            [myTableView.mj_header endRefreshing];
        }];
    }];
    NSMutableArray * myRefreshArray = [[NSMutableArray alloc]init];
    for (int i=1; i<=8; i++) {
        NSString * str = [NSString stringWithFormat:@"cloud_%d",i];
        [myRefreshArray addObject:[UIImage imageNamed:str]];
    }
    // 设置普通状态的动画图片
    [header setImages:myRefreshArray forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [header setImages:myRefreshArray forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [header setImages:myRefreshArray forState:MJRefreshStateRefreshing];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = YES;
    // 设置header
    myTableView.mj_header = header;
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        i++;
        StorageUserInfromation * storage = [StorageUserInfromation storageUserInformation];
        NSDictionary * dcit =@{@"platform":@"2",@"uid":storage.userID,@"phone":storage.loginPhone,@"token":storage.token,@"pn":[NSString stringWithFormat:@"%zd",i],@"rows":@"10"};
        [ZTHttpTool postWithUrl:url param:dcit success:^(id responseObj) {
            NSLog(@"%@",responseObj);
            NSLog(@"%@",responseObj[@"Msg"]);
            [myTableView.mj_footer endRefreshing];
            if ([responseObj[@"State"] integerValue] == 0) {
                NSArray * dict = responseObj[@"Data"];
                if ([dict count]!=0) {
                    [array addObjectsFromArray: dict];
                    [myTableView reloadData];
                    i++;
                }else{
//                    [controller showHint:@"没有更多数据"];
                }
            }else if ([responseObj[@"State"] integerValue] == 1){
//                [controller showHint:responseObj[@"Msg"]];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [myTableView.mj_footer endRefreshing];
        }];
    }];
    // 设置普通状态的动画图片
    [footer setImages:myRefreshArray forState:MJRefreshStateIdle];
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    [footer setImages:myRefreshArray forState:MJRefreshStatePulling];
    // 设置正在刷新状态的动画图片
    [footer setImages:myRefreshArray forState:MJRefreshStateRefreshing];
    // 隐藏状态
    footer.refreshingTitleHidden = YES;
    footer.stateLabel.hidden = YES;
    // 设置footer
    myTableView.mj_footer = footer;
    
}
//+(void)initColletionViewRefresh:(UICollectionView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller{
//    static int i=1;
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//        i=1;
//        // 进入刷新状态后会自动调用这个block
//        NSDictionary * dcit =@{@"pn":@"1",@"rows":@"10"};//
//        [ZTHttpTool postWithUrl:url param:dcit success:^(id responseObj) {
//            JGLog(@"%@",responseObj);
//            JGLog(@"%@",responseObj[@"Msg"]);
//            [myTableView.mj_header endRefreshing];
//            if ([responseObj[@"State"] integerValue] == 0) {
//                NSArray * dict = responseObj[@"Data"];
//                if ([dict count]!=0) {
//                    [array removeAllObjects];
//                    [array addObjectsFromArray: dict];
//                    [myTableView reloadData];
//                }else{
////                    [controller showHint:@"没有数据~"];
//                }
//            }else if ([responseObj[@"State"] integerValue] == 1){
////                [controller showHint:responseObj[@"Msg"]];
//            }
//        } failure:^(NSError *error) {
//            JGLog(@"%@",error);
//            [myTableView.mj_header endRefreshing];
//        }];
//    }];
//    NSMutableArray * myRefreshArray = [[NSMutableArray alloc]init];
//    for (int i=1; i<=8; i++) {
//        NSString * str = [NSString stringWithFormat:@"cloud_%d",i];
//        [myRefreshArray addObject:[UIImage imageNamed:str]];
//    }
//    // 设置普通状态的动画图片
//    [header setImages:myRefreshArray forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [header setImages:myRefreshArray forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [header setImages:myRefreshArray forState:MJRefreshStateRefreshing];
//    // 隐藏时间
//    header.lastUpdatedTimeLabel.hidden = YES;
//    // 隐藏状态
//    header.stateLabel.hidden = YES;
//    // 设置header
//    myTableView.mj_header = header;
//    
//    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//        i++;
//        NSDictionary * dcit =@{@"pn":[NSString stringWithFormat:@"%d",i],@"rows":@"10"};//
//        [ZTHttpTool postWithUrl:url param:dcit success:^(id responseObj) {
//            JGLog(@"%@",responseObj);
//            JGLog(@"%@",responseObj[@"Msg"]);
//            [myTableView.mj_footer endRefreshing];
//            if ([responseObj[@"State"] integerValue] == 0) {
//                NSArray * dict = responseObj[@"Data"];
//                if ([dict count]!=0) {
//                    [array addObjectsFromArray: dict];
//                    [myTableView reloadData];
//                    i++;
//                }else{
////                    [controller showHint:@"没有更多数据"];
//                }
//            }else if ([responseObj[@"State"] integerValue] == 1){
////                [controller showHint:responseObj[@"Msg"]];
//            }
//        } failure:^(NSError *error) {
//            JGLog(@"%@",error);
//            [myTableView.mj_footer endRefreshing];
//        }];
//    }];
//    // 设置普通状态的动画图片
//    [footer setImages:myRefreshArray forState:MJRefreshStateIdle];
//    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
//    [footer setImages:myRefreshArray forState:MJRefreshStatePulling];
//    // 设置正在刷新状态的动画图片
//    [footer setImages:myRefreshArray forState:MJRefreshStateRefreshing];
//    // 隐藏状态
//    footer.refreshingTitleHidden = YES;
//    footer.stateLabel.hidden = YES;
//    // 设置footer
//    myTableView.mj_footer = footer;
//    
//}
+(BOOL)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
    return YES;
}

#pragma mark 16进制转uiclor
+(UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}
@end
