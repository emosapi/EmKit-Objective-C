//
//  EmValidaor.h
//  EmApi
//
//  Created by pengyong on 16/9/16.
//  Copyright © 2016年 Ivo. All rights reserved.
//
//  validation 格式说明
/*
 
  验证数据类型
 
  class
 
  [NSString class]
 
  [NSDictionary class]
 
  ...
 
 验证数字
 
  @100    是否为100
 
  验证字符串
 
  @“”    是否为空字符串
 
 
  验证字典数据
 
  验证 key
 
  @[@"key1",@"key2"]
 
 
 
  验证 key 和 value 类型
 
  @{
        @"key1":[NSString class],
        @"key2":[NSDictionary class]
  }
 
  验证 value 等值比较
 
 @{
    @"key1":value1,
    @"key2":value2
 }
  验证 value  表达式
 
  @{
    @"key1":@[@"==",value1],
    @"key2":@[@"^",@[somevalue1,somevalue2]]
 }
 
 //英文表达式  符号表达式
 //eq        ==
 //neq       !=
 //gt        >
 //egt       >=
 //elt       <=
 //lt        <
 //in        ^
 //notin     !
 //between   ()      在(a,b) 开区间
 //ebetween  [)      在[a,b) 前闭后开
 //betweene  (]      在(a,b] 前开后闭
 //ebetweene []      在[a,b] 闭区间
 
 两种表达式 均支持
 
 block 验证
 
 validation =  validationblock;
 
 
 错误验证code
 code 100 - 200 数据类型 验证
 
 code 200 - 300 block 验证
 
 code 300 - 400  其他 验证
 
 code 400 - 500  key 验证
 
 code 500 - 600  表达式 验证
 
*/
//

#import <Foundation/Foundation.h>
typedef Boolean (^validationBlock)(id);
@interface EmValidator : NSObject

/**
 validation 验证集 对象
 */
@property(nonatomic,) id validation;

@property(nonatomic,strong) NSError *error;


/**
 静态初始化验证器
 
 @param block 验证集 block
 
 @return 验证器 对象
 */
+(instancetype)validatorWithBlock:(validationBlock)block;


/**
 动态初始化验证器
 
 @param block 验证集 block
 
 @return 验证器 对象
 */
-(instancetype)initWithBlock:(validationBlock)block;


/**
 静态初始化验证器

 @param validation 验证集 对象

 @return 验证器 对象
 */
+(instancetype)validatorWithValidation:(id)validation;

/**
 动态初始化验证器

 @param validation 验证集 对象

 @return 验证器 对象
 */
-(instancetype)initWithValidation:(id)validation;

/**
 validWithData 验证数据

 @param aData 数据源

 @return 验证结果 布尔值
 */
-(Boolean)validWithData:(NSObject *)aData;

/**
 addValidationBlock

 @param block block 验证代码块
 @param key   key  验证字段名
 */
-(void)addValidationBlock:(validationBlock)block forKey:(NSString *)key;
@end
