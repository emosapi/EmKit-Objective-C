//
//  NSDictionary+Em.h
//  EmApi
//
//  Created by pengyong on 16/9/16.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSDictionary(Em)

/**
 copyObject 复制插入对象

 @param anObject 插入的对象值
 @param aKey     插入的对象键名

 @return 字典副本对象
 */
-(NSDictionary *)copyObject:(id)anObject forKey:(id <NSCopying>)aKey;

/**
 containsKey 是否包含key
 
 @param aKey key值
 
 @return 布尔值
 */
-(Boolean)containsKey:(id<NSCopying>)aKey;

/**
 md5 加密
 
 @return 加密字符串
 */
- (NSString *) md5;

/**
 sha1 加密
 
 @return 加密字符串
 */
- (NSString *) sha1;


/**
 获取key对应键
 
 @param key key
 
 @return key对应键值
 */
-(id)objectWithKey:(NSString *)key;
/**
 获取key对应键值
 
 @param key       key
 @param component 分隔符
 
 @return key对应键值
 */
-(id)objectWithKey:(NSString *)key component:(NSString *)component;
/**
 是否包含key
 
 @param key key
 
 @return 布尔值
 */
-(Boolean)hasKey:(NSString *)key;
/**
 是否包含key
 
 @param key       key
 @param component 分隔符
 
 @return 布尔值
 */
-(Boolean)hasKey:(NSString *)key component:(NSString *)component;
@end
