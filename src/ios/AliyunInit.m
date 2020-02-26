//
//  AliyunInit.m
//  cordova-demo
//
//  Created by 袁训锐 on 2020/2/20.
//

#import "AliyunInit.h"
// 启动服务
#import <AlicloudHAUtil/AlicloudHAProvider.h>
// 崩溃分析
#import <AlicloudCrash/AlicloudCrashProvider.h>
// 性能分析
#import <AlicloudAPM/AlicloudAPMProvider.h>
// 远程日志
#import <AlicloudTLog/AlicloudTlogProvider.h>

#import "AliyunMobileAnalytics.h"

typedef struct {
    NSString *appVersion; //
    NSString *channel;
    NSString *nick;
} XRAliEmasParameter;

NSString *const ROOTCONFIGKEY = @"config";
NSString *const PLUGIN_PARAMETER_KEY_APPVERSION = @"appVersion";
NSString *const PLUGIN_PARAMETER_KEY_CHANNEL = @"channel";
NSString *const PLUGIN_PARAMETER_KEY_NICK = @"nick";

#define XRLog(s, ...) NSLog(@"<%s>%@", __FUNCTION__, [NSString stringWithFormat:(s), ## __VA_ARGS__]);
@interface AliyunInit ()
@property (nonatomic, assign) XRAliEmasParameter model;
@property (nonatomic, strong) NSMutableDictionary *parameter;
@end
static AliyunInit *shareInstance = nil;
@implementation AliyunInit

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[super alloc]init];
    });
    return shareInstance;
}

#pragma mark - 自定义
/**
 @brief 参数注册
 */
- (void)registerParameterWithAppVersion:(NSString *)appVersion channel:(NSString *)channel nick:(NSString *)nick {
    if (appVersion && channel && nick) {
        _parameter = [[NSMutableDictionary alloc]initWithObjectsAndKeys:
                      appVersion, PLUGIN_PARAMETER_KEY_APPVERSION, channel, PLUGIN_PARAMETER_KEY_CHANNEL,
                      nick, PLUGIN_PARAMETER_KEY_NICK, nil];
    }
}

- (NSDictionary *)aliyunInfo {
    if (!_aliyunInfo) {
        // 读取AliyunEmasServices-Info.plist
        NSString *path = [[NSBundle mainBundle]pathForResource:@"AliyunEmasServices-Info.plist" ofType:nil];
        _aliyunInfo = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _aliyunInfo;
}

#pragma mark - API

/*!
* @brief 性能监控初始化接口（自动读取appKey、appSecret）
* @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudAPM {
    NSDictionary *parameter = [AliyunInit shareInstance].parameter;
    NSLog(@"%s  parameter = %@", __FUNCTION__, parameter);
    [[AlicloudAPMProvider alloc] autoInitWithAppVersion:[parameter objectForKey:PLUGIN_PARAMETER_KEY_APPVERSION] channel:[parameter objectForKey:PLUGIN_PARAMETER_KEY_CHANNEL] nick:[parameter objectForKey:PLUGIN_PARAMETER_KEY_NICK]];
}

/*!
* @brief 远程日志初始化接口（自动读取appKey、appSecret）
* @details 远程日志初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudTlog {
    NSDictionary *parameter = [AliyunInit shareInstance].parameter;
    NSLog(@"%s  parameter = %@", __FUNCTION__, parameter);
    [[AlicloudTlogProvider alloc] autoInitWithAppVersion:[parameter objectForKey:PLUGIN_PARAMETER_KEY_APPVERSION] channel:[parameter objectForKey:PLUGIN_PARAMETER_KEY_CHANNEL] nick:[parameter objectForKey:PLUGIN_PARAMETER_KEY_NICK]];
}

/*!
* @brief 崩溃分析始化接口（自动读取appKey、appSecret）
* @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
*/
- (void)initAlicloudCrash {
    NSDictionary *parameter = [AliyunInit shareInstance].parameter;
    NSLog(@"%s  parameter = %@", __FUNCTION__, parameter);
    [[AlicloudCrashProvider alloc] autoInitWithAppVersion:[parameter objectForKey:PLUGIN_PARAMETER_KEY_APPVERSION] channel:[parameter objectForKey:PLUGIN_PARAMETER_KEY_CHANNEL] nick:[parameter objectForKey:PLUGIN_PARAMETER_KEY_NICK]];
}

/*!
* @brief 启动AppMonitor服务
* @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
*/
- (void)start {
    NSLog(@"%s", __FUNCTION__);
    [AlicloudHAProvider start];
}

#pragma mark 自动启动服务
/**
@brief 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
自动读取appKey、appSecret
只需单独集成此api即可
启动服务需在config.xml中配置，具体参照文档说明
函数会返回失败信息，成功无返回
*/
- (void)autoStartAliyunAnalyticsWithAppVersion:(NSString *)appVersion channel:(NSString *)channel nick:(NSString *)nick resultBlock:(void (^)(BOOL result, NSString *))block {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);

    // 性能分析
    BOOL xn = [[self.aliyunInfo objectForKey:@"AliyunXNServe"]isEqualToString:@"true"] ? YES : NO;
    // 崩溃分析
    BOOL crash = [[self.aliyunInfo objectForKey:@"AliyunCrashServe"]isEqualToString:@"true"] ? YES : NO;
    // 远程日志
    BOOL tlog = [[self.aliyunInfo objectForKey:@"AliyunTlogServe"]isEqualToString:@"true"] ? YES : NO;
    // debug开关
    BOOL debug = [[self.aliyunInfo objectForKey:@"AliyunOpenDebug"]isEqualToString:@"true"] ? YES : NO;
    // 移动数据分析
    BOOL mobileAnalytics = [[self.aliyunInfo objectForKey:@"AliyunMobileAnalyticsServe"]isEqualToString:@"true"] ? YES : NO;

    if (!(xn || crash || tlog || mobileAnalytics)) {
        block(NO, [NSString stringWithFormat:@"%s %@", __FUNCTION__, @"你没有开启任何服务，如有需要，请在config.xml文件中注册^_^"]);
        return;
    }
    dispatch_group_async(group, queue, ^{
        if (xn) {
            [[AlicloudAPMProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
            XRLog(@"-- xn");
        }
        if (tlog) {
            [[AlicloudTlogProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
            XRLog(@"-- tlog");
        }
        if (crash) {
            [[AlicloudCrashProvider alloc] autoInitWithAppVersion:appVersion channel:channel nick:nick];
            XRLog(@"-- crash");
        }
        if (mobileAnalytics) {
            [[AliyunMobileAnalytics shareInstance]autoInitManSdkWithDebug:debug];
            XRLog(@"-- mobile analytics");
        }
    });

    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            XRLog(@"-- start");
            [AlicloudHAProvider start];
            block(YES, @"success");
        });
    });
}

@end
