//
//  AliyunInit.h
//  cordova-demo
//
//  Created by 袁训锐 on 2020/2/20.
//

//#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliyunInit : NSObject

@property (nonatomic, strong) NSDictionary *aliyunInfo;

#pragma mark 手动启动服务

+ (instancetype)shareInstance;

/// 参数注册
- (void)registerParameterWithAppVersion:(NSString *)appVersion channel:(NSString *)channel nick:(NSString *)nick;

/// 性能监控初始化接口（自动读取appKey、appSecret）
- (void)initAlicloudAPM;

/// 远程日志初始化接口（自动读取appKey、appSecret）
- (void)initAlicloudTlog;

/// 崩溃分析始化接口
- (void)initAlicloudCrash;

/// 启动AppMonitor服务
- (void)start;

#pragma mark 自动启动服务

/// 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
/// @param appVersion app版本号
/// @param channel 渠道
/// @param nick 昵称
/// @param block result
- (void)autoStartAliyunAnalyticsWithAppVersion:(NSString *)appVersion channel:(NSString *)channel nick:(NSString *)nick resultBlock:(void (^)(BOOL result, NSString *))block;
@end

NS_ASSUME_NONNULL_END
