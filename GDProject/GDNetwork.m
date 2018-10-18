//
//  GDNetwork.m
//  GDProject
//
//  Created by QDFish on 2018/8/29.
//

#import "GDNetwork.h"
#import "NSString+Extension.h"
#import "GDConstants.h"
#import "NSObject+Router.h"

@interface GDNetwork()

@property (nonatomic, strong, readwrite) AFHTTPSessionManager *manager;

@end

@implementation GDNetwork

+ (instancetype)network {
    return [[GDNetwork alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.manager = [GDNetwork manager];
        self.status = GDNetworkLoadStatusDefalut;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self setCommonHeader];
        });
    }
    
    return self;
}

+ (AFHTTPSessionManager *)manager {
    static dispatch_once_t onceToken;
    static AFHTTPSessionManager *_manager;
    dispatch_once(&onceToken, ^{
        _manager = [AFHTTPSessionManager manager];
    });
    
    return _manager;
}

- (void)createAndSendPageRequest {
    NSString *httpMethod =  GD_SAFE_CALL_SEL_MULTI_PARAMETERS(self.delegate, @selector(httpMethod), nil);
    NSString *parameters = GD_SAFE_CALL_SEL_MULTI_PARAMETERS(self.delegate, @selector(parameters), nil);
    NSString *urlString = GD_SAFE_CALL_SEL_MULTI_PARAMETERS(self.delegate, @selector(networkRequestURL), nil);
    
    if ([NSString isEmpty:urlString]) {
        return;
    }
    
    NSURLSessionDataTask *task = [self.manager dataTaskWithHTTPMethod:httpMethod ?: @"GET"
                                                            URLString:urlString
                                                           parameters:parameters
                                                       uploadProgress:nil
                                                     downloadProgress:nil
                                                              success:^(NSURLSessionDataTask *task, id responseObj) {
                                                                  GD_SAFE_CALL_SEL_MULTI_PARAMETERS(self.delegate, @selector(callBackWithResponse:), [self handleResponseWithTask:task responseData:responseObj error:nil]);
                                                              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                  GD_SAFE_CALL_SEL_MULTI_PARAMETERS(self.delegate, @selector(callBackWithResponse:), [self handleResponseWithTask:task responseData:nil error:error]);
                                                              }];
    [task resume];
}

#pragma mark - overwrite

- (void)setCommonHeader {
    //        [self.manager.requestSerializer setValue: forHTTPHeaderField:];
}

- (id)handleResponseWithTask:(NSURLSessionDataTask *)task responseData:(id)responseObject error:(NSError *)error {
    GDNetworkResponse *response = [GDNetworkResponse new];
    
    
    response.response = task.response;
    response.responseData = responseObject;
    response.error = error;
    
    return response;
}

@end

@implementation GDNetwork (HttpNetwork)

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(id _Nullable responseObject))failure {
    return [self.manager GET:URLString
                  parameters:parameters
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         success([self handleResponseWithTask:task responseData:responseObject error:nil]);
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         failure([self handleResponseWithTask:task responseData:nil error:error]);
                     }];
    
}


- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(id _Nullable responseObject))success
                               failure:(nullable void (^)(id _Nullable responseObject))failure {
    return [self.manager GET:URLString
                  parameters:parameters
                    progress:downloadProgress
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         success([self handleResponseWithTask:task responseData:responseObject error:nil]);
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         failure([self handleResponseWithTask:task responseData:nil error:error]);
                     }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)(id _Nullable responseObject))failure {
    return [self.manager POST:URLString
                   parameters:parameters
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          success([self handleResponseWithTask:task responseData:responseObject error:nil]);
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          failure([self handleResponseWithTask:task responseData:nil error:error]);
                      }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)(id _Nullable responseObject))failure {
    return [self.manager POST:URLString
                   parameters:parameters
                     progress:uploadProgress
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          success([self handleResponseWithTask:task responseData:responseObject error:nil]);
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          failure([self handleResponseWithTask:task responseData:nil error:error]);
                      }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)(id _Nullable responseObject))failure {
    return [self.manager POST:URLString
                   parameters:parameters
    constructingBodyWithBlock:block
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          success([self handleResponseWithTask:task responseData:responseObject error:nil]);
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          failure([self handleResponseWithTask:task responseData:nil error:error]);
                      }];
    
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(id _Nullable responseObject))success
                                failure:(nullable void (^)(id _Nullable responseObject))failure {
    return [self.manager POST:URLString
                   parameters:parameters
    constructingBodyWithBlock:block
                     progress:uploadProgress
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          success([self handleResponseWithTask:task responseData:responseObject error:nil]);
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          failure([self handleResponseWithTask:task responseData:nil error:error]);
                      }];
}

@end

@implementation GDNetworkResponse

@end


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation AFHTTPSessionManager (Private)

#pragma clang diagnostic pop

@end

