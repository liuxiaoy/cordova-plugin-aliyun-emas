//
//  AliyunEMAS.h
//  demo1
//
//  Created by 袁训锐 on 2020/4/8.
//  Copyright © 2020 XR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliyunEMAS : CDVPlugin

#pragma mark - 初始化
/*!
* @brief 初始化准备数据
* @details 优先调用，否则可能会出现意想不到的bug
*/
- (void)registerData:(CDVInvokedUrlCommand *)command;

#pragma mark - 性能分析、崩溃分析、远程日志

/*!
* @brief 性能监控初始化接口（自动读取appKey、appSecret）
* @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudAPM:(CDVInvokedUrlCommand *)command;

/*!
* @brief 远程日志初始化接口（自动读取appKey、appSecret）
* @details 远程日志初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudTlog:(CDVInvokedUrlCommand *)command;

/*!
* @brief 崩溃分析始化接口（自动读取appKey、appSecret）
* @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudCrash:(CDVInvokedUrlCommand *)command;

/*!
* @brief 启动AppMonitor服务
* @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
*/
- (void)start:(CDVInvokedUrlCommand *)command;

#pragma mark 自动启动服务
/**
 @brief 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
 自动读取appKey、appSecret
 只需单独集成此api即可
 启动服务需在config.xml中配置，具体参照文档说明
 函数会返回失败信息，成功无返回
 */
- (void)autoStartAliyunAnalyticsWithArgs:(CDVInvokedUrlCommand *)command;

#pragma mark - 远程日志

/// 错误
- (void)error:(CDVInvokedUrlCommand *)command;

/// 警告
- (void)warn:(CDVInvokedUrlCommand *)command;

/// 默认
- (void)info:(CDVInvokedUrlCommand *)command;

/// debug
- (void)debug:(CDVInvokedUrlCommand *)command;

#pragma mark - 移动数据分析
/**
 @brief 初始化（自动）
 */
- (void)autoInitManSdk:(CDVInvokedUrlCommand *)command;
/**
 @brief 登录会员
 功能: 获取登录会员，然后会给每条日志添加登录会员字段
 调用时机: 登录时调用
 */
- (void)userLogin:(CDVInvokedUrlCommand *)command;
/**
 @brief 注册会员
 功能: 产生一条注册会员事件日志
 调用时机: 注册时调用
 备注: 阿里云 平台上注册会员指标依赖该接口
 */
- (void)userRegister:(CDVInvokedUrlCommand *)command;

/**
 @brief 自定义事件
 */
- (void)customEventBuilder:(CDVInvokedUrlCommand *)command;
@end

NS_ASSUME_NONNULL_END
