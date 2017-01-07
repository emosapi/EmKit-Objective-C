//
//  NSString+Em.m
//  MoodboxApi
//
//  Created by terry peng on 16/9/17.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import "NSString+Em.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString(Em)

/**
 sha1 加密
 
 @return 加密字符串
 */
- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}
/**
 md5 加密
 
 @return 加密字符串
 */
-(NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

/**
 格式化时间

 @return 字符串
 */
+(NSString *)EmStringDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}

/**
 是否以前缀字符串打头
 
 @param aString 前缀字符串
 
 @return 布尔值
 */
-(Boolean)startByString:(NSString *)aString{
    return  [self length]<[aString length] ? false:[aString isEqualToString:[self substringWithRange:NSMakeRange(0, [aString length])]];
}

/**
 截取字符串
 
 @param start 开始字符串
 @param end   结束字符串
 
 @return 截取后的字符串
 */
-(NSString *)substringFromStart:(NSString *)start end:(NSString *)end{
    NSMutableArray *a = [NSMutableArray arrayWithArray: [self componentsSeparatedByString:start]];
    if (a.count >=2) {
        [a setObject:@"" atIndexedSubscript:0];
        NSArray *b = [[a componentsJoinedByString:@""] componentsSeparatedByString:end];
        if (b.count >0) {
            return (NSString *)[b objectAtIndex:0];
        }
        return @"";
    }
    return @"";
}
@end
