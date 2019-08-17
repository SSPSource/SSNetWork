//
//  SSNetManager.m
//  SSPNetWork
//
//  Created by ssp on 2019/8/14.
//  Copyright © 2019 ssp. All rights reserved.
//
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>

#else
#import "AFNetworking.h"

#endif
#import <pthread/pthread.h>
#import "SSNetManager.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)


@interface SSNetManager ()
@end
@implementation SSNetManager{
    AFHTTPSessionManager *_manager;
    dispatch_queue_t _processingQueue;
    pthread_mutex_t _lock;
    NSIndexSet *_allStatusCodes;
}

+ (SSNetManager *)sharedAgent {
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
        _processingQueue = dispatch_queue_create("com.yuantiku.networkagent.processing", DISPATCH_QUEUE_CONCURRENT);
        _allStatusCodes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 500)];
        pthread_mutex_init(&_lock, NULL);
        _manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:nil];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableStatusCodes = _allStatusCodes;
        _manager.completionQueue = _processingQueue;
        
    }
    return self;
}


#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(SSNetworkStatus)networkStatus {
     AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                networkStatus ? networkStatus(NetworkStatusUnknown) : nil;
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                networkStatus ? networkStatus(NetworkStatusNotReachable) : nil;
                
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                networkStatus ? networkStatus(NetworkStatusReachableViaWWAN) : nil;
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                networkStatus ? networkStatus(NetworkStatusReachableViaWiFi) : nil;
                
                break;
        }
    }];
    [manager startMonitoring];
    
}

#pragma mark -

//设置超时
- (void)setRequestTimeoutInterval:(NSTimeInterval)time {
    _manager.requestSerializer.timeoutInterval = time;
}
//设置请求编码格式
- (void)setRequestSerializer:(SSRequestSerializer) requestSerializer {
    _manager.requestSerializer = requestSerializer== SSRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}
//设置头文件
- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field {
    [_manager.requestSerializer setValue:value forHTTPHeaderField:field];
}
#pragma mark -
- (__kindof NSURLSessionTask *)GET:(NSString *)URLString
                        parameters:(id)parameters
                           success:(SSHttpRequestSuccess)success
                           failure:(SSHttpRequestFailed)failure{
    NSAssert(URLString, @"请求地址不能为空");
    
    NSURLSessionTask *sessionTask = [_manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
        
    }];
    NetLog(@"==GET==%@====",sessionTask.currentRequest.URL);
   
    return sessionTask;
    
}

- (__kindof NSURLSessionTask *)POST:(NSString *)URLString
                         parameters:(id)parameters
                            success:(SSHttpRequestSuccess)success
                            failure:(SSHttpRequestFailed)failure{
    NSAssert(URLString, @"请求地址不能为空");
    NetLog(@"==POST==%@====param==%@",URLString,parameters);
    NSURLSessionTask *sessionTask = [_manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success ? success(responseObject) : nil;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
        
    }];
    
    
    return sessionTask;
    
    
}

- (__kindof NSURLSessionTask *)uploadFileWithURL:(NSString *)URLString
                                      parameters:(id)parameters
                                            name:(NSString *)name
                                        filePath:(NSString *)filePath
                                        progress:(SSHttpProgress)progress
                                         success:(SSHttpRequestSuccess)success
                                         failure:(SSHttpRequestFailed)failure{
    NSURLSessionTask *sessionTask = [_manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
         NSAssert(URLString, @"请求地址不能为空");
        NSError *error = nil;
        [formData appendPartWithFileURL:[NSURL URLWithString:filePath] name:name error:&error];
        (failure && error) ? failure(error) : nil;
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    
    
    return sessionTask;
    
}

- (__kindof NSURLSessionTask *)uploadImagesWithURL:(NSString *)URLString
                                        parameters:(id)parameters
                                              name:(NSString *)name
                                            images:(NSArray<UIImage *> *)images
                                         fileNames:(NSArray<NSString *> *)fileNames
                                        imageScale:(CGFloat)imageScale
                                         imageType:(NSString *)imageType
                                          progress:(SSHttpProgress)progress
                                           success:(SSHttpRequestSuccess)success
                                           failure:(SSHttpRequestFailed)failure{
    
     NSAssert(URLString, @"请求地址不能为空");
    NSURLSessionTask *sessionTask = [_manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSInteger i = 0; i < images.count; i++) {
            // 图片经过等比压缩后得到的二进制文件
            NSData *imageData = UIImageJPEGRepresentation(images[i], imageScale ?: 1.f);
            // 默认图片的文件名, 若fileNames为nil就使用
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *imageFileName = NSStringFormat(@"%@%ld.%@",str,i,imageType?:@"jpg");
            
            [formData appendPartWithFileData:imageData
                                        name:name
                                    fileName:fileNames ? NSStringFormat(@"%@.%@",fileNames[i],imageType?:@"jpg") : imageFileName
                                    mimeType:NSStringFormat(@"image/%@",imageType ?: @"jpg")];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(error) : nil;
    }];
    
    
    return sessionTask;
    
}
#pragma mark - 下载文件
- (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(SSHttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(SSHttpRequestFailed)failure {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    __block NSURLSessionDownloadTask *downloadTask = [_manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    //开始下载
    [downloadTask resume];
    
    
    return downloadTask;
}


@end
