//
//  SSNetworkConfig.h
//  SSPNetWork
//
//  Created by ssp on 2019/8/15.
//  Copyright © 2019 ssp. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

#define SSDefautetimeoutInterval 30
#pragma mark - http返回的结果key
#define NET_RESP_SUCC_CODE @"1" //请求成功码
#define NET_RESP_CODE_KEY @"status" //请求结果code的Key
#define NET_RESP_BODY_KEY @"result" //数据部分
#define NET_RESP_ERROR_MESSAGE_KEY @"msg" //错误信息部分

#pragma mark - 详细接口地址业务需要
//接口业务，可以继承SSHttpRequest实现
//UIKIT_EXTERN NSString *const R_Login;


@class AFSecurityPolicy;
@interface SSNetworkConfig : NSObject
@property (nonatomic, strong) NSString *baseUrl;
@property (nonatomic, strong) NSString *cdnUrl;
@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;
@property (nonatomic) BOOL debugLogEnabled;
@property (nonatomic, strong) NSURLSessionConfiguration* sessionConfiguration;
//http返回头
@property (nonatomic, strong) NSString * net_resp_succ_code;
@property (nonatomic, strong) NSString * net_resp_code_key;
@property (nonatomic, strong) NSString * net_resp_body_key;
@property (nonatomic, strong) NSString * net_resp_error_message_key;


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

///  Return a shared config object.
+ (SSNetworkConfig *)sharedConfig;

@end


NS_ASSUME_NONNULL_END
