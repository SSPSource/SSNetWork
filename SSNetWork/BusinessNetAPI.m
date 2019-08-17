//
//  BusinessNetAPI.m
//  SSPNetWork
//
//  Created by ssp on 2019/8/16.
//  Copyright © 2019 ssp. All rights reserved.
//

#import "BusinessNetAPI.h"
#import "SSNetworkConfig.h"

#if DevelopSever
/** 接口前缀-开发服务器*/
NSString *const kApiPrefix = @"接口服务器的请求前缀 例: https://www.baidu.com";
#elif TestSever
/** 接口前缀-测试服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";
#elif ProductSever
/** 接口前缀-生产服务器*/
NSString *const kApiPrefix = @"https://www.baidu.com";
#endif

NSString * const R_Active =@"";
NSString * const R_Login = @"";
NSString * const R_RoleLimit = @"";
NSString * const R_AlarmType = @"";
NSString * const R_SaveDeviceSubscribe = @"";


@implementation BusinessNetAPI

+(void)appLogin:(NSDictionary *) paraDic
        success:(SSRequestSuccess)success
        failure:(SSRequestFailure)failure
{
    [BusinessNetAPI requestHTTPMethod:SSRequestMethodGET URLString:R_Login parameters:paraDic success:success failure:failure];
}
+(void)saveDeviceSubscribe:(NSDictionary *) paraDic
                   success:(SSRequestSuccess)success
                   failure:(SSRequestFailure)failure
{
    [BusinessNetAPI requestHTTPMethod:SSRequestMethodPOST URLString:R_SaveDeviceSubscribe parameters:paraDic success:success failure:failure];
   
}
#pragma mark - 公共参数
//    统一参数    统一请求头   统一参数格式
+(id)publickReqConfig:(id)parameters{
    [super publickReqConfig:parameters];
//    根据实际业务增加公共参数
    
    return parameters;
}
// 根据实际业务，处理response业务数据
+ (id)analyseResponseSuccess:(id)data{
    [super analyseResponseSuccess:data];
    return data;
}
+ (id)analyseResponseFailure:(id)data{
    [super analyseResponseFailure:data];
    return data;
}

@end
