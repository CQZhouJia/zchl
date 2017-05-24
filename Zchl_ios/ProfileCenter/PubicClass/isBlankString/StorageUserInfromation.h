//
//  StorageUserInfromation.h
//  letter
//
//  Created by 钟亮 on 15/8/13.
//  Copyright (c) 2015年 huangcen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JGBaseViewController.h"
@interface StorageUserInfromation : NSObject

@property (nonatomic,copy)NSString * level; // 用户等级
@property (nonatomic,strong)NSString * score;
@property (nonatomic,copy)NSString *MessageVCExist;   //是否需要重新加载未读推送
@property (nonatomic,copy)NSString *needGetUnreadMessage;   //是否需要重新加载未读推送
@property (nonatomic,assign)NSInteger       flag;//0竖屏 1横屏
@property (nonatomic,assign)NSInteger       badgeNum;//聊天视图控制器角标
@property (nonatomic, copy)NSString       *loginPhone;//登录的手机号
@property (nonatomic, copy)NSString       *Huanxin;//环信id
@property (nonatomic, copy)NSString       *userID;//用户id
@property (nonatomic, copy)NSString       *nickName;//昵称
@property (nonatomic, copy)NSString       *trueName;//昵称
@property (nonatomic, copy)NSString       *gender;//性别
@property (nonatomic, copy)NSString       *birthday;//生日
@property (nonatomic, copy)NSString       *age;//年龄
@property (nonatomic, copy)NSString       *userHeadImage;//头像
@property (nonatomic, copy)NSString       *signatures;//个性签名
@property (nonatomic, copy)NSString       *coordX;//经度
@property (nonatomic, copy)NSString       *coordY;//纬度
@property (nonatomic, copy)NSString       *buildingID;//小区id
@property (nonatomic, copy)NSString       *buildingImageUrl;//小区图片路径
@property (nonatomic, copy)NSString       *cityName;//城市
@property (nonatomic, copy)NSString       *buildingName;//绑定的小区
@property (nonatomic, copy)NSString        *buildingImg;
@property (nonatomic, copy)NSString       *auditingState;//认证状态
@property (nonatomic, copy)NSString       *auditingImage;//认证图片
@property (nonatomic, copy)NSString       *city;
@property (nonatomic, copy)NSString       *buildingChatId;// 小区环信ID
@property (nonatomic, copy)NSString       *wallet;//钱包
@property (nonatomic, assign)int            state; //账号状态
@property (nonatomic, assign)int            num;
@property (nonatomic, assign)int            num1;
@property (assign,nonatomic)int auditingManager;//1认证成功，2，认证失败，3认证中
@property (nonatomic, copy)NSString       *cityName1;

@property (nonatomic, copy)NSString       *dingweiCity;//定位城市

@property (nonatomic, assign)int            blockGroupMsg;  //是否接受群组消息


@property (nonatomic,strong)NSArray         *letters;
@property (nonatomic,strong)NSArray         *fixArray;
@property (nonatomic,strong)NSArray         *ChineseCities;

@property (nonatomic,copy) NSString *token;
@property (nonatomic,copy) NSString *pwd;
@property (nonatomic,copy) NSString *areaCode;

@property (nonatomic,assign) BOOL isPushedFromPayVC;

@property (nonatomic,assign) BOOL isPushedFromPayVC2;

+ (StorageUserInfromation *)storageUserInformation;
-(UIInterfaceOrientationMask)interfaceOrientationMask;

+(UIImage*)scaleToSize:(CGSize)size image:(UIImage *)image;
-(UIImage*)convertViewToImage:(UIView*)v;
+(NSString*)doDevicePlatform;

+ (void)storyBoradAutoLay:(UIView *)allView;
+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
//+(NSString*)DataTOjsonString:(id)object;
-(NSString *) jsonStringWithObject:(id) object;
-(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
+(NSString *)stringFromDataString:(NSString *)str;//时间转换
+(NSString *)stringFromDataString2:(NSString *)str;
+(NSString *)stringFromDataString3:(NSString *)str;
+(NSString *)stringFromDataString33:(NSString *)str;
+(NSString *)stringFromDataString4:(NSString *)str;
+(NSString *)stringFromDataString5:(NSString *)str;
+(NSString *)stringFromDataString6:(NSString *)str;
+(NSString *)mystringFromDataString5:(NSString *)str;
+(UIImage *) imageCompressForWidth2:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;
+ (NSString *)minuteDescription:(NSString *)dateSting;
+ (NSString *)minuteDescription2:(NSString *)dateSting;
+(void)initTableViewRefresh:(UITableView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller;
+(void)initColletionViewRefresh:(UICollectionView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller;
//+(void)initScrollViewRefresh:(UIScrollView*)myTableView Url:(NSString*)url array:(NSMutableArray*)array controller:(JGBaseViewController*)controller;


/**
 *  检查手机号码合法性
 */
+(BOOL)valiMobile:(NSString *)mobile;

/**
 *  16进制转uiclor
 *
 *  @param UIColor 输出颜色
 *
 */
#pragma mark 16进制转uiclor
+(UIColor *) stringTOColor:(NSString *)str;

@end


