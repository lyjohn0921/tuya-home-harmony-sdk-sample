import {
  IPCLog,
  ThingCameraErrorCode,
  ThingCameraPlayBackBean,
  ThingCameraTimePieceBean,
  ThingIPCSdk
} from '@thingsmart/ipcsdkhar';
import { XComponentContext } from '@thingsmart/thingvideorenderersdk';
import { ArkTSUtils } from '@kit.ArkTS';
import { ThingCameraFinishableCallback } from '@thingsmart/ipcsdkhar/src/main/ets/listener/ThingCameraFinishableCallback';
import { ThingCameraCallback } from '@thingsmart/ipcsdkhar/src/main/ets/listener/ThingCameraCallback';

@Entry
@Component
struct PlayBackIndex {
  logTag: string = "PlayBack";
  cameraP2P = ThingIPCSdk.getCameraP2P(""); // SD 卡回放设备
  private xComponentContext0: XComponentContext | undefined = undefined;
  mFirstThingCameraTimePieceBean?: ThingCameraTimePieceBean = undefined

  aboutToAppear(): void {
    IPCLog.d(this.logTag, "aboutToAppear");
  }

  aboutToDisappear(): void {
    IPCLog.d(this.logTag, "aboutToDisappear");
    this.disconnect();
  }

  onPageShow(): void {
    IPCLog.d(this.logTag, "onPageShow");
    this.startPlayback();
  }

  onPageHide(): void {
    IPCLog.d(this.logTag, "onPageHide");
    this.stopPlayback();
  }

  startPlayback() {
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
  }

  stopPlayback() {
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
  }

  disconnect() {
    if (this.cameraP2P !== undefined) {
      IPCLog.d(this.logTag, "断开 SD 卡视频连接");

      this.cameraP2P.disconnect(true).then((result) => {
        if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
          IPCLog.d(this.logTag, "断开 SD 卡视频连接 成功");
        } else {
          IPCLog.d(this.logTag, "断开 SD 卡视频连接 失败 " + result.errorCodeNumber);
        }
      });
    } else {
      IPCLog.d(this.logTag, "断开 SD 卡视频连接失败，this.cameraP2P === undefined");
    }
  }

  build() {
    Column({ space: 20 }) {
      Row() {
        Column() {
          XComponent({
            id: 'xcomponentId0',
            type: XComponentType.SURFACE,
            libraryname: 'thingvideorenderersdk'
          }).onLoad((xComponentContext) => {
            this.xComponentContext0 = xComponentContext as XComponentContext;
            this.cameraP2P.bindXComponentContext(this.xComponentContext0);
          }).onDestroy(() => {
            console.log('onDestroy');
          }).id("xcomponent")
        }.width('100%')
        .onClick(() => {
          // let width = 320;
          // let height = 240;
          // let y = new ArrayBuffer(width * height);
          // let u = new ArrayBuffer(width * height / 4);
          // let v = new ArrayBuffer(width * height / 4);
          // let hasChangeColor: boolean = false;
          // this.xComponentContext0?.drawYUV(y,u,v,width,height);
        })
        .margin({
          top: 10,
          left: 12,
          right: 12
        })
      }.height('50%')

      Button('查询SD卡录像日期')
        .width('50%')
        .onClick(async () => {

          IPCLog.d(this.logTag, "查询SD卡录像日期");

          let connectResult = await this.cameraP2P.connectWrapper();

          if (connectResult.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
            IPCLog.d(this.logTag, "connect 成功 ");
            this.cameraP2P.queryRecordDaysByMonth(5, 2025).then((result) => {
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
        })

      Button('测试 SD 卡查询')
        .width('50%')
        .onClick(async () => {

          IPCLog.d(this.logTag, "测试 SD 卡查询");

          let connectResult = await this.cameraP2P.connectWrapper();

          if (connectResult.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
            IPCLog.d(this.logTag, "connect 成功 ");
            this.cameraP2P.queryRecordTimeSliceByDay(7, 5, 2025).then((result) => {
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
        })

      Button('播放 SD 卡视频')
        .width('50%')
        .onClick(async () => {
          this.startPlayback();
        })

      Button('暂停 SD 卡视频')
        .width('50%')
        .onClick(async () => {
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
        })

      Button('恢复 SD 卡视频')
        .width('50%')
        .onClick(async () => {
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
        })

      Button('停止 SD 卡视频')
        .width('50%')
        .onClick(async () => {
          this.stopPlayback();
        })

      Button('静音')
        .width('50%')
        .onClick(async () => {
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
        })
    }
  }
}