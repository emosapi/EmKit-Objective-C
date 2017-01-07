//
//  EmResult.m
//  MoodboxApi
//
//  Created by terry peng on 16/9/17.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import "EmResult.h"
#import "EmHeader.h"
#import <MPMessagePack/MPMessagePack.h>
#define kDefaultCode @102
#define kDefaultDescription @""
#define kDefaultResponse @{}
#define kDefaultDetail @""
#define kDefaultErrors @[]
#define kDefaultTimestamp @0
@implementation EmResult

#pragma mark - encoder

/**
 initWithCoder

 @param aDecoder 解码器

 @return EmResult 对象
 */
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.code = (NSNumber *)[aDecoder decodeObjectForKey:@"code"];
        self.Description = (NSString *)[aDecoder decodeObjectForKey:@"description"];
        self.response = (NSDictionary *)[aDecoder decodeObjectForKey:@"response"];
        self.timestamp = (NSNumber *)[aDecoder decodeObjectForKey:@"timestamp"];
    }
    return self;
}

/**
 encodeWithCoder

 @param aCoder 编码器
 */
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.code forKey:@"code"];
    [aCoder encodeObject:self.Description forKey:@"description"];
    [aCoder encodeObject:self.response forKey:@"response"];
    [aCoder encodeObject:self.timestamp forKey:@"timestamp"];
}


#pragma mark - getter
/**
 code 状态码
 */
-(NSNumber *)code{
    if (!_code) {
        _code = kDefaultCode;
    }
    return _code;
}
/**
 description 状态信息
 */
-(NSString *)Description{
    if (!_Description) {
        _Description = kDefaultDescription;
    }
    return _Description;
}

/**
 results 正常结果集
 */
-(NSDictionary *)response{
    if (!_response) {
        _response = kDefaultResponse;
    }
    return _response;
}

/**
 timestamp 响应的时间戳
 */
-(NSNumber *)timestamp{
    if (!_timestamp) {
        _timestamp = kDefaultTimestamp;
    }
    return _timestamp;
}


#pragma mark - defined setter

/**
 加载响应数据

 @param response 响应数据 字典格式
 */
-(void)loadResponse:(NSDictionary *)response{
    if (response == nil || ![response isKindOfClass:[NSDictionary class]]) {
        return;
    }
    if ([response containsKey:@"code"]) {
        self.code = [response objectForKey:@"code"];
    }
    if ([response containsKey:@"description"]) {
        NSString *description = [[response objectForKey:@"description"] stringByRemovingPercentEncoding];
        self.Description = description;
    }
    if ([response containsKey:@"response"]) {
        NSDictionary *Response = [response objectForKey:@"response"];
        self.response = Response;
    }
    if ([response containsKey:@"timestamp"]) {
        self.timestamp = [response objectForKey:@"timestamp"];
    }
    else{
        self.timestamp = [NSNumber numberWithUnsignedInteger:(NSUInteger)NSDate.date.timeIntervalSince1970];
    }
}


#pragma mark - instance


/**
 initWithMsgpack 动态初始化

 @param responseObject msgpack数据源

 @return  EmResult 对象
 */
-(instancetype)initWithMsgpack:(id)responseObject{
    if (self = [super init]) {
        NSError *error;
        NSDictionary *response = [MPMessagePackReader readData:responseObject error:&error];
        if (response) {
            if([response objectForKey:@"code"]){
                self.code = [response objectForKey:@"code"];
            }
            if([response objectForKey:@"description"]) self.Description = (NSString *)[response objectForKey:@"description"];
            if([response objectForKey:@"timestamp"]){
                self.timestamp =[response objectForKey:@"timestamp"];
            }
            if([response objectForKey:@"response"]) self.response = (NSDictionary *)[response objectForKey:@"response"];
        }
        else{
            EmLog(@"%@",error);
        }
    }
    return self;
}


/**
 initWithJsonp 动态初始化

 @param responseObject jsonp数据源

 @return EmResult 对象
 */
-(instancetype)initWithJsonp:(id)responseObject{
    if (self = [super init]) {
        //todo
    }
    return self;
}


/**
 initWithXml 动态初始化

 @param responseObject xml数据源

 @return EmResult 对象
 */
-(instancetype)initWithXml:(id)responseObject{
    if (self = [super init]) {
        //todo
    }
    return self;
}


/**
 initWithJson 动态初始化

 @param responseObject json数据源

 @return EmResult 对象
 */
-(instancetype)initWithJson:(id)responseObject{
    if (self = [super init]) {
        NSError *error;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&error];
        if (result) {
            if([result objectForKey:@"code"]){
                self.code =  [result objectForKey:@"code"];
            }
            if([result objectForKey:@"description"]){
                self.Description = (NSString *)[result objectForKey:@"description"];
            }
            if([result objectForKey:@"timestamp"]){
                self.timestamp = [result objectForKey:@"timestamp"];
            }
            if([result objectForKey:@"response"]) self.response = (NSDictionary *)[result objectForKey:@"response"];
        }
        else{
            EmLog(@"error:%@",error);
        }
    }
    return self;
}


/**
 initWithDictionary 动态初始化
 
 @param responseObject Dictionary 数据源
 
 @return EmResult 对象
 */
-(instancetype)initWithDictionary:(id)responseObject{
    if (self = [super init]) {
        NSDictionary *result = (NSDictionary *)responseObject;
        if([result objectForKey:@"code"]){
            self.code = [result objectForKey:@"code"];
        }
        if([result objectForKey:@"code"]){
            self.code =  [result objectForKey:@"code"];
        }
        if([result objectForKey:@"description"]) self.Description = (NSString *)[result objectForKey:@"description"];
        if([result objectForKey:@"timestamp"]){
            self.timestamp = [result objectForKey:@"timestamp"];
        }
        if([result objectForKey:@"response"]) self.response = (NSDictionary *)[result objectForKey:@"response"];
    }
    return self;
}







/**
 initWithResult 动态初始化

 @param responseObject 数据源
 @param format         数据源格式

 @return EmResult 对象
 */
-(instancetype)initWithResult:(id)responseObject format:(Em_RESULT_TYPE)format{
    if (self = [super init]) {
        switch (format) {
            case Em_RESULT_XML:
                return [self initWithXml:responseObject];
                break;
            case Em_RESULT_JSON:
                return [self initWithJson:responseObject];
                break;
            case Em_RESULT_JSONP:
                return [self initWithJsonp:responseObject];
                break;
            case Em_RESULT_MSGPACK:
                return [self initWithMsgpack:responseObject];
                break;
        }
    }
    return self;
}


/**
 resultWithResult 静态初始化

 @param responseObject 数据源
 @param format         数据源格式

 @return EmResult 对象
 */
+(instancetype)resultWithResult:(id)responseObject format:(Em_RESULT_TYPE)format{
    return [[self alloc] initWithResult:responseObject format:format];
}



/**
 resultWithJson 静态初始化

 @param responseObject json 数据源

 @return EmResult 对象
 */
+(instancetype)resultWithJson:(id)responseObject{
    return [[self alloc] initWithJson:responseObject];
}


/**
 resultWithJsonp 静态初始化

 @param responseObject jsonp 数据源

 @return EmResult 对象
 */
+(instancetype)resultWithJsonp:(id)responseObject{
    return [[self alloc] initWithJsonp:responseObject];
}


/**
 resultWithXml 静态初始化

 @param responseObject xml 数据源

 @return EmResult 对象
 */
+(instancetype)resultWithXml:(id)responseObject{
    return [[self alloc] initWithXml:responseObject];
}

/**
 resultWithMsgpack 静态初始化

 @param responseObject msgpack 数据源

 @return EmResult 对象
 */
+(instancetype)resultWithMsgpack:(id)responseObject{
    return [[self alloc] initWithMsgpack:responseObject];
}

/**
 resultWithDictionary 静态初始化
 
 @param responseObject Dictionary 数据源
 
 @return EmResult 对象
 */
+(instancetype)resultWithDictionary:(id)responseObject{
    return [[self alloc] initWithDictionary:responseObject];
}

#pragma mark - rewrite method
-(NSString *)description{
    NSMutableDictionary * desc = [NSMutableDictionary dictionary];
    [desc setObject:self.code forKey:@"code"];
    [desc setObject:self.timestamp forKey:@"timestamp"];
    [desc setObject:self.Description forKey:@"description"];
    [desc setObject:self.response  forKey:@"response"];
    return [desc description];
}
@end
