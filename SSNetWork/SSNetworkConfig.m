//
//  SSNetworkConfig.m
//  SSPNetWork
//
//  Created by ssp on 2019/8/15.
//  Copyright © 2019 ssp. All rights reserved.
//
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif
#import "SSNetworkConfig.h"

//NSString * const R_Login = @"login";

@implementation SSNetworkConfig
+ (SSNetworkConfig *)sharedConfig {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _baseUrl = @"";
        _cdnUrl = @"";
        _securityPolicy = [AFSecurityPolicy defaultPolicy];
        _debugLogEnabled = NO;
        _net_resp_succ_code = NET_RESP_SUCC_CODE;
        _net_resp_code_key = NET_RESP_CODE_KEY;
        _net_resp_body_key = NET_RESP_BODY_KEY;
        _net_resp_error_message_key = NET_RESP_ERROR_MESSAGE_KEY;
        
    }
    return self;
}
#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p>{ baseURL: %@ } { cdnURL: %@ }", NSStringFromClass([self class]), self, self.baseUrl, self.cdnUrl];
}
@end
