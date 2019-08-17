//
//  SSHttpRequest.h
//  SSPNetWork
//
//  Created by ssp on 2019/8/15.
//  Copyright © 2019 ssp. All rights reserved.
//

#import <Foundation/Foundation.h>
///  HTTP Request method.
typedef NS_ENUM(NSInteger, SSRequestMethod) {
    SSRequestMethodGET = 0,
    SSRequestMethodPOST,
    SSRequestMethodHEAD,
    SSRequestMethodPUT,
    SSRequestMethodDELETE,
    SSRequestMethodPATCH,
};

typedef void(^SSRequestSuccess)(id _Nullable response);
typedef void(^SSRequestFailure)(NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface SSHttpRequest : NSObject
//公共请求
+ (void)requestHTTPMethod:(SSRequestMethod)method
                URLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(SSRequestSuccess)success
                  failure:(SSRequestFailure)failure;

//    统一参数    统一请求头   统一参数格式
+(id)publickReqConfig:(id)parameters;

// response数据公共处理 如解密，解压等
+ (id)analyseResponseSuccess:(id)data;

//response数据公共错误码等
+ (id)analyseResponseFailure:(id)data;

@end

NS_ASSUME_NONNULL_END
