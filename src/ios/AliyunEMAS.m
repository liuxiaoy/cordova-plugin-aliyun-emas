//
//  AliyunEMAS.m
//  demo1
//
//  Created by 袁训锐 on 2020/4/8.
//  Copyright © 2020 XR. All rights reserved.
//

#import "AliyunEMAS.h"
#import "AliyunInit.h"
#import "AliyunRemoteLog.h"
#import "AliyunMobileAnalytics.h"

@implementation AliyunEMAS

#pragma mark - 初始化
/*!
* @brief 初始化准备数据
* @details 优先调用，否则可能会出现意想不到的bug
*/
- (void)registerData:(CDVInvokedUrlCommand *)command {
    NSString *callbackId = command.callbackId;

    /// 注册parameter
    CDVPluginResult * (^ registerParameterBlock)(CDVInvokedUrlCommand *) = ^(CDVInvokedUrlCommand *command) {
        if (command.arguments.count && command.arguments.count >= 3) {
            NSString *appVersion = [command.arguments objectAtIndex:0];
            NSString *channel = [command.arguments objectAtIndex:1];
            NSString *nick = [command.arguments objectAtIndex:2];
            // 参数注册
            [[AliyunInit shareInstance]registerParameterWithAppVersion:appVersion channel:channel nick:nick];
            return [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[NSString stringWithFormat:@"%@", command.arguments]];
        } else {
            return [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:[NSString stringWithFormat:@"%s %@ %@", __FUNCTION__, @"传入的参数不合规", command.arguments]];
        }
    };

    CDVPluginResult *resultForRegisterParameter = registerParameterBlock(command);
    return [self.commandDelegate sendPluginResult:resultForRegisterParameter callbackId:callbackId];
}

#pragma mark - 性能分析、崩溃分析、远程日志

/*!
* @brief 性能监控初始化接口（自动读取appKey、appSecret）
* @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudAPM:(CDVInvokedUrlCommand *)command {
    [[AliyunInit shareInstance]initAlicloudAPM];
}

/*!
* @brief 远程日志初始化接口（自动读取appKey、appSecret）
* @details 远程日志初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudTlog:(CDVInvokedUrlCommand *)command {
    [[AliyunInit shareInstance]initAlicloudTlog];
}

/*!
* @brief 崩溃分析始化接口（自动读取appKey、appSecret）
* @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudCrash:(CDVInvokedUrlCommand *)command {
    [[AliyunInit shareInstance]initAlicloudCrash];
}

/*!
* @brief 启动AppMonitor服务
* @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
*/
- (void)start:(CDVInvokedUrlCommand *)command {
    [self.commandDelegate runInBackground:^{
        dispatch_async(dispatch_get_main_queue(), ^{
                           [[AliyunInit shareInstance]start];
                       });
    }];
}

#pragma mark 自动启动服务
/**
 @brief 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
 自动读取appKey、appSecret
 只需单独集成此api即可
 启动服务需在config.xml中配置，具体参照文档说明
 函数会返回失败信息，成功无返回
 */
- (void)autoStartAliyunAnalyticsWithArgs:(CDVInvokedUrlCommand *)command {
    NSString *callbackId = command.callbackId;
    NSString *appVersion = [command.arguments objectAtIndex:0];
    NSString *channel = [command.arguments objectAtIndex:1];
    NSString *nick = [command.arguments objectAtIndex:2];

    [[AliyunInit shareInstance]autoStartAliyunAnalyticsWithAppVersion:appVersion channel:channel nick:nick resultBlock:^(BOOL bol, NSString *message) {
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:bol ? CDVCommandStatus_OK : CDVCommandStatus_ERROR messageAsString:message];
        return [self.commandDelegate sendPluginResult:result callbackId:callbackId];
    }];
}

#pragma mark - 远程日志

/// 错误
- (void)error:(CDVInvokedUrlCommand *)command {
    NSString *title = [command.arguments objectAtIndex:0];
    NSString *message = [command.arguments objectAtIndex:1];
    [[AliyunRemoteLog shareInstance]errorWithTitle:title message:message];
}

/// 警告
- (void)warn:(CDVInvokedUrlCommand *)command {
    NSString *title = [command.arguments objectAtIndex:0];
    NSString *message = [command.arguments objectAtIndex:1];
    [[AliyunRemoteLog shareInstance]warnWithTitle:title message:message];
}

/// 默认
- (void)info:(CDVInvokedUrlCommand *)command {
    NSString *title = [command.arguments objectAtIndex:0];
    NSString *message = [command.arguments objectAtIndex:1];
    [[AliyunRemoteLog shareInstance]infoWithTitle:title message:message];
}

/// debug
- (void)debug:(CDVInvokedUrlCommand *)command {
    NSString *title = [command.arguments objectAtIndex:0];
    NSString *message = [command.arguments objectAtIndex:1];
    [[AliyunRemoteLog shareInstance]debugWithTitle:title message:message];
}

#pragma mark - 移动数据分析
/**
 @brief 初始化（自动）
 */
- (void)autoInitManSdk:(CDVInvokedUrlCommand *)command {
    [[AliyunMobileAnalytics shareInstance]autoInitManSdkWithDebug:NO];
}

/**
 @brief 登录会员
 功能: 获取登录会员，然后会给每条日志添加登录会员字段
 调用时机: 登录时调用
 备注: 阿里云 平台上的登录会员 UV 指标依赖该接口
 @param pNick 用户昵称
 @param pUserId 用户id
 */
- (void)userLogin:(CDVInvokedUrlCommand *)command {
    NSString *pNick = [command.arguments objectAtIndex:0];
    NSString *pUserId = [command.arguments objectAtIndex:1];
    [[AliyunMobileAnalytics shareInstance]updateUserAccount:pNick userid:pUserId];
}

/**
 @brief 注册会员
 功能: 产生一条注册会员事件日志
 调用时机: 注册时调用
 备注: 阿里云 平台上注册会员指标依赖该接口
 */
- (void)userRegister:(CDVInvokedUrlCommand *)command {
    NSString *pUsernick = [command.arguments objectAtIndex:0];
    [[AliyunMobileAnalytics shareInstance]userRegister:pUsernick];
}

/**
 @brief 自定义事件
 */
- (void)customEventBuilder:(CDVInvokedUrlCommand *)command {

    NSString *eventLabel = [command.arguments objectAtIndex:0];
    NSString *pageName = [command.arguments objectAtIndex:1];
    double duration = [[command.arguments objectAtIndex:2] longLongValue];
    NSDictionary *dict = [command.arguments objectAtIndex:3];
    [[AliyunMobileAnalytics shareInstance]customEventBuilderWithEventLabel:eventLabel eventPage:pageName duration:duration parameters:dict];
}

@end
