//
//  EmApiBase.h
//  EmApi
//
//  Created by pengyong on 16/9/16.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmConfig.h"
@class EmValidator;
@class EmResult;
@class EmNetworkingManager;
@interface EmApi : NSObject

#pragma mark - instancetype
/**
 加载配置

 @param config 配置
 @return API对象
 */
-(instancetype)config:(EmConfig *)config;


/**
 加载请求参数

 @param parameters 参数
 @return API对象
 */
-(instancetype)parameters:(NSDictionary *)parameters;

/**
 设置API

 @param api API名称
 @return API对象
 */
-(instancetype)api:(NSString *)api;

#pragma mark - request
/**
 get 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)getWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure;
/**
 post 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)postWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure;
/**
 delete 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)deleteWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure;
/**
 put 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)putWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure;
/**
 patch 发起请求
 
 @param success 成功block
 @param failure 失败block
 */
-(void)patchWithSuccess:(void (^)(EmResult *result))success failure:(void (^)(NSError *error))failure;
@end
