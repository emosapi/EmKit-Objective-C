//
//  EmDebug.h
//  MoodboxApi
//
//  Created by terry peng on 16/9/17.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#ifndef EmDebug_h
#define EmDebug_h
#define EmString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
#define EmLog(...) printf("%s: %s 第%d行: %s\n\n",[[NSString EmStringDate] UTF8String], [EmString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define EmLog(...)
#endif /* EmDebug_h */
