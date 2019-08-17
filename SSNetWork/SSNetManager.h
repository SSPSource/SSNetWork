//
//  SSNetManager.h
//  SSPNetWork
//
//  Created by ssp on 2019/8/14.
//  Copyright © 2019 ssp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#ifdef DEBUG
#define NetLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define NetLog(...)
#endif

#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

typedef NS_ENUM(NSInteger, SSNetworkStatusType) {
    /// 未知网络
    NetworkStatusUnknown,
    /// 无网络
    NetworkStatusNotReachable,
    /// 手机网络
    NetworkStatusReachableViaWWAN,
    /// WIFI网络
    NetworkStatusReachableViaWiFi
};

typedef NS_ENUM(NSInteger, SSRequestSerializer) {
    /// 设置请求数据为JSON格式
    SSRequestSerializerJSON,
    /// 设置请求数据为二进制格式
    SSRequestSerializerHTTP,
};

/// 请求成功的Block
typedef void(^SSHttpRequestSuccess)(id _Nullable responseObject);

/// 请求失败的Block
typedef void(^SSHttpRequestFailed)(NSError * _Nullable error);

/// 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小
typedef void (^SSHttpProgress)(NSProgress * _Nonnull progress);

/// 网络状态的Block
typedef void(^SSNetworkStatus)(SSNetworkStatusType status);

NS_ASSUME_NONNULL_BEGIN
@interface SSNetManager : NSObject

+ (SSNetManager *)sharedAgent;

/// 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
+ (void)networkStatusWithBlock:(SSNetworkStatus)networkStatus;
//设置请求超时时间:默认为30S
- (void)setRequestTimeoutInterval:(NSTimeInterval)time;
// 设置请求头
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;
// 设置网络请求参数的格式:默认为二进制格式
- (void)setRequestSerializer:(SSRequestSerializer)requestSerializer;

/**
 *  GET请求
 *
 *  @param URLString  请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
- (__kindof NSURLSessionTask *)GET:(NSString *)URLString
                        parameters:(id)parameters
                           success:(SSHttpRequestSuccess)success
                           failure:(SSHttpRequestFailed)failure;
/**
 *  POST请求
 *
 *  @param URLString        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
-(__kindof NSURLSessionTask *)POST:(NSString *)URLString
                        parameters:(id)parameters
                           success:(SSHttpRequestSuccess)success
                           failure:(SSHttpRequestFailed)failure;
/**
 *  上传文件
 *
 *  @param URLString        请求地址
 *  @param parameters 请求参数
 *  @param name       文件对应服务器上的字段
 *  @param filePath   文件本地的沙盒路径
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
- (__kindof NSURLSessionTask *)uploadFileWithURL:(NSString *)URLString
                                      parameters:(id)parameters
                                            name:(NSString *)name
                                        filePath:(NSString *)filePath
                                        progress:(SSHttpProgress)progress
                                         success:(SSHttpRequestSuccess)success
                                         failure:(SSHttpRequestFailed)failure;
/**
 *  上传单/多张图片
 *
 *  @param URLString        请求地址
 *  @param parameters 请求参数
 *  @param name       图片对应服务器上的字段
 *  @param images     图片数组
 *  @param fileNames  图片文件名数组, 可以为nil, 数组内的文件名默认为当前日期时间"yyyyMMddHHmmss"
 *  @param imageScale 图片文件压缩比 范围 (0.f ~ 1.f)
 *  @param imageType  图片文件的类型,例:png、jpg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
- (__kindof NSURLSessionTask *)uploadImagesWithURL:(NSString *)URLString
                                        parameters:(id)parameters
                                              name:(NSString *)name
                                            images:(NSArray<UIImage *> *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                        imageScale:(CGFloat)imageScale
                                         imageType:(NSString *)imageType
                                          progress:(SSHttpProgress)progress
                                           success:(SSHttpRequestSuccess)success
                                           failure:(SSHttpRequestFailed)failure;
/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
- (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(SSHttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(SSHttpRequestFailed)failure;
@end

NS_ASSUME_NONNULL_END
