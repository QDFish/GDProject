//
//  GDNetwork.h
//  GDProject
//
//  Created by QDFish on 2018/8/29.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_OPTIONS(NSInteger, GDNetworkLoadStatus) {
    GDNetworkLoadStatusDefalut = 1 << 1,
    GDNetworkLoadStatusDownLoading = 1 << 2,
    GDNetworkLoadStatusUpLoading = 1 << 3,
    GDNetworkLoadStatusLoading = GDNetworkLoadStatusDownLoading | GDNetworkLoadStatusUpLoading,
};


/**
 请求响应的默认类，可继承可重写
 */
@interface GDNetworkResponse : NSObject

@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) id responseData;
@property (nonatomic, strong) NSError *error;

@end


@protocol GDNetworkDelegate <NSObject>

@optional


/**
 页面请求地址

 @return .
 */
- (nonnull NSString *)networkRequestURL;


/**
 http请求方法（默认GET）

 @return .
 */
- (nonnull NSString *)httpMethod;


/**
 请求参数

 @return .
 */
- (nullable id)parameters;



/**
 请求结果响应回调

 @param response 回调响应的结果，对接于AF框架
 */
- (void)finishLoadWithResponse:(nonnull id)response;

@end



/**
 网络请求相关组件，依附于UIViewController
 */
@interface GDNetwork : NSObject

@property (nonatomic, assign) GDNetworkLoadStatus status;
@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;
@property (nonatomic, weak) id <GDNetworkDelegate> delegate;


/**
 GDNetwork实例，非单例

 @return .
 */
+ (instancetype)network;


/**
 原始AFHTTPSessionManager，不含任何自定义头

 @return .
 */
+ (AFHTTPSessionManager *)manager;


/**
 依附于GDNetworkDelegate的请求动作
 */
- (void)createAndSendPageRequest;


/**
 初始化网络参数（子类重写）
 */
- (void)setCommonHeader;


/**
 网络响应对象的重写（子类重写）

 @param task .见AFHTTPSessionManager回调
 @param responseObject .见AFHTTPSessionManager回调
 @param error .见AFHTTPSessionManager回调
 @return 一个新的自定义的通用响应对象
 */
- (id)handleResponseWithTask:(NSURLSessionDataTask *)task responseData:(id _Nullable)responseObject error:(NSError *)error;


@end


/**
 根据- (id)handleResponseWithTask:(NSURLSessionDataTask *)task responseData:(id _Nullable)responseObject error:(NSError *)error 的重写返回的新的响应对象的请求方法
 */
@interface GDNetwork (HttpNetwork)

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(id _Nullable responseObject))failure;


- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(id _Nullable responseObject))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)(id _Nullable responseObject))failure DEPRECATED_ATTRIBUTE;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)(id _Nullable responseObject))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)(id _Nullable responseObject))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)(id _Nullable responseObject))failure;


@end

@interface AFHTTPSessionManager (Private)

- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

@end
