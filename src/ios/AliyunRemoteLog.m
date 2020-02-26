//
//  AliyunRemoteLog.m
//  cordova_demo
//
//  Created by 袁训锐 on 2020/2/28.
//

#import "AliyunRemoteLog.h"
// 获取 远程日志
#import <TRemoteDebugger/TLogBiz.h>
#import <TRemoteDebugger/TLogFactory.h>

static AliyunRemoteLog *shareInstance = nil;

@implementation AliyunRemoteLog

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[super alloc]init];
    });
    return shareInstance;
}

- (TLogBiz *)getLogFactoryWithModuleName:(NSString *)name {
    TLogBiz *log = [TLogFactory createTLogForModuleName:name];
    return log;
}

- (void)errorWithTitle:(NSString *)title message:(NSString *)message {
    TLogBiz *log = [self getLogFactoryWithModuleName:title];
    [log error:message];
}

- (void)warnWithTitle:(NSString *)title message:(NSString *)message {
    TLogBiz *log = [self getLogFactoryWithModuleName:title];
    [log warn:message];
}

- (void)debugWithTitle:(NSString *)title message:(NSString *)message {
    TLogBiz *log = [self getLogFactoryWithModuleName:title];
    [log debug:message];
}

- (void)infoWithTitle:(NSString *)title message:(NSString *)message {
    TLogBiz *log = [self getLogFactoryWithModuleName:title];
    [log info:message];
}

@end
