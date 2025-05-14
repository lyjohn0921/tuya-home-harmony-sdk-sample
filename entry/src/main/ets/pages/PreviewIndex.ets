import {
  IPCLog,
  ThingCameraErrorCode,
  ThingCameraPlayBackBean,
  ThingCameraSnapshotParams,
  ThingCameraTimePieceBean,
  ThingIPCSdk
} from '@thingsmart/ipcsdkhar';
import { XComponentContext } from '@thingsmart/thingvideorenderersdk';
import { ArkTSUtils } from '@kit.ArkTS';
import { ThingCameraFinishableCallback } from '@thingsmart/ipcsdkhar/src/main/ets/listener/ThingCameraFinishableCallback';
import { ThingCameraCallback } from '@thingsmart/ipcsdkhar/src/main/ets/listener/ThingCameraCallback';
import { ThingCameraAudioFrame, ThingCameraInterface, ThingCameraVideoFrame } from '@thingsmart/thingcamerasdk';
import { OnP2PCameraListener } from '@thingsmart/ipcsdkhar/src/main/ets/listener/OnP2PCameraListener';
import { TSmartAtopRequestError } from '@thingsmart/channel';
import { TSmartUser } from '@thingsmart/userlib';
import { StringUtil } from './StringUtil';

@Entry
@Component
struct PreviewIndex {
  logTag: string = "Preview";
  localConfig = StringUtil.getAppConfig(getContext(this));
  devId : string = this.localConfig["test_dev_id"];
  cameraP2P = ThingIPCSdk.getCameraP2P(this.devId); //直播设备
  private xComponentContext0: XComponentContext | undefined = undefined;
  private thingCamera: ThingCameraInterface | undefined = undefined;
  onP2PCameraListener?: OnP2PCameraListener = undefined
  clarity?: number = undefined

  aboutToAppear(): void {
    IPCLog.d(this.logTag, "aboutToAppear");
  }

  aboutToDisappear(): void {
    IPCLog.d(this.logTag, "aboutToDisappear");
    this.disconnect();
  }

  onPageShow(): void {
    IPCLog.d(this.logTag, "onPageShow");
    this.startPreview();
  }

  onPageHide(): void {
    IPCLog.d(this.logTag, "onPageHide");
    this.stopPreview();
  }

  connect() {
    IPCLog.d(this.logTag, 'ipc connect start')

    this.onP2PCameraListener = {
      onReceiveFrameYUVData: (sessionId: number, y: ArrayBuffer, u: ArrayBuffer, v: ArrayBuffer,
        videoFrameInfo: ThingCameraVideoFrame, camera: Object): void => {
        // IPCLog.d(this.logTag, 'OnP2PCameraListener  onReceiveFrameYUVData');
      },
      onSessionStatusChanged: (sessionId: number, status: number, camera: Object): void => {
        IPCLog.d(this.logTag, 'OnP2PCameraListener  onSessionStatusChanged');
        this.disconnect()
      },
      onReceiveAudioBufferData: (sessionId: number, pcm: ArrayBuffer, audioFrameInfo: ThingCameraAudioFrame,
        camera: Object): void => {
        IPCLog.d(this.logTag, 'OnP2PCameraListener  onReceiveAudioBufferData');
      },
      onEventInfoReceived: (event: number, error_code: number, reserved: number, strinfo: string): void => {
        IPCLog.d(this.logTag, 'OnP2PCameraListener  onEventInfoReceived');
      },

      onReceiveSpeakerEchoData: (pcm : ArrayBuffer, sampleRate : number): void => {
        IPCLog.d(this.logTag, 'OnP2PCameraListener  onReceiveSpeakerEchoData');
      },
    };
    this.cameraP2P.registerP2PCameraListener(this.onP2PCameraListener);

    if (TSmartUser.getUid() !== undefined) {
      this.cameraP2P.connectWrapper().then((result) => {
        if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
          IPCLog.d(this.logTag, 'ipc connect success')
          this.startPreview();
        } else {
          IPCLog.e(this.logTag, 'ipc connect fail' + result.errorCodeNumber)
        }
      }).catch((e: TSmartAtopRequestError) => {
        IPCLog.e(this.logTag, 'ipc connect fail' + e)
      })
    } else {
      IPCLog.e(this.logTag, 'uid is undefined')
    }
    IPCLog.d(this.logTag, 'ipc connect end')
  }

  startPreview() {
    if (!this.cameraP2P.isConnected()) {
      IPCLog.e(this.logTag, 'ipc isConnected false')
      return
    }
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
  }

  stopPreview() {
    IPCLog.d(this.logTag, 'ipc stopPreview start')
    let stopPreviewCallBack: ThingCameraCallback = {
      onResponse(reason: string, errCode: number): number {
        IPCLog.d(this.logTag, 'ipc stopPreview callback')
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
  }

  disconnect() {
    this.cameraP2P.disconnect(true).then((result) => {
      if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
        IPCLog.d(this.logTag, 'ipc disconnect return success')
      } else {
        IPCLog.e(this.logTag, 'ipc disconnect fail')
      }
    }).catch((e: TSmartAtopRequestError) => {
      IPCLog.e(this.logTag, 'ipc preview fail' + e)
    });
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
        })
        .margin({
          top: 10,
          left: 12,
          right: 12
        })
      }.height('50%')

      Row() {
        Button('ipc connect')
          .width('30%')
          .onClick(async () => {
            this.connect();
          })

        Button('ipc disconnect')
          .width('30%')
          .onClick(async () => {
            this.stopPreview();

            this.disconnect();
          })

        Button('ipc isConnected')
          .width('30%')
          .onClick(async () => {
            let isConnected = this.cameraP2P.isConnected();
            IPCLog.d(this.logTag, 'ipc isConnected ' + isConnected)
          })
      }

      Row() {
        Button('截图')
          .width('30%')
          .onClick(async () => {
            if (this.cameraP2P !== undefined) {
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
            } else {
              IPCLog.d(this.logTag, "截图失败，this.cameraP2P === undefined");
            }
          })

        Button('开始录制')
          .width('30%')
          .onClick(async () => {
            if (this.cameraP2P !== undefined) {
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
            } else {
              IPCLog.d(this.logTag, "开始录制失败，this.cameraP2P === undefined");
            }
          })

        Button('结束录制')
          .width('30%')
          .onClick(async () => {
            if (this.cameraP2P !== undefined) {
              IPCLog.d(this.logTag, "结束录制");
              this.cameraP2P.stopRecordLocalMp4().then((result) => {
                if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                  IPCLog.d(this.logTag, "结束录制 成功");
                } else {
                  IPCLog.d(this.logTag, "结束录制 失败 " + result.errorCodeNumber);
                }
              });
            } else {
              IPCLog.d(this.logTag, "结束录制失败，this.cameraP2P === undefined");
            }
          })
      }

      Row() {
        Button('获取清晰度')
          .width('30%')
          .onClick(async () => {
            if (this.cameraP2P !== undefined) {
              IPCLog.d(this.logTag, "获取清晰度");
              this.cameraP2P.getVideoClarity().then((result) => {
                if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                  this.clarity = result.data;
                  IPCLog.d(this.logTag, "获取清晰度 成功 " + result.data);
                } else {
                  IPCLog.d(this.logTag, "获取清晰度 失败 " + result.errorCodeNumber);
                }
              });
            } else {
              IPCLog.d(this.logTag, "获取清晰度失败，this.cameraP2P === undefined");
            }
          })

        Button('设置清晰度')
          .width('30%')
          .onClick(async () => {
            if (this.cameraP2P !== undefined) {
              IPCLog.d(this.logTag, "设置清晰度");
              let clarity = 4;
              if (this.clarity === 4) {
                clarity = 2;
              } else {
                clarity = 4;
              }
              this.cameraP2P.setVideoClarity(clarity).then((result) => {
                if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                  this.clarity = result.data;
                  IPCLog.d(this.logTag, "设置清晰度 成功 " + result.data);
                } else {
                  IPCLog.d(this.logTag, "设置清晰度 失败 " + result.errorCodeNumber);
                }
              });
            } else {
              IPCLog.d(this.logTag, "设置清晰度失败，this.cameraP2P === undefined");
            }
          })

        Button('设备能力')
          .width('30%')
          .onClick(async () => {
            IPCLog.d(this.logTag, "设备能力");
            let cameraConfig = ThingIPCSdk.getCameraConfig(this.devId)
            cameraConfig.getSupportPlaySpeedList();
          })
      }

      Row() {
        Button('静音')
          .width('30%')
          .onClick(async () => {
            if (this.cameraP2P !== undefined) {
              IPCLog.d(this.logTag, "静音");
              let mute = this.cameraP2P.getMute();
              if (mute === 1) {
                mute = 0;
              } else {
                mute = 1;
              }
              this.cameraP2P.setMute(mute).then((result) => {
                if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                  IPCLog.d(this.logTag, "静音设置 成功");
                } else {
                  IPCLog.d(this.logTag, "静音设置 失败 " + result.errorCodeNumber);
                }
              });
            } else {
              IPCLog.d(this.logTag, "静音设置失败，this.cameraP2P === undefined");
            }
          })

        Button('开始对讲')
          .width('30%')
          .onClick(async () => {
            if (this.cameraP2P !== undefined) {
              IPCLog.d(this.logTag, "对讲");
              this.cameraP2P.startAudioTalk().then((result) => {
                if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                  IPCLog.d(this.logTag, "开始对讲 成功");
                } else {
                  IPCLog.d(this.logTag, "开始对讲 失败 " + result.errorCodeNumber);
                }
              });
            } else {
              IPCLog.d(this.logTag, "开始对讲失败，this.cameraP2P === undefined");
            }
          })

        Button('结束对讲')
          .width('30%')
          .onClick(async () => {
            if (this.cameraP2P !== undefined) {
              IPCLog.d(this.logTag, "结束对讲");
              this.cameraP2P.stopAudioTalk().then((result) => {
                if (result.errorCodeNumber === ThingCameraErrorCode.SUCCESS) {
                  IPCLog.d(this.logTag, "结束对讲 成功");
                } else {
                  IPCLog.d(this.logTag, "结束对讲 失败 " + result.errorCodeNumber);
                }
              });
            } else {
              IPCLog.d(this.logTag, "结束对讲失败，this.cameraP2P === undefined");
            }
          })
      }
    }
  }
}