//
//  AliyunMobileAnalytics.m
//  cordova_demo
//
//  Created by 袁训锐 on 2020/4/9.
//

#import "AliyunMobileAnalytics.h"
#import <AlicloudMobileAnalitics/ALBBMAN.h>

static AliyunMobileAnalytics *shareInstance = nil;
@implementation AliyunMobileAnalytics

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[super alloc]init];
    });
    return shareInstance;
}

/**
 @brief 初始化（自动）
 @param debug debug开关
 */
- (void)autoInitManSdkWithDebug:(BOOL)debug {
    // 获取MAN服务
    ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
    // 打开调试日志，线上版本建议关闭
    if (debug) {
        [man turnOnDebug];
    }
    // 初始化MAN，无需输入配置信息
    [man autoInit];
    //appVersion默认从Info.list的CFBundleShortVersionString字段获取，如果没有指定，可在此调用setAppversion设定
    // 如果上述两个地方都没有设定，appVersion为"-"
//    [man setAppVersion:@"2.3.1"];
    //设置渠道（用以标记该app的分发渠道名称），如果不关心可以不设置即不调用该接口，渠道设置将影响控制台【渠道分析】栏目的报表展现。
//    [man setChannel:@"50"];
}

/**
 @brief 登录会员
 功能: 获取登录会员，然后会给每条日志添加登录会员字段
 调用时机: 登录时调用
 备注: 阿里云 平台上的登录会员 UV 指标依赖该接口
 @param pNick 用户昵称
 @param pUserId 用户id
 */
- (void)updateUserAccount:(NSString *)pNick userid:(NSString *)pUserId {
    ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
    [man updateUserAccount:pNick userid:pUserId];
}

/**
 @brief 注册会员
 功能: 产生一条注册会员事件日志
 调用时机: 注册时调用
 备注: 阿里云 平台上注册会员指标依赖该接口
 */
- (void)userRegister:(NSString *)pUsernick {
    ALBBMANAnalytics *man = [ALBBMANAnalytics getInstance];
    [man userRegister:pUsernick];
}

/**
@brief 自定义事件
@param eventLabel 设置自定义事件标签
@param eventPage 设置自定义事件页面名称
@param duration 设置自定义事件持续时间
@param parameters 设置自定义事件扩展参数
*/
- (void)customEventBuilderWithEventLabel:(NSString *)eventLabel eventPage:(NSString *)eventPage duration:(long long)duration parameters:(NSDictionary *)parameters {
    ALBBMANCustomHitBuilder *customBuilder = [[ALBBMANCustomHitBuilder alloc] init];
    // 设置自定义事件标签
    [customBuilder setEventLabel:eventLabel];
    // 设置自定义事件页面名称
    [customBuilder setEventPage:eventPage];
    // 设置自定义事件持续时间
    [customBuilder setDurationOnEvent:duration];
    // 设置自定义事件扩展参数
    if (parameters && ![parameters isKindOfClass:[NSNull class]]) {
        NSArray *keys = [parameters allKeys];
        for (NSString *key in keys) {
            NSString *value = parameters[key];
            [customBuilder setProperty:key value:value];
        }
    }
    ALBBMANTracker *traker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
    // 组装日志并发送
    NSDictionary *dic = [customBuilder build];
    [traker send:dic];
}

@end
