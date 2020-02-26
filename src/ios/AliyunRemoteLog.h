//
//  AliyunRemoteLog.h
//  cordova_demo
//
//  Created by 袁训锐 on 2020/2/28.
//

//#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AliyunRemoteLog : NSObject

+ (instancetype)shareInstance;

/// 日志打印
/// @param title 标题
/// @param message 信息
- (void)errorWithTitle:(NSString *)title message:(NSString *)message;
- (void)warnWithTitle:(NSString *)title message:(NSString *)message;
- (void)debugWithTitle:(NSString *)title message:(NSString *)message;
- (void)infoWithTitle:(NSString *)title message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
