//
//  NSDictionary+Em.m
//  EmApi
//
//  Created by pengyong on 16/9/16.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import "NSDictionary+Em.h"
#import "NSString+Em.h"
@implementation NSDictionary(Em)
/**
 copyObject 复制插入对象
 
 @param anObject 插入的对象值
 @param aKey     插入的对象键名
 
 @return 字典副本对象
 */
-(NSDictionary *)copyObject:(id)anObject forKey:(id <NSCopying>)aKey{
    NSMutableDictionary * ref = [NSMutableDictionary dictionaryWithDictionary:self];
    [ref setObject:anObject forKey:aKey];
    return [NSDictionary dictionaryWithDictionary:ref];
}

/**
 containsKey 是否包含key

 @param aKey key值

 @return 布尔值
 */
-(Boolean)containsKey:(id<NSCopying>)aKey{
   return [[self allKeys] containsObject:aKey];
}
/**
 md5 加密
 
 @return 加密字符串
 */
-(NSString *)md5{
   return [[self description] md5];
}

/**
 sha1 加密
 
 @return 加密字符串
 */
- (NSString *) sha1{
    return [[self description] sha1];
}



/**
 获取key键值

 @param array 分割key数组

 @return 键值
 */
-(id)objectWithComponentArray:(NSArray *)array{
    NSMutableArray * keys =[NSMutableArray arrayWithArray:array];
    NSString *k = [keys firstObject];
    if (![self objectForKey:k]) {
        return nil;
    }
    if (![[self objectForKey:k] isKindOfClass:[NSDictionary class]]) {
        return [self objectForKey:k];
    }
    [keys removeObjectAtIndex:0];
    return [[self objectForKey:k] objectWithComponentArray:[NSArray arrayWithArray:keys]];
}


/**
 获取key对应键值

 @param key       key
 @param component 分隔符

 @return key对应键值
 */
-(id)objectWithKey:(NSString *)key component:(NSString *)component{
    return [self objectWithComponentArray:[key componentsSeparatedByString:component]];
}


/**
 获取key对应键

 @param key key

 @return key对应键值
 */
-(id)objectWithKey:(NSString *)key{
    return  [self objectWithKey:key component:@"."];
}


/**
 是否包含key

 @param key key

 @return 布尔值
 */
-(Boolean)hasKey:(NSString *)key{
    return [self hasKey:key component:@"."];
}

/**
 是否包含key

 @param key       key
 @param component 分隔符

 @return 布尔值
 */
-(Boolean)hasKey:(NSString *)key component:(NSString *)component{
    return nil != [self objectWithKey:key component:component];
}
@end
