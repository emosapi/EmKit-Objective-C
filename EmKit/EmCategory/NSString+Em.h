//
//  NSString+Em.h
//  MoodboxApi
//
//  Created by terry peng on 16/9/17.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Em)

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
 格式化时间

 @return 字符串
 */
+ (NSString *)EmStringDate;

/**
 是否以前缀字符串打头

 @param aString 前缀字符串

 @return 布尔值
 */
-(Boolean)startByString:(NSString *)aString;

/**
 截取字符串

 @param start 开始字符串
 @param end   结束字符串

 @return 截取后的字符串
 */
-(NSString *)substringFromStart:(NSString *)start end:(NSString *)end;
@end
