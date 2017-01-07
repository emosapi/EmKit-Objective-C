//
//  EmResult.h
//  MoodboxApi
//
//  Created by terry peng on 16/9/17.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 RESULT 数据类型枚举
 
 - Em_RESULT_XML:     XML数据格式
 - Em_RESULT_JSON:    JSON数据格式
 - Em_RESULT_JSONP:   JSONP数据格式
 - Em_RESULT_MSGPACK: MSGPACK打包数据格式
 */
typedef NS_ENUM(NSUInteger, Em_RESULT_TYPE)
{
    Em_RESULT_XML = 0,
    Em_RESULT_JSON = 1,
    Em_RESULT_JSONP = 2,
    Em_RESULT_MSGPACK = 3,
};
@interface EmResult : NSObject<NSCoding>

/**
 code 状态码
 */
@property(nonatomic,strong) NSNumber *code;

/**
 description 状态信息
 */
@property(nonatomic,strong) NSString *Description;


/**
 result 正常结果集
 */
@property(nonatomic,strong) NSDictionary *response;


/**
 timestamp 响应的时间戳
 */
@property(nonatomic,strong) NSNumber *timestamp;

/**
 resultWithResult 静态初始化
 
 @param responseObject 数据源
 @param format         数据源格式
 
 @return EmResult 对象
 */
+(instancetype)resultWithResult:(id)responseObject format:(Em_RESULT_TYPE)format;
/**
 initWithResult 动态初始化
 
 @param responseObject 数据源
 @param format         数据源格式
 
 @return EmResult 对象
 */
-(instancetype)initWithResult:(id)responseObject format:(Em_RESULT_TYPE)format;
/**
 resultWithXml 静态初始化
 
 @param responseObject xml 数据源
 
 @return EmResult 对象
 */
+(instancetype)resultWithXml:(id)responseObject;
/**
 initWithXml 动态初始化
 
 @param responseObject xml数据源
 
 @return EmResult 对象
 */
-(instancetype)initWithXml:(id)responseObject;
/**
 resultWithJson 静态初始化
 
 @param responseObject json 数据源
 
 @return EmResult 对象
 */
+(instancetype)resultWithJson:(id)responseObject;
/**
 initWithJson 动态初始化
 
 @param responseObject json数据源
 
 @return EmResult 对象
 */
-(instancetype)initWithJson:(id)responseObject;

/**
 resultWithDictionary 静态初始化
 
 @param responseObject Dictionary 数据源
 
 @return EmResult 对象
 */
+(instancetype)resultWithDictionary:(id)responseObject;
/**
 initWithDictionary 动态初始化
 
 @param responseObject Dictionary 数据源
 
 @return EmResult 对象
 */
-(instancetype)initWithDictionary:(id)responseObject;



/**
 resultWithJsonp 静态初始化
 
 @param responseObject jsonp 数据源
 
 @return EmResult 对象
 */
+(instancetype)resultWithJsonp:(id)responseObject;
/**
 initWithJsonp 动态初始化
 
 @param responseObject jsonp数据源
 
 @return EmResult 对象
 */
-(instancetype)initWithJsonp:(id)responseObject;

/**
 resultWithMsgpack 静态初始化
 
 @param responseObject msgpack 数据源
 
 @return EmResult 对象
 */
+(instancetype)resultWithMsgpack:(id)responseObject;
/**
 initWithMsgpack 动态初始化
 
 @param responseObject msgpack数据源
 
 @return  EmResult 对象
 */
-(instancetype)initWithMsgpack:(id)responseObject;

@end
