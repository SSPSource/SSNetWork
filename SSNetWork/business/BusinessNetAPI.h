//
//  BusinessNetAPI.h
//  SSPNetWork
//
//  Created by ssp on 2019/8/16.
//  Copyright © 2019 ssp. All rights reserved.
//

#import "SSHttpRequest.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

#define DevelopSever 0
#define TestSever    1
#define ProductSever 0

#pragma mark - 详细接口地址
//激活
UIKIT_EXTERN NSString *const R_Active;
//登录
UIKIT_EXTERN NSString *const R_Login;
//角色权限
UIKIT_EXTERN NSString *const R_RoleLimit;
//报警类型
UIKIT_EXTERN NSString *const R_AlarmType;
//保存报警类型
UIKIT_EXTERN NSString * const R_SaveDeviceSubscribe;

@interface BusinessNetAPI : SSHttpRequest
//登录
+(void)appLogin:(NSDictionary *) paraDic success:(SSRequestSuccess)success failure:(SSRequestFailure)failure;
//报警
+(void)saveDeviceSubscribe:(NSDictionary *) paraDic success:(SSRequestSuccess)success failure:(SSRequestFailure)failure;
@end

NS_ASSUME_NONNULL_END
