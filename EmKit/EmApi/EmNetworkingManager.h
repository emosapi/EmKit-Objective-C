//
//  EmNetworkingManager.h
//  EmApi
//
//  Created by pengyong on 16/9/16.
//  Copyright © 2016年 Ivo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/UIKit+AFNetworking.h>
@interface EmNetworkingManager : NSObject
/**
 timeOutInterval 超时时间
 */
@property(nonatomic,assign) NSUInteger timeOutInterval;

/**
  AFHTTPSessionManager  网络请求管理器
 */
@property(nonatomic,strong) AFHTTPSessionManager *manager;
@end
