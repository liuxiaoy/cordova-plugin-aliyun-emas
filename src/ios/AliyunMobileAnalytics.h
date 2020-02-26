//
//  AliyunMobileAnalytics.h
//  cordova_demo
//
//  Created by 袁训锐 on 2020/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliyunMobileAnalytics : NSObject

+ (instancetype)shareInstance;
/**
 @brief 初始化（自动）
 @param debug debug开关
 */
- (void)autoInitManSdkWithDebug:(BOOL)debug;
/**
 @brief 登录会员
 功能: 获取登录会员，然后会给每条日志添加登录会员字段
 调用时机: 登录时调用
 备注: 阿里云 平台上的登录会员 UV 指标依赖该接口
 @param pNick 用户昵称
 @param pUserId 用户id
 */
- (void)updateUserAccount:(NSString *)pNick userid:(NSString *)pUserId;
/**
 @brief 注册会员
 功能: 产生一条注册会员事件日志
 调用时机: 注册时调用
 备注: 阿里云 平台上注册会员指标依赖该接口
 */
- (void)userRegister:(NSString *)pUsernick;

/**
 @brief 自定义事件
 @param eventLabel 设置自定义事件标签
 @param eventPage 设置自定义事件页面名称
 @param duration 设置自定义事件持续时间
 @param parameters 设置自定义事件扩展参数
 */
- (void)customEventBuilderWithEventLabel:(NSString *)eventLabel eventPage:(NSString *)eventPage duration:(long long)duration parameters:(NSDictionary *)parameters;
@end

NS_ASSUME_NONNULL_END
