//
//  EmConfig.h
//  MoodboxApi
//
//  Created by terry peng on 16/9/17.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EmValidator;
/**
 API请求方法枚举
 
 - Em_REQUEST_GET:    GET 请求
 - Em_REQUEST_PUT:    PUT 请求
 - Em_REQUEST_POST:   POST 请求
 - Em_REQUEST_DELETE: DELETE 请求
 - Em_REQUEST_PATCH:  PATCH 请求
 */
typedef NS_ENUM(NSUInteger, Em_REQUEST_METHOD)
{
    Em_REQUEST_GET = 0,
    Em_REQUEST_PUT = 1,
    Em_REQUEST_POST = 2,
    Em_REQUEST_DELETE = 3,
    Em_REQUEST_PATCH = 4,
};

/**
 API响应数据类型枚举
 
 - Em_RESPONSE_XML:     XML数据格式
 - Em_RESPONSE_JSON:    JSON数据格式
 - Em_RESPONSE_JSONP:   JSONP数据格式
 - Em_RESPONSE_MSGPACK: MSGPACK打包数据格式
 */
typedef NS_ENUM(NSUInteger, Em_RESPONSE_TYPE)
{
    Em_RESPONSE_XML = 0,
    Em_RESPONSE_JSON = 1,
    Em_RESPONSE_JSONP = 2,
    Em_RESPONSE_MSGPACK = 3,
};
@interface EmConfig : NSObject

#pragma mark - property

/**
 token 秘钥
 */
@property(nonatomic,strong) NSString *token;

/**
 tokenName 秘钥名称
 */
@property(nonatomic,strong) NSString *tokenName;


/**
 expire 过期时间
 */
@property(nonatomic,strong) NSNumber *expire;

/**
 appkey 秘钥
 */
@property(nonatomic,strong) NSString *appkey;

/**
 appsecret 密匙
 */
@property(nonatomic,strong) NSString *appsecret;

/**
 domain 域名
 */
@property(nonatomic,strong) NSString *domain;

/**
 protocal 网络协议
 */
@property(nonatomic,strong) NSString *protocal;

/**
 version 版本
 */
@property(nonatomic,strong) NSString *version;


/**
 parameters 请求参数
 */
@property(nonatomic,strong) NSDictionary *parameters;


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



#pragma mark - method


/**
 保存令牌

 @param token 令牌
 @param expire 过期时间
 */
-(void)saveToken:(NSString *)token andExpire:(NSNumber *)expire;



/**
 初始化配置

 @param token 令牌
 @param expire 过期时间
 @return 配置对象
 */
-(instancetype)initWithToken:(NSString *)token andExpire:(NSNumber *)expire;


/**
 初始化配置

 @param token 令牌
 @param expire 过期时间
 @return 配置对象
 */
+(instancetype)configWithToken:(NSString *)token andExpire:(NSNumber *)expire;

@end
