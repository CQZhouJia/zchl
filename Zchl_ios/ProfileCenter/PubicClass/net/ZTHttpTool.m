//
//  ZTHttpTool.m
//  oneweibo
//
//  Created by zhuangtao on 15/6/3.
//  Copyright (c) 2015年 zhuangtao. All rights reserved.
//

#import "ZTHttpTool.h"
#import "AFNetworking.h"
//#import "NSString+Hashing.h"
#import "CommonCrypto/CommonDigest.h"
@implementation ZTHttpTool

+ (void)getWithUrl:(NSString *)url param:(NSDictionary *)params myDownloadProgress:(void(^)(NSProgress *progress))myDownloadProgress success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
    

}

+ (void)postWithUrl:(NSString *)url param:(id)params success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
//    NSString *urlStr = [NSString stringWithFormat:@"%@%@",textUrl,url];
//    json字符串转化为数据字典
//    NSData *jsonData = [params dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    NSURL *SessionUrl = [NSURL URLWithString:BASE_URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:SessionUrl sessionConfiguration:config];
//    AFHTTPSessionManager * mgr = [AFHTTPSessionManager manager];
//    NSString * requestURL = [BASE_URL stringByAppendingString:url];
//    NSLog(@"%@",requestURL);
   StorageUserInfromation * storge = [StorageUserInfromation storageUserInformation];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.requestSerializer.timeoutInterval=10;
    [mgr.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];
    [mgr.requestSerializer setValue:(storge.userID?storge.userID:@"1") forHTTPHeaderField:@"uid"];
    [mgr.requestSerializer setValue:(storge.loginPhone?storge.loginPhone:@"18580465179") forHTTPHeaderField:@"phone"];
    [mgr.requestSerializer setValue:(storge.token?storge.token:@"ABCDEFGHIJKLMN") forHTTPHeaderField:@"token"];
    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSLog(@"%@",responseObject[@"Msg"]);
            if ([responseObject[@"State"] integerValue] == 1001) {
                NSURL *SessionUrl = [NSURL URLWithString:BASE_URL];
                
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:SessionUrl sessionConfiguration:config];
                StorageUserInfromation * storge = [StorageUserInfromation storageUserInformation];
                mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                [mgr.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];
                [mgr.requestSerializer setValue:(storge.userID?storge.userID:@"1") forHTTPHeaderField:@"uid"];
                [mgr.requestSerializer setValue:(storge.loginPhone?storge.loginPhone:@"18580465179") forHTTPHeaderField:@"phone"];

                mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                [mgr POST:@"Token/RefreshToken" parameters:@{storge.pwd:@"pwd"} progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    NSLog(@"%@",responseObject);
                    if (success) {
                        storge.token = responseObject[@"Data"][@"Token"];
                        [ZTHttpTool postWithUrl:url param:params success:^(id responseObj) {
                            if (success) {
                                success(responseObj);
                            }
                        } failure:^(NSError *error) {
                            if (failure) {
                                failure(error);
                            }
                        }];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failure) {
                        failure(error);
                    }
                }];
            }else{
                success(responseObject);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%zd",error.code);
        if (failure) {
            failure(error);
        }
    }];
}

//返回数据在本地的存储路径(文件名称进行md5加密处理)
+(NSString *)pathWithFileName:(NSString *)fileName{
//    return [NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",[fileName MD5Hash]];
    return @"nsstring";
}
+ (void)postHaveBufferWithUrl:(NSString *)url param:(id)params success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
    
//    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
//    NSDictionary *paramDict = [params mj_keyValues];
//    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
}
+ (void)postObjectWithurl:(NSString *)url param:(id)params success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //    NSDictionary *datastr = param.postDict;
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:datastr options:NSJSONWritingPrettyPrinted error:nil];
    //    NSString *JsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    param.data = JsonStr;
    //    NSString *md5Str = [NSString stringWithFormat:@"%@%@%@%@%@",param.action,param.source,param.timestamp,param.data,param.vision];
    //    param.sign = [self md5:md5Str];
//    NSDictionary * paramDict = [params mj_keyValues];
    NSDictionary * paramDict;
//    NSDictionary *paramDict = [params keyValues];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    
        [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
}
+ (void)postWithImageUrl:(NSString *)url param:(id)params postImageArr:(NSArray*)postImageArr  mimeType:(NSString*)mimeType success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
    NSURL *SessionUrl = [NSURL URLWithString:BASE_URL];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:SessionUrl sessionConfiguration:config];
    StorageUserInfromation * storge = [StorageUserInfromation storageUserInformation];
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];
    [mgr.requestSerializer setValue:(storge.userID?storge.userID:@"1") forHTTPHeaderField:@"uid"];
    [mgr.requestSerializer setValue:(storge.loginPhone?storge.loginPhone:@"18580465179") forHTTPHeaderField:@"phone"];
    [mgr.requestSerializer setValue:(storge.token?storge.token:@"ABCDEFGHIJKLMN") forHTTPHeaderField:@"token"];
    

    [mgr POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         NSArray * array = [postImageArr objectAtIndex:0];
         NSArray * array1 = [postImageArr objectAtIndex:1];

         // 上传 多张图片
         for(NSInteger i = 0; i < [array count]; i++) {
             NSData * picData = UIImageJPEGRepresentation([[postImageArr objectAtIndex:0] objectAtIndex: i], 1);
             UIImage * images = [UIImage imageWithData:picData];
             while ([picData length]>1024*500) {
                 
                 picData =  UIImageJPEGRepresentation(images, 0.3);
                 if ([picData length]>1024*500) {
                     images =  [StorageUserInfromation imageCompressForWidth:images targetWidth:images.size.width*0.5];
                     picData =  UIImageJPEGRepresentation(images, 0.3);

                 }
             }
             NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
             formatter.dateFormat = @"yyyyMMddHHmmss";
             NSString *str = [formatter stringFromDate:[NSDate date]];
             NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//             NSURL *filePath = [NSURL fileURLWithPath:[array objectAtIndex:i]];
             [formData appendPartWithFileData:picData name:[array1 objectAtIndex:i] fileName:fileName mimeType:mimeType];
         }
         
     } progress:^(NSProgress * _Nonnull uploadProgress) {
    
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if ([responseObject[@"State"] integerValue] == 1001) {
                NSURL *SessionUrl = [NSURL URLWithString:BASE_URL];
                
                NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:SessionUrl sessionConfiguration:config];
                StorageUserInfromation * storge = [StorageUserInfromation storageUserInformation];
                mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                mgr.responseSerializer = [AFJSONResponseSerializer serializer];
                [mgr.requestSerializer setValue:@"2" forHTTPHeaderField:@"platform"];
                [mgr.requestSerializer setValue:(storge.userID?storge.userID:@"1") forHTTPHeaderField:@"uid"];
                [mgr.requestSerializer setValue:(storge.loginPhone?storge.loginPhone:@"18580465179") forHTTPHeaderField:@"phone"];
                
                mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
                [mgr POST:@"Token/RefreshToken" parameters:@{storge.pwd:@"pwd"} progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    if (success) {
                        storge.token = responseObject[@"Data"][@"Token"];
                        [ZTHttpTool postWithImageUrl:url param:params postImageArr:postImageArr  mimeType:mimeType success:^(id responseObj) {
                            if(success){
                                success(responseObj);
                            }

                        } failure:^(NSError *error) {
                            if (failure) {
                                failure(error);
                            }
                        }];
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failure) {
                        failure(error);
                    }
                }];
            }else{
                success(responseObject);
            }

        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    
}
+ (void)oauthInfoWithUrl:(NSString *)url param:(id)params  success:(void (^)(id responseObj))success failure:(void(^)(NSError *error))failure{
    
    //    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //
    //    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    //    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    //    [mgr POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    //
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        if (success) {
    //            success(responseObject);
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (failure) {
    //            failure(error);
    //        }
    //    }];
}

//http://blog.csdn.net/joonchen111/article/details/48577735 集成支付宝
@end

