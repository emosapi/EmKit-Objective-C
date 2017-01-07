//
//  EmNetworkingManager.m
//  EmApi
//
//  Created by pengyong on 16/9/16.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import "EmNetworkingManager.h"
#define kTimeOutInterval 8
typedef void (^SuccessBlock)(NSDictionary *dict, BOOL success);
typedef void (^AFNErrorBlock)(NSError *error);
@implementation EmNetworkingManager
#pragma mark - getter
/**
 timeOutInterval 超时时间
 
 @return timeOutInterval 超时时间
 */
-(NSUInteger)timeOutInterval{
    if (!_timeOutInterval) {
        _timeOutInterval = kTimeOutInterval;
    }
    return _timeOutInterval;
}

/**
 AFHTTPSessionManager 网络请求管理器
 
 @return AFHTTPSessionManager
 */
-(AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.requestSerializer.timeoutInterval = self.timeOutInterval;
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return  _manager;
}
@end
