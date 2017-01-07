//
//  EmApiBase.m
//  EmApi
//
//  Created by pengyong on 16/9/16.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import "EmApi.h"
#import "EmHeader.h"
#import "EmResult.h"
#import "EmValidator.h"
#import "EmNetworkingManager.h"
#import <PINCache/PINCache.h>
#define kDefaultResponseXml @"xml"
#define kDefaultResponseJson @"json"
#define kDefaultResponseJsonp @"jsonp"
#define kDefaultResponseMsgpack @"msgpack"
#define kDefaultResponseTypeString kDefaultResponseJson
@interface EmApi()
/**
 EmConfig config
 */
@property(nonatomic,strong) EmConfig *config;
/**
 source 资源
 */
@property(nonatomic,strong) NSString *source;


/**
 parameters 请求参数
 */
@property(nonatomic,strong) NSDictionary *parameters;


/**
 version 版本
 */
@property(nonatomic,strong) NSString *version;
/**
 requestValidtor 请求验证器
 */
@property(nonatomic,strong) EmValidator *requestValidtor;



/**
 responseValidtor 响应验证器
 */
@property(nonatomic,strong) EmValidator *responseValidtor;


/**
 responseType 响应类型
 */
@property(nonatomic,assign) Em_RESPONSE_TYPE responseType;



/**
 cachedTimeInSeconds 缓存有效期 = -1 永久缓存  = 0 不缓存  >0 缓存秒数
 */
@property(nonatomic,assign) NSInteger cachedTimeInSeconds;


/**
 networkingManager 网络请求管理器
 */
@property(nonatomic,strong) EmNetworkingManager *networkingManager;

@end


@implementation EmApi

#pragma mark - token

/**
 申请令牌
 */
-(void)applyToken:(void (^)())success failure:(void (^)(NSError *error))failure{
    if(!self.config.expire || self.config.expire <=[NSNumber numberWithUnsignedInteger:(NSUInteger)NSDate.date.timeIntervalSince1970]){
        self.config.token = [NSString string];
        self.config.expire = @0;
        __block NSString *api = self.source;
        __block NSDictionary *parameters = self.parameters;
        //设置API
        [self api:@"Session"];
        //设置请求参数
        [self parameters:@{@"appkey":self.config.appkey,@"appsecret":self.config.appsecret}];
        //发送请求
        [self request:Em_REQUEST_POST success:^(EmResult *result) {
            [[self api:api] parameters:parameters];
            if ([result.code isEqualToNumber:@100]) {
                NSString *token = [result.response objectForKey:@"token"];
                NSNumber *expire = [result.response objectForKey:@"expire"];
                [self.config saveToken:token andExpire:expire];
                EmLog(@"apply Token success.");
                success();
            }
            else{
                NSError * error = [NSError errorWithDomain:NSGlobalDomain code:102 userInfo:@{@"description":@"apply Token failed."}];
                EmLog(@"apply Token failed.");
                failure(error);
            }
            
        } failure:^(NSError *error) {
            [[self api:api] parameters:parameters];
            failure(error);
        }];
    }
    else{
        success();
    }
}

#pragma mark - getter


/**
 version API版本

 @return API版本 字符串
 */
-(NSString *)version{
    if (!_version) {
        _version = self.config.version;
    }
    return _version;
}


/**
 parameters 请求参数

 @return 请求参数 字典
 */
-(NSDictionary *)parameters{
    if (!_parameters) {
        _parameters = self.config.parameters;
    }
    return _parameters;
}


/**
 requestValidtor 请求验证器

 @return 请求验证器 对象
 */
-(EmValidator *)requestValidtor{
    if (!_requestValidtor) {
        _requestValidtor = self.config.requestValidtor;
    }
    return _requestValidtor;
}


/**
 responseValidtor 响应验证器

 @return 响应验证器 对象
 */
-(EmValidator *)responseValidtor{
    if (!_responseValidtor) {
        _responseValidtor = self.config.responseValidtor;
    }
    return _responseValidtor;
}

/**
 responseType 响应类型

 @return 响应类型 枚举值
 */
-(Em_RESPONSE_TYPE)responseType{
    if (!_responseType) {
        _responseType = self.config.responseType;
    }
    return _responseType;
}



/**
 cachedTimeInSeconds

 @return 缓存有效期 秒数
 */
-(NSInteger)cachedTimeInSeconds{
    if (!_cachedTimeInSeconds) {
        _cachedTimeInSeconds = self.config.cachedTimeInSeconds;
    }
    return _cachedTimeInSeconds;
}



/**
 networkingManager 网络请求管理器
 
 @return 网络请求管理器 对象
 */
-(EmNetworkingManager *)networkingManager{
    if (!_networkingManager) {
        _networkingManager = [[EmNetworkingManager alloc] init];
    }
    return _networkingManager;
}


#pragma mark - defined getter

/**
 responseTypeString 响应类型

 @return 响应类型 字符串
 */
-(NSString *)responseTypeString{
    switch (self.responseType) {
        case Em_RESPONSE_XML:
            return kDefaultResponseXml;
            break;
        case Em_RESPONSE_JSON:
            return kDefaultResponseJson;
            break;
        case Em_RESPONSE_JSONP:
            return kDefaultResponseJsonp;
            break;
        case Em_RESPONSE_MSGPACK:
            return kDefaultResponseMsgpack;
            break;
        default:
            return kDefaultResponseTypeString;
            break;
    }
}

/**
 requestUrl 请求url

 @return 合成的请求url
 */
-(NSString *)requestUrl{
    return self.config.token ? [NSString stringWithFormat:@"%@://%@/%@/%@.%@?%@=%@",self.config.protocal,self.config.domain,self.version,self.source,[self responseTypeString],self.config.tokenName,self.config.token] : [NSString stringWithFormat:@"%@://%@/%@/%@.%@",self.config.protocal,self.config.domain,self.version,self.source,[self responseTypeString]];
}


#pragma mark - instancetype
/**
 加载配置
 
 @param config 配置
 @return API对象
 */
-(instancetype)config:(EmConfig *)config{
    self.config = config;
    return self;
}


/**
 加载请求参数
 
 @param parameters 参数
 @return API对象
 */
-(instancetype)parameters:(NSDictionary *)parameters{
    self.parameters = parameters;
    return self;
}

/**
 设置API
 
 @param api API名称
 @return API对象
 */
-(instancetype)api:(NSString *)api{
    self.source = api;
    return self;
}

#pragma mark - request

/**
 request 发起请求

 @param method  请求类型
 @param success 成功block
 @param failure 失败block
 */
-(void)request:(enum Em_REQUEST_METHOD)method success:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure{
    //启用网络检测
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    NSString *requestUrl = [self requestUrl];
    NSString *responseTypeString = [self responseTypeString];
    NSDictionary *parameters = self.parameters;
    EmLog(@"requestUrl:%@",requestUrl);
    EmLog(@"parameters:%@",parameters);
    EmLog(@"format:%@",responseTypeString);
    
    //请求前验证
    if (![self.requestValidtor validWithData:parameters]) {
        //验证失败
        failure(self.requestValidtor.error);
        return;
    }
    
    //生成唯一请求Id
    __block NSString *requestId = [[NSString stringWithFormat:@"%@%@%@",[requestUrl md5],[responseTypeString md5],[parameters md5]] md5];
    EmLog(@"requestId:%@",requestId);
    
    //网络判断
    
    if(![[AFNetworkReachabilityManager sharedManager] isReachable]){
        //无网络情况则返回
        EmResult *cachedResult = (EmResult *)[[PINCache sharedCache] objectForKey:requestId];
        if (cachedResult !=nil) {
            EmLog(@"reading CachedResult");
            return success(cachedResult);
        }
    }
    
    
    //缓存判断
    if (self.cachedTimeInSeconds == -1) {
        //永久缓存
        EmResult *cachedResult = (EmResult *)[[PINCache sharedCache] objectForKey:requestId];
        if (cachedResult !=nil) {
            EmLog(@"reading CachedResult");
            return success(cachedResult);
        }
    }
    else if(self.cachedTimeInSeconds == 0){
        //永不缓存
        
    }
    else if(self.cachedTimeInSeconds >0){
        //有效期缓存
        EmResult *cachedResult = (EmResult *)[[PINCache sharedCache] objectForKey:requestId];
        NSUInteger Now =(NSUInteger)NSDate.date.timeIntervalSince1970;
        if (cachedResult !=nil && Now - cachedResult.timestamp.unsignedIntegerValue  < self.cachedTimeInSeconds) {
            EmLog(@"reading CachedResult");
            return success(cachedResult);
        }
        else{
            EmLog(@"cachedResult has been expired.");
            [[PINCache sharedCache] removeObjectForKey:requestId];
        }
    }
    
    
    __block EmValidator *responseValidtor = self.responseValidtor;
    
    __block Em_RESPONSE_TYPE responseType = self.responseType;
    
    __block NSUInteger cachedTimeSeconds = self.cachedTimeInSeconds;
    
    //成功block
    id successBlock =^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        //停止网络状态监控
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
        EmResult *result = [EmResult resultWithResult:responseObject format:(Em_RESULT_TYPE)responseType];
        //请求后验证结果
        if (![responseValidtor validWithData:result]) {
            return failure(responseValidtor.error);
        }
        //缓存数据
        if(cachedTimeSeconds !=0){
            EmLog(@"cachedResult:%@",requestId);
            [[PINCache sharedCache] setObject:result forKey:requestId];
        }
        //成功返回
        return success(result);
    };
    
    //失败block
    id failureBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        //停止网络状态监控
        [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
        failure(error);
    };
    
    //进度block
    id progressBlock = ^(NSProgress * _Nonnull downloadProgress){
        
    };
    
    //发起网络请求
    NSMutableDictionary *mutableparameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    switch (method) {
        case Em_REQUEST_GET:
            EmLog(@"Em_REQUEST_GET");
            [mutableparameters setObject:@"get" forKey:@"_method"];
            break;
        case Em_REQUEST_PUT:
            EmLog(@"Em_REQUEST_PUT");
            [mutableparameters setObject:@"put" forKey:@"_method"];
            break;
        case Em_REQUEST_POST:
            EmLog(@"Em_REQUEST_POST");
            [mutableparameters setObject:@"post" forKey:@"_method"];
            break;
        case Em_REQUEST_PATCH:
            EmLog(@"Em_REQUEST_PATCH");
            [mutableparameters setObject:@"patch" forKey:@"_method"];
            break;
        case Em_REQUEST_DELETE:
            EmLog(@"Em_REQUEST_DELETE");
            [mutableparameters setObject:@"delete" forKey:@"_method"];
            break;
        default:
            break;
    }
     [self.networkingManager.manager POST:requestUrl parameters:[NSDictionary dictionaryWithDictionary:mutableparameters] progress:progressBlock success:successBlock failure:failureBlock];
    
}

/**
 get 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)getWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure{
    [self applyToken:^{
        [self request:Em_REQUEST_GET success:success failure:failure];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 post 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)postWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure{
    [self applyToken:^{
        [self request:Em_REQUEST_POST success:success failure:failure];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 delete 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)deleteWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure{
    [self applyToken:^{
        [self request:Em_REQUEST_DELETE success:success failure:failure];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 put 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)putWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure{
    [self applyToken:^{
        [self request:Em_REQUEST_PUT success:success failure:failure];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

/**
 patch 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)patchWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure{
    [self applyToken:^{
        [self request:Em_REQUEST_PATCH success:success failure:failure];
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
