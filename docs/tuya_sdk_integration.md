# 快速集成  
## 准备工作  
使用 SDK 前需要先申请 AppKey 和 AppSecret。参考[配置获取](https://developer.tuya.com/cn/docs/app-development/integrated?id=Ka69nt96cw0uj#title-6-%E7%AC%AC%E5%9B%9B%E6%AD%A5%EF%BC%9A%E8%AE%BE%E7%BD%AE%20Appkey%E3%80%81AppSecret%20%E5%92%8C%E8%AF%81%E4%B9%A6%E7%AD%BE%E5%90%8D)

## 配置 App 信息  
请联系涂鸦鸿蒙研发团队获取密钥和 bundle 信息

## SDK 依赖  
参考 [IPC SDK 依赖](./tuya_ipc_sdk.md)

## SDK 初始化  
``` javascript
let appKey : string= '';
let appSecret : string = '';

PersistentStorage.persistProp('countryCode', '86')
PersistentStorage.persistProp('regionCode', 'CN')
TSmartSDK.startWithAppKey(appKey, appSecret, this.context, "your bundle name")

ThingIPCSdk.init(this.context);
```