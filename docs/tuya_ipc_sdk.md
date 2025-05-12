# IPC SDK API  
## SDK  依赖
ipcsdk 的使用，依赖登录、设备和网络模块。请在根目录的 oh-package.json5 文件中添加以下依赖：
```json5
"overrides": {
    "@thingsmart/userlib": "file:./entry/src/main/libs/userlib-1.0.25.har",
    "@thingsmart/homelib": "file:./entry/src/main/libs/homelib-0.0.35.har",
    "@thingsmart/activatorlib": "file:./entry/src/main/libs/activatorlib-1.0.13.har",
    "@thingsmart/activator": "file:./entry/src/main/libs/activator-1.0.22.har",
    "@thingsmart/device": "file:./entry/src/main/libs/device-1.0.30.har",
    "@thingsmart/ipcsdk": "file:./entry/src/main/libs/ipcsdkhar-1.0.21.har",
    "@thingsmart/thingp2psdkhar": "file:./entry/src/main/libs/thingp2psdkhar-1.0.10.har",
    "@thingsmart/thingvideorenderersdk": "file:./entry/src/main/libs/thingvideorenderersdk-1.0.1.har",
    "@thingsmart/thingcamerasdk": "file:./entry/src/main/libs/thingcamerasdk-1.0.24.har",
    "@thingsmart/thingavloggersdk": "file:./entry/src/main/libs/thingavloggersdk-1.0.3.har",
    "@thingsmart/security": "file:./entry/src/main/libs/security-2.0.1.har",
    "@thingsmart/channel": "file:./entry/src/main/libs/channel-1.0.26.har",
    "@thingsmart/util": "file:./entry/src/main/libs/util-1.0.8.har",
    "@thingsmart/securitykv": "file:./entry/src/main/libs/securitykv-1.0.4.har",
    "@thingsmart/thinglogmodule": "file:./entry/src/main/libs/thinglogmodule-1.0.1.har"
}
```
entry 模块 oh-package.json5 文件中添加如下依赖（不需要版本号）。
```json5
"dependencies": {
    "@thingsmart/userlib": "",
    "@thingsmart/homelib": "",
    "@thingsmart/activatorlib": "",
    "@thingsmart/activator": "",
    "@thingsmart/device": "",
    "@thingsmart/ipcsdkhar": "",
    "@thingsmart/thingp2psdkhar": "",
    "@thingsmart/thingvideorenderersdk": "",
    "@thingsmart/thingcamerasdk": "",
    "@thingsmart/thingavloggersdk": "",
    "@thingsmart/security": "",
    "@thingsmart/channel": "",
    "@thingsmart/util": "",
    "@thingsmart/securitykv": "",
    "@thingsmart/thinglogmodule": "",
  }
```
entry 模块 build-profile.json5 文件中 arkOptions 层级下添加如下配置。
```json5
"runtimeOnly": {
    "packages": [
        "@thingsmart/userlib",
        "@thingsmart/homelib",
        "@thingsmart/activatorlib",
        "@thingsmart/activator",
        "@thingsmart/device",
        "@thingsmart/ipcsdkhar",
        "@thingsmart/thingp2psdkhar",
        "@thingsmart/thingvideorenderersdk",
        "@thingsmart/thingcamerasdk",
        "@thingsmart/thingavloggersdk",
        "@thingsmart/security",
        "@thingsmart/channel",
        "@thingsmart/util",
        "@thingsmart/securitykv",
        "@thingsmart/thinglogmodule"
    ]
},
```
## 初始化
### SDK 初始化
ipcsdk 初始化可以尽量提前，在程序启动时执行

``` javascript
ThingIPCSdk.init(this.context);
```
### p2p 初始化
p2p 初始化，依赖登录完成和 mqtt的初始化完成。
``` javascript
// 登录成功
IPCLog.d(this.logTag, "登录成功:" + resp);
TSmartMqtt.initClient(TSmartUser.getDomain()?.mobileMqttsUrl ?? '',
            (TSmartUser.getPartnerIdentity() ?? '') + (TSmartUser.getSid() ?? ''), TSmartUser.getSid() ?? '',
            (await MD5.digest(TSmartUser.getEcode())).substring(8, 24), TSmartDeviceUtil.getInstance());

TSmartMqtt.connect().then((result) => {
           IPCLog.d(this.logTag, 'TSmartMqtt.connect')
            });

ThingIPCSdk.getP2P().initP2P(TSmartUser.getUid() as string);
```

### 播放窗口设置

``` javascript
cameraP2P = ThingIPCSdk.getCameraP2P("devid");

XComponent({id: 'xcomponentId0',type: XComponentType.SURFACE,
            libraryname: 'thingvideorenderersdk'
}).onLoad((xComponentContext) => {
    this.xComponentContext0 = xComponentContext as XComponentContext;
    this.cameraP2P.bindXComponentContext(this.xComponentContext0);
}).onDestroy(() => {
    console.log('onDestroy');
}).id("xcomponent")
```

## 直播

### 连接拉流
``` javascript
IPCLog.d(this.logTag, 'ipc connect start')

if (TSmartUser.getUid() !== undefined) {
    this.cameraP2P.connectWrapper().then((result) => {
        if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
            IPCLog.d(this.logTag, 'ipc connect success')
            let previewCallBack: ThingCameraCallback = {
                    onResponse: (reason: string, errCode: number) => {
                      if (errCode >= 0) {
                        IPCLog.d(this.logTag, 'ipc preview success')
                      } else {
                        IPCLog.e(this.logTag, 'ipc preview fail')
                      }
                      return 0;
                    }
                  }
            this.cameraP2P.startPreview(previewCallBack).then((result) => {
                    if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                      IPCLog.d(this.logTag, 'ipc preview return success')
                    } else {
                      IPCLog.e(this.logTag, 'ipc preview fail')
                    }
                  }).catch((e: TSmartAtopRequestError) => {
                    IPCLog.e(this.logTag, 'ipc preview fail' + e)
                  });
                } else {
                  IPCLog.e(this.logTag, 'ipc connect fail')
                }
              }).catch((e: TSmartAtopRequestError) => {
                IPCLog.e(this.logTag, 'ipc connect fail' + e)
              })
            } else {
              IPCLog.e(this.logTag, 'uid is undefined')
            }
    IPCLog.d(this.logTag, 'ipc connect end')
```

### 断开直播

``` javascript
IPCLog.d(this.logTag, 'ipc disconnect start')
    let stopPreviewCallBack: ThingCameraCallback = {
              onResponse(reason: string, errCode: number): number {
                IPCLog.d(this.logTag, 'ipc disconnect callback')
                return 0;
              }
    };
    this.cameraP2P.stopPreview(stopPreviewCallBack).then((result) => {
        if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
            IPCLog.d(this.logTag, 'ipc stopPreview return success')
        } else {
                IPCLog.e(this.logTag, 'ipc stopPreview fail')
        }
    }).catch((e: TSmartAtopRequestError) => {
        IPCLog.e(this.logTag, 'ipc preview fail' + e)
    });

    this.cameraP2P.disconnect(true).then((result) => {
        if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
            IPCLog.d(this.logTag, 'ipc disconnect return success')
        } else {
            IPCLog.e(this.logTag, 'ipc disconnect fail')
        }
    }).catch((e: TSmartAtopRequestError) => {
        IPCLog.e(this.logTag, 'ipc preview fail' + e)
    });
```

## SD 卡回放
### 按月查询SD 卡回放片段日期
``` javascript
let connectResult = await this.cameraP2P.connectWrapper();

          if (connectResult.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
            IPCLog.d(this.logTag, "connect 成功 ");
            this.cameraP2P.queryRecordDaysByMonth(3, 2025).then((result) => {
              if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS && result.data !== undefined) {
                let playbackDays = JSON.parse(result.data) as Record<string, Array<string>>;
                IPCLog.d(this.logTag, "queryRecordDaysByMonth 成功" + playbackDays["DataDays"].toString());
              } else {
                IPCLog.e(this.logTag, "queryRecordDaysByMonth 失败 " + result.errorCodeNumber);
              }
            })
          } else {
            IPCLog.d(this.logTag, "connect 失败 ");
          }
```

### SD 卡回放查询视频片段
``` javascript
let connectResult = await this.cameraP2P.connectWrapper();

          if (connectResult.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
            IPCLog.d(this.logTag, "connect 成功 ");
            this.cameraP2P.queryRecordTimeSliceByDay(26, 3, 2025).then((result) => {
              if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS && result.data !== undefined) {
                IPCLog.d(this.logTag, "queryRecordTimeSliceByDay 成功");
                let playbackBean = JSON.parse(result.data)  as ThingCameraPlayBackBean;
                // let playbackBean = ArkTSUtils.ASON.parse(json) as ThingCameraPlayBackBean;
                IPCLog.d(this.logTag, "queryRecordTimeSliceByDay 成功 " + playbackBean.items?.length);
                if (playbackBean.items !== undefined && playbackBean.items?.length > 0) {
                  this.mFirstThingCameraTimePieceBean = playbackBean.items[0];
                }
              } else {
                IPCLog.e(this.logTag, "queryRecordTimeSliceByDay 失败 " + result.errorCodeNumber);
              }
            })
          } else {
            IPCLog.d(this.logTag, "connect 失败 ");
          }
```

### SD 卡回放播放
``` javascript
if (this.mFirstThingCameraTimePieceBean !== undefined) {
            IPCLog.d(this.logTag, "播放 SD 卡视频");
            let startTime: number = this.mFirstThingCameraTimePieceBean.startTime ?? 0;
            let endTime = this.mFirstThingCameraTimePieceBean.endTime ?? 0;
            let playTime = startTime;

            let callback: ThingCameraFinishableCallback<string, string> = {
              onResponse: (reason: string, errCode: number): void => {
                IPCLog.d(this.logTag, "播放 SD 卡视频  onResponse " + errCode);
              },
              onFinished: (data: string, errCode: number): void => {
                IPCLog.d(this.logTag, "播放 SD 卡视频  onFinished " + errCode);
              },
              onEvent: (eventType: number, info1: number, info2: number, errInfo: string): void => {
                IPCLog.d(this.logTag, "播放 SD 卡视频  onEvent " + info1);
              }
            }
            this.cameraP2P.startPlayBack(startTime, endTime, playTime, callback);
          } else {
            IPCLog.d(this.logTag, "播放 SD 卡视频失败，没有片段信息");
          }
```

### SD 卡暂停回放
``` javascript
if (this.cameraP2P !== undefined) {
            IPCLog.d(this.logTag, "暂停 SD 卡视频");
            this.cameraP2P.pausePlayBack().then((result) => {
              if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                IPCLog.d(this.logTag, "暂停 SD 卡视频 成功");
              } else {
                IPCLog.d(this.logTag, "暂停 SD 卡视频 失败");
              }
            });
          } else {
            IPCLog.d(this.logTag, "暂停 SD 卡视频失败，this.cameraP2P === undefined");
          }
```

### SD 卡恢复回放
``` javascript
if (this.cameraP2P !== undefined) {
            IPCLog.d(this.logTag, "恢复 SD 卡视频");
            this.cameraP2P.resumePlayBack().then((result) => {
              if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                IPCLog.d(this.logTag, "恢复 SD 卡视频 成功");
              } else {
                IPCLog.d(this.logTag, "恢复 SD 卡视频 失败");
              }
            });
          } else {
            IPCLog.d(this.logTag, "恢复 SD 卡视频失败，this.cameraP2P === undefined");
          }
```

### SD 卡停止回放
``` javascript
if (this.cameraP2P !== undefined) {
            IPCLog.d(this.logTag, "停止 SD 卡视频");

            this.cameraP2P.stopPlayBack().then((result) => {
              if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                IPCLog.d(this.logTag, "停止 SD 卡视频 成功");
              } else {
                IPCLog.d(this.logTag, "停止 SD 卡视频 失败 " + result.errorCodeNumber);
              }
            });
          } else {
            IPCLog.d(this.logTag, "停止 SD 卡视频失败，this.cameraP2P === undefined");
          }
```

### 更新静音状态
``` javascript
if (this.cameraP2P !== undefined) {
            IPCLog.d(this.logTag, "静音");

            this.cameraP2P.setMute(1).then((result) => {
              if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                IPCLog.d(this.logTag, "静音 成功");
              } else {
                IPCLog.d(this.logTag, "静音 失败 " + result.errorCodeNumber);
              }
            });
          } else {
            IPCLog.d(this.logTag, "静音失败，this.cameraP2P === undefined");
          }
```

### 获取静音状态
``` javascript
if (this.cameraP2P !== undefined) {
            this.cameraP2P.getMute()
          } else {
            IPCLog.d(this.logTag, "获取静音状态失败，this.cameraP2P === undefined");
          }
```
## 音视频功能
### 截图
``` javascript
IPCLog.d(this.logTag, "截图");
let snapshotParams: ThingCameraSnapshotParams = {
 dir: getContext(this).filesDir,
 fileName: Date.now().toString() + ".jpg",
 rotate: 0,
 saveToSysTem: false
};
this.cameraP2P.snapshot(snapshotParams).then((result) => {
 if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
  IPCLog.d(this.logTag, "截图 成功");
 } else {
  IPCLog.d(this.logTag, "截图 失败 " + result.errorCodeNumber);
  }
 });
```

### 录制
``` javascript
IPCLog.d(this.logTag, "开始录制");
let recordParams: ThingCameraSnapshotParams = {
  dir: getContext(this).filesDir,
  fileName: Date.now().toString() + ".mp4",
  rotate: 0,
  saveToSysTem: false
};
this.cameraP2P.startRecordLocalMp4(recordParams).then((result) => {
  if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
    IPCLog.d(this.logTag, "开始录制 成功");
  } else {
    IPCLog.d(this.logTag, "开始录制 失败 " + result.errorCodeNumber);
  }
 });
 
IPCLog.d(this.logTag, "结束录制");
this.cameraP2P.stopRecordLocalMp4().then((result) => {
  if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
   IPCLog.d(this.logTag, "结束录制 成功");
 } else {
  IPCLog.d(this.logTag, "结束录制 失败 " + result.errorCodeNumber);
  }
});
```

### 清晰度
``` javascript
IPCLog.d(this.logTag, "获取清晰度");
              this.cameraP2P.getVideoClarity().then((result) => {
                if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                  this.clarity = result.data;
                  IPCLog.d(this.logTag, "获取清晰度 成功 " + result.data);
                } else {
                  IPCLog.d(this.logTag, "获取清晰度 失败 " + result.errorCodeNumber);
                }
              });

IPCLog.d(this.logTag, "设置清晰度");
              let clarity = 4;// 2 标清  4 高清
              this.cameraP2P.setVideoClarity(clarity).then((result) => {
                if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                  this.clarity = result.data;
                  IPCLog.d(this.logTag, "设置清晰度 成功 " + result.data);
                } else {
                  IPCLog.d(this.logTag, "设置清晰度 失败 " + result.errorCodeNumber);
                }
              });
```

### 设备能力
设备能力在 p2p 拉流后会进行缓存，所以至少保证拉流成功过，才能获取到设备能力。
``` javascript
IPCLog.d(this.logTag, "设备能力");
let cameraConfig = ThingIPCSdk.getCameraConfig(this.devId)
cameraConfig.getSupportPlaySpeedList();
```