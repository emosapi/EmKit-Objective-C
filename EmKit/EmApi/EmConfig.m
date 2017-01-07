//
//  EmConfig.m
//  MoodboxApi
//
//  Created by terry peng on 16/9/17.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import "EmConfig.h"
#import "EmValidator.h"
#import <PINCache/PINCache.h>

#define kDefaultTokenName @"token"
#define kDefaultExpireName @"expire"
#define kDefaultDomain @"emosapi.com"
#define kDefaultProtocal @"https"

#define kDefaultVersion @"master"
#define kDefaultParameters @{}
#define kDefaultRequestValidtor nil
#define kDefaultResponseValidtor nil
#define kDefaultResponseType Em_RESPONSE_JSON
#define kDefaultCachedTimeInSeconds 0

#define kDefaultAppKey @""
#define kDefaultAppSecret @""

@implementation EmConfig

#pragma mark - setter
/**
 保存令牌
 
 @param token 令牌
 @param expire 过期时间
 */
-(void)saveToken:(NSString *)token andExpire:(NSNumber *)expire{
    [[PINCache sharedCache] setObject:token forKey:kDefaultTokenName];
     [[PINCache sharedCache] setObject:expire forKey:kDefaultExpireName];
    _token = token;
    _expire = expire;
}

#pragma mark - getter
/**
 token 令牌
 
 @return 令牌 字符串
 */
-(NSString *)token{
    if (!_token) {
        _token = [[PINCache sharedCache] objectForKey:kDefaultTokenName];
    }
    return _token;
}

/**
 令牌有效期

 @return 令牌有效期
 */
-(NSNumber *)expire{
    if (!_expire) {
        _expire = [[PINCache sharedCache] objectForKey:kDefaultExpireName];
    }
    return _expire;
}

/**
 tokenName 秘钥名称
 
 @return 秘钥名称 字符串
 */
-(NSString *)tokenName{
    if (!_tokenName) {
        _tokenName = kDefaultTokenName;
    }
    return _tokenName;
}

/**
 domain 域名
 
 @return 域名 字符串
 */
-(NSString *)domain{
    if (!_domain) {
        _domain = kDefaultDomain;
    }
    return _domain;
}

/**
 protocal 协议
 
 @return 协议 字符串
 */
-(NSString *)protocal{
    if (!_protocal) {
        _protocal = kDefaultProtocal;
    }
    return _protocal;
}




/**
 version API版本
 
 @return API版本 字符串
 */
-(NSString *)version{
    if (!_version) {
        _version = kDefaultVersion;
    }
    return _version;
}


/**
 parameters 请求参数
 
 @return 请求参数 字典
 */
-(NSDictionary *)parameters{
    if (!_parameters) {
        _parameters = kDefaultParameters;
    }
    return _parameters;
}


/**
 requestValidtor 请求验证器
 
 @return 请求验证器 对象
 */
-(EmValidator *)requestValidtor{
    return [EmValidator validatorWithValidation:kDefaultRequestValidtor];
}


/**
 responseValidtor 响应验证器
 
 @return 响应验证器 对象
 */
-(EmValidator *)responseValidtor{
    return [EmValidator validatorWithValidation:kDefaultResponseValidtor];
}

/**
 responseType 响应类型
 
 @return 响应类型 枚举值
 */
-(Em_RESPONSE_TYPE)responseType{
    return kDefaultResponseType;
}


/**
 cachedTimeInSeconds
 
 @return 缓存有效期 秒数
 */
-(NSInteger)cachedInTimeSeconds{
    if (!_cachedTimeInSeconds) {
        _cachedTimeInSeconds = kDefaultCachedTimeInSeconds;
    }
    return _cachedTimeInSeconds;
}

/**
 appkey 秘钥
 */
-(NSString *)appkey{
    if (!_appkey) {
        _appkey = kDefaultAppKey;
    }
    return _appkey;
}

/**
 appsecret 密匙
 */
-(NSString *)appsecret{
    if(!_appsecret){
        _appsecret = kDefaultAppSecret;
    }
    return _appsecret;
}

#pragma mark - instance

/**
 初始化配置
 
 @param token 令牌
 @param expire 过期时间
 @return 配置对象
 */
-(instancetype)initWithToken:(NSString *)token andExpire:(NSNumber *)expire{
    if (self = [super init]) {
        [self saveToken:token andExpire:expire];
    }
    return self;
}


/**
 初始化配置
 
 @param token 令牌
 @param expire 过期时间
 @return 配置对象
 */
+(instancetype)configWithToken:(NSString *)token andExpire:(NSNumber *)expire{
     return [[self alloc] initWithToken:token andExpire:expire];
}


@end
