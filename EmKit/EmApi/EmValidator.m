//
//  EmValidaor.m
//  EmApi
//
//  Created by pengyong on 16/9/16.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import "EmValidator.h"
#import "EmDebug.h"
#import "EmResult.h"
#import <objc/runtime.h>
#import "NSDictionary+Em.h"
@implementation EmValidator

#pragma mark - instance

/**
 静态初始化验证器
 
 @param block 验证集 block
 
 @return 验证器 对象
 */
+(instancetype)validatorWithBlock:(validationBlock)block{
    return [[self alloc] initWithBlock:block];
}

/**
 动态初始化验证器
 
 @param block 验证集 block
 
 @return 验证器 对象
 */
-(instancetype)initWithBlock:(validationBlock)block{
    if (self = [super init]) {
        self.validation = block;
    }
    return self;
}
/**
 动态初始化验证器
 
 @param validation 验证集 对象
 
 @return 验证器 对象
 */
-(instancetype)initWithValidation:(id)validation{
    if (self = [super init]) {
        self.validation = validation;
    }
    return self;
}
/**
 静态初始化验证器
 
 @param validation 验证集 对象
 
 @return 验证器 对象
 */
+(instancetype)validatorWithValidation:(id)validation{
    return [[self alloc] initWithValidation:validation];
}

/**
 validWithData 验证数据
 
 @param aData 数据源
 
 @return 验证结果 布尔值
 */
-(Boolean)validWithData:(NSObject *)aData{
    //验证集为空则跳过验证
    if (self.validation ==nil) {
        return true;
    }
    //验证数据类型
    if(class_isMetaClass(object_getClass(self.validation))){
        if (![aData isKindOfClass:self.validation]) {
            self.error = [NSError errorWithDomain:@"class" code:100 userInfo:nil];
            return false;
        }
        return true;
    }
    //block验证
    if ([self.validation isKindOfClass:NSClassFromString(@"NSBlock")]) {
       validationBlock block = (validationBlock)self.validation;
        self.error = [NSError errorWithDomain:@"block" code:200 userInfo:nil];
        return block(aData);
    }
    //验证其他数据类型
    NSDictionary *aDictionary;
    if ([aData isKindOfClass:[EmResult class]]) {
        EmResult *aResult = (EmResult *)aData;
        aDictionary = aResult.response;
    }
    else if (![aData isKindOfClass:[NSDictionary class]]) {
        self.error = [NSError errorWithDomain:@"other" code:300 userInfo:@{@"type":[aData class]}];
        return [aData isEqual:self.validation];
    }
    else{
         aDictionary = (NSDictionary *)aData;
    }
    if ([self.validation isKindOfClass:[NSMutableDictionary class]]) {
        for (id key in self.validation) {
            id aValue = [aDictionary objectForKey:key];
            id aBlock = [self.validation objectForKey:key];
            if ([key isKindOfClass:[NSString class]] && aValue && [aBlock isKindOfClass:NSClassFromString(@"NSBlock")]) {
                validationBlock block = (validationBlock)[self.validation objectForKey:key];
                if(!block([aDictionary objectForKey:key])){
                    return false;
                }
            }
        }
        return true;
    }
    else if ([self.validation isKindOfClass:[NSArray class]] ) {
        for (id v in self.validation) {
            if ([v isKindOfClass:[NSString class]] && ![aDictionary containsKey:v]) {
                self.error = [NSError errorWithDomain:@"dictionary.key" code:400 userInfo:@{v:@""}];
                return false;
            }
        }
        return true;
    }else if ([self.validation isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in self.validation) {
            //验证key是否存在
            if (![aDictionary containsKey:key]) {
                self.error = [NSError errorWithDomain:@"dictionary.key" code:400 userInfo:@{key:@""}];
                return false;
            }
            //验证value数据类型
            id aSubData = [aDictionary objectForKey:key];
            id value = [self.validation objectForKey:key];
            if (class_isMetaClass(object_getClass(value)) && ![aSubData isKindOfClass:value]) {
                self.error = [NSError errorWithDomain:@"dictionary.value" code:100 userInfo:@{key:value}];
                return false;
            }
            
             //利用表达式 验证value
            if ([value isKindOfClass:[NSArray class]] && [value count]==2) {
                NSString *exp = (NSString *)[value firstObject];
                id expValue = [value lastObject];
                if ([@[@"eq",@"=="] containsObject:exp] && ![aSubData isEqual:expValue]) {
                    self.error = [NSError errorWithDomain:@"dictionary.value" code:501 userInfo:@{key:value}];
                    
                    return false;
                }
                if ([@[@"neq",@"!="] containsObject:exp] && [aSubData isEqual:expValue]) {
                    self.error = [NSError errorWithDomain:@"dictionary.value" code:502 userInfo:@{key:value}];
                    return false;
                }
                if ([@[@"gt",@">"] containsObject:exp] && [aSubData intValue] <=[expValue intValue]) {
                    self.error = [NSError errorWithDomain:@"dictionary.value" code:503 userInfo:@{key:value}];
                    return false;
                }
                if ([@[@"egt",@">="] containsObject:exp] && [aSubData intValue] <[expValue intValue]) {
                    self.error = [NSError errorWithDomain:@"dictionary.value" code:504 userInfo:@{key:value}];
                    return false;
                }
                if ([@[@"lt",@"<"] containsObject:exp] && [aSubData intValue] >=[expValue intValue]) {
                    self.error = [NSError errorWithDomain:@"dictionary.value" code:505 userInfo:@{key:value}];
                    return false;
                }
                if ([@[@"elt",@"<="] containsObject:exp] && [aSubData intValue] >[expValue intValue]) {
                    self.error = [NSError errorWithDomain:@"dictionary.value" code:506 userInfo:@{key:value}];
                    return false;
                }
                if ([@[@"in",@"^"] containsObject:exp] && [expValue isKindOfClass:[NSArray class]] && ![expValue containsObject:aSubData]) {
                    self.error = [NSError errorWithDomain:@"dictionary.value" code:507 userInfo:@{key:value}];
                    return false;
                }
                if ([@[@"notin",@"!"] containsObject:exp] && [expValue isKindOfClass:[NSArray class]] && [expValue containsObject:aSubData]) {
                    self.error = [NSError errorWithDomain:@"dictionary.value" code:508 userInfo:@{key:value}];
                    return false;
                }
                if ([@[@"between",@"()"] containsObject:exp] && [expValue isKindOfClass:[NSArray class]] && [expValue count]==2) {
                    NSNumber *expValue1 = [expValue firstObject];
                    NSNumber *expValue2 = [expValue lastObject];
                    if (aSubData >= expValue2 || aSubData <=expValue1) {
                        self.error = [NSError errorWithDomain:@"dictionary.value" code:509 userInfo:@{key:value}];
                        return false;
                    }
                }
                if ([@[@"ebetween",@"[)"] containsObject:exp] && [expValue isKindOfClass:[NSArray class]] && [expValue count]==2) {
                    NSNumber *expValue1 = [expValue firstObject];
                    NSNumber *expValue2 = [expValue lastObject];
                    if (aSubData >= expValue2 || aSubData <expValue1) {
                        self.error = [NSError errorWithDomain:@"dictionary.value" code:510 userInfo:@{key:value}];
                        return false;
                    }
                }
                if ([@[@"betweene",@"(]"] containsObject:exp] && [expValue isKindOfClass:[NSArray class]] && [expValue count]==2) {
                    NSNumber *expValue1 = [expValue firstObject];
                    NSNumber *expValue2 = [expValue lastObject];
                    if (aSubData > expValue2 || aSubData <=expValue1) {
                        self.error = [NSError errorWithDomain:@"dictionary.value" code:511 userInfo:@{key:value}];
                        return false;
                    }
                }
                if ([@[@"ebetweene",@"[]"] containsObject:exp] && [expValue isKindOfClass:[NSArray class]] && [expValue count]==2) {
                    NSNumber *expValue1 = [expValue firstObject];
                    NSNumber *expValue2 = [expValue lastObject];
                    if (aSubData > expValue2 || aSubData <expValue1) {
                        self.error = [NSError errorWithDomain:@"dictionary.value" code:512 userInfo:@{key:value}];
                        return false;
                    }
                }
                
            }
            
        }
    }
    return true;
}

/**
 addValidationBlock
 
 @param block block 验证代码块
 @param key   key  验证字段名
 */
-(void)addValidationBlock:(validationBlock)block forKey:(NSString *)key{
    if (![self.validation isKindOfClass:[NSMutableDictionary class]]) {
        self.validation = [NSMutableDictionary dictionary];
    }
    [self.validation setObject:block forKey:key];
}
@end
