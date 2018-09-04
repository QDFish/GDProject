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

@interface GDNetworkResponse : NSObject

@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) id responseData;
@property (nonatomic, strong) NSError *error;

@end

@protocol GDNetworkDelegate <NSObject>

@optional

- (nonnull NSString *)networkRequestURL;

- (nonnull NSString *)httpMethod;

- (nullable id)parameters;

- (void)finishLoadWithResponse:(nonnull id)response;

@end

@interface GDNetwork : NSObject

@property (nonatomic, assign) GDNetworkLoadStatus status;
@property (nonatomic, strong, readonly) AFHTTPSessionManager *manager;
@property (nonatomic, weak) id <GDNetworkDelegate> delegate;


+ (instancetype)network;

+ (AFHTTPSessionManager *)manager;

- (void)createAndSendPageRequest;

- (void)setCommonHeader;

- (id)handleResponseWithTask:(NSURLSessionDataTask *)task responseData:(id _Nullable)responseObject error:(NSError *)error;


@end

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
