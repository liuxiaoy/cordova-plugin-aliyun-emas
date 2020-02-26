var exec = require('cordova/exec');

var AliyunEMAS = {

    //////////////// 初始化EMAS ////////////////////
    // --------------------------------------------
    /**
     * @brief 初始化准备数据
     * @details 优先调用，否则可能会出现意想不到的bug
     */
    registerData: function (appVersion, channel, nick, success, error) {
        if (!appVersion || !channel || !nick) {
            console.error('参数不能为空');
            return error('appVersion, channel, nick 不能为空');
        }
        exec(success, error, 'AliyunEMAS', 'registerData', [appVersion, channel, nick]);
    },

    /**
     * @brief 性能监控初始化接口（自动读取appKey、appSecret）
     * @details 性能监控初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
     */
    initAlicloudAPM: function () {
        exec(null, null, 'AliyunEMAS', 'initAlicloudAPM', null);
    },

    /**
     * @brief 远程日志初始化接口（自动读取appKey、appSecret）
     * @details 远程日志初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
     */
    initAlicloudTlog: function () {
        exec(null, null, 'AliyunEMAS', 'initAlicloudTlog', null);
    },

    /**
     * @brief 崩溃分析始化接口（自动读取appKey、appSecret）
     * @details 崩溃分析初始化接口，appKey、appSecret会从AliyunEmasServices-Info.plist自动读取
     */
    initAlicloudCrash: function () {
        exec(null, null, 'AliyunEMAS', 'initAlicloudCrash', null);
    },

    /**
     * @brief 启动AppMonitor服务
     * @details 启动AppMonitor服务，可包括崩溃分析、远程日志、性能监控
     */
    start: function () {
        exec(null, null, 'AliyunEMAS', 'start', null);
    },

    /**
     @brief 自动启动阿里云服务：<性能分析&远程日志&崩溃分析>
     自动读取appKey、appSecret
     只需单独集成此api即可
     启动服务需在config.xml中配置，具体参照文档说明
     函数会返回失败信息，成功无返回
     */
    autoStartAliyunAnalyticsWithArgs: function (appVersion, channel, nick, success, error) {
        if (!appVersion || !channel || !nick) {
            console.error('参数不能为空');
            return error('appVersion, channel, nick 不能为空');
        }
        exec(success, error, 'AliyunEMAS', 'autoStartAliyunAnalyticsWithArgs', [appVersion, channel, nick]);
    },

    //////////////// 远程日志 log //////////////////
    // --------------------------------------------

    error: function (title, msg) {
        if (!title || !msg || title.length === 0 || msg.length === 0) {
            console.log('参数错误');
            return;
        }
        const arr = [title, msg];
        exec(null, null, 'AliyunEMAS', 'error', arr);
    },

    warn: function (title, msg) {
        if (!title || !msg || title.length === 0 || msg.length === 0) {
            console.log('参数错误');
            return;
        }
        const arr = [title, msg];
        exec(null, null, 'AliyunEMAS', 'warn', arr);
    },
    debug: function (title, msg) {
        if (!title || !msg || title.length === 0 || msg.length === 0) {
            console.log('参数错误');
            return;
        }
        const arr = [title, msg];
        exec(null, null, 'AliyunEMAS', 'debug', arr);
    },
    info: function (title, msg) {
        if (!title || !msg || title.length === 0 || msg.length === 0) {
            console.log('参数错误');
            return;
        }
        const arr = [title, msg];
        exec(null, null, 'AliyunEMAS', 'info', arr);
    },

    //////////////// 移动数据分析 ////////////////////
    // --------------------------------------------

    /**
     @brief 初始化移动数据分析（自动）
     */
    autoInitManSdk: function () {
        exec(null, null, 'AliyunEMAS', 'autoInitManSdk', null);
    },

    /**
     @brief 登录会员
     功能: 获取登录会员，然后会给每条日志添加登录会员字段
     调用时机: 登录时调用
     备注: 阿里云 平台上的登录会员 UV 指标依赖该接口
     @param userAccount 用户昵称
     @param userId 用户id
     */
    userLogin: function (userAccount, userId) {
        if (!userAccount || !userId || userAccount.length === 0 || userId.length === 0) {
            console.error('参数不能为空');
            return;
        }
        exec(null, null, 'AliyunEMAS', 'userLogin', [userAccount, userId]);
    },

    /**
     @brief 注册会员
     功能: 产生一条注册会员事件日志
     调用时机: 注册时调用
     备注: 阿里云 平台上注册会员指标依赖该接口
     @param userId 用户id
     */
    userRegister: function (userId) {
        if (!userId || userId.length === 0) {
            console.error('参数不能为空');
            return;
        }
        exec(null, null, 'AliyunEMAS', 'userRegister', [userId]);
    },

    /**
     @brief 自定义事件
     @param eventLabel 设置自定义事件标签
     @param pageName 设置自定义事件页面名称
     @param duration 设置自定义事件持续时间 单位（ms）
     @param args 设置自定义事件扩展参数 格式：{key-value,...} 可为空
     */
    customEventBuilder: function (eventLabel,pageName,duration,args={}) {
        if (!eventLabel || !pageName) {
            console.error('参数不能为空');
            return;
        }
        exec(null, null, 'AliyunEMAS', 'customEventBuilder', [eventLabel,pageName,duration,args]);
    },
};

module.exports = AliyunEMAS;
