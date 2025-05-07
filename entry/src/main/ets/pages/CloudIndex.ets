// pages/CloudIndex.ets
import { TSmartAtopRequestError } from '@thingsmart/channel';
import { IThingCloudCamera, ThingIPCSdk } from '@thingsmart/ipcsdkhar';
import { ThingCameraCloudDay } from '@thingsmart/ipcsdkhar/src/main/ets/api/bean/ThingCameraCloudBean';
import { IPCLog } from '@thingsmart/ipcsdkhar';
import { ThingCameraResponse } from '@thingsmart/ipcsdkhar/src/main/ets/listener/ThingCameraResponse';
import { TSmartDeviceCache, TSmartDeviceModel } from '@thingsmart/device';
import { TSmartHome, TSmartHomeBean } from '@thingsmart/homelib';
import { ThingCameraEngineManager, ThingCameraInterface, ThingFinishableCallback } from '@thingsmart/thingcamerasdk';
import { XComponentContext} from '@thingsmart/thingvideorenderersdk' ;
import { ThingCameraCloudTimeLineBean } from '@thingsmart/ipcsdkhar/src/main/ets/api/bean/ThingCameraCloudTimeLineBean';
import { ThingCloudFinishableCallbackImpl } from './ThingFinishableCallback';
import { ThingCameraCloudStateBeans } from '@thingsmart/ipcsdkhar/src/main/ets/api/bean/ThingCameraCloudStateBeans';
import { WindowManager } from '@kit.SpeechKit';
import { window } from '@kit.ArkUI';
import { ThingCameraCloudEventBeans } from '@thingsmart/ipcsdkhar/src/main/ets/api/bean/ThingCameraCloudEventBeans';
import call from '@ohos.telephony.call';


@Entry
@Component
struct CloudIndex {
  @State message: string = 'Hello World';
  logTag: string = "index";
  mDeviceBean?: TSmartDeviceModel;
  mDeviceId = ''
  private xComponentContext0: XComponentContext | undefined = undefined;
  cloudCameraManager?:IThingCloudCamera;
  mute?:boolean = true;
  pause?:boolean = false;
  @State homeInfoTitle?:string = '家庭信息获取中';
  @State cloudStateTitle?:string = '云存储状态 点击获取'
  @State cloudDataTitle?:string = '云存储数据 点击获取'
  @State cloudPauseTitle?:string = '暂停播放'
  @State canPlay?:boolean = false;
  private screenWidth: number = 0


  onPageShow(): void {
    TSmartHome.getInstance(41168339).getHomeDetail(async (homeDetail: TSmartHomeBean) => {
      if (homeDetail === undefined) {
        this.homeInfoTitle = '请登录';
        return
      }
      IPCLog.d(this.logTag, '家庭信息获取成功' + homeDetail.homeName)
      this.homeInfoTitle = '家庭信息获取成功'

      const device = await TSmartDeviceCache.get(this.mDeviceId)
      this.mDeviceBean = device;
      IPCLog.d(this.logTag, 'getDevice end' + device?.name)

      this.homeInfoTitle = '家庭信息获取成功' + '设备信息获取成功'
    })
  }

  onPageHide(): void {
    if (this.cloudCameraManager) {
      this.cloudCameraManager.stopPlayCloudData();
      IPCLog.d(this.logTag,'stopPlayCloudData');
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
            if (this.cloudCameraManager === undefined) {
              this.cloudCameraManager = ThingIPCSdk.getCloudCamera(this.mDeviceId);
            }
            this.cloudCameraManager?.bindXComponentContext(this.xComponentContext0);
          }).onDestroy(() => {
            console.log('onDestroy');
          }).id("xcomponent")
        }
        .width('100%')
        .height('100%')
        .margin({
          top: 0,
          left: 0,
          right: 0
        })
      }
      .margin({
        top: 0
      })
      .height('30%')
      .width('100%')

      Button(this.homeInfoTitle)
        .width('50%')
        .onClick(async () => {
          return
          IPCLog.d(this.logTag, 'getDevice start')
          const device = await TSmartDeviceCache.get(this.mDeviceId)
          this.mDeviceBean = device;
          IPCLog.d(this.logTag, 'getDevice end' + device?.name)
        })
      Button(this.cloudStateTitle)
        .width('50%')
        .onClick(async () => {
          IPCLog.d(this.logTag, "getCloudState");
          if (this.cloudCameraManager === undefined) {
            this.cloudCameraManager = ThingIPCSdk.getCloudCamera(this.mDeviceId);
          }

          this.cloudCameraManager?.getCloudState(this.mDeviceId,(this.mDeviceBean?.productId ? this.mDeviceBean.productId : ''),(this.mDeviceBean?.uuid ? this.mDeviceBean.uuid : ''))
            .then((responres: ThingCameraResponse<ThingCameraCloudStateBeans> | undefined) => {
              if (responres !== undefined) {
                console.log('getCloudState' + responres);
                this.cloudStateTitle = '云存储状态'  + responres?.data?.servedStatus;
              }
            })
            .catch((e: TSmartAtopRequestError) => {
              IPCLog.d(this.logTag, "getCloudState = " + e);
            })
        })

      Button(this.cloudDataTitle)
        .width('50%')
        .onClick(() => {
          IPCLog.d(this.logTag, "getCloudTimeLineData");
          if (this.cloudCameraManager === undefined) {
            this.cloudCameraManager = ThingIPCSdk.getCloudCamera(this.mDeviceId);
          }
          this.cloudCameraManager.getCloudTimeLineData(this.mDeviceId,1743091200,1743177599)
            .then((response: ThingCameraResponse<Array<ThingCameraCloudTimeLineBean>> | undefined) => {
              if (response) {
                // console.log('getCloudTimeLineData:' + response.result);
                let  prefix = '';
                response.data?.forEach((item: ThingCameraCloudTimeLineBean) => {
                  prefix = prefix + item.prefix;
                })
                this.cloudDataTitle = '云存储数据 获取成功'
                this.canPlay = true;
              }
            }).catch((e: TSmartAtopRequestError) => {
            IPCLog.d(this.logTag, "getCloudState = " + e);
          })
        })

      Button(this.canPlay ? "点击播放" : "获取数据中...")
        .width('50%')
        .onClick(() => {
          if (!this.canPlay) {
            return
          }
          IPCLog.d(this.logTag, "play cloud video");
          if (this.cloudCameraManager === undefined) {
            this.cloudCameraManager = ThingIPCSdk.getCloudCamera(this.mDeviceId);
          }
          let callback: ThingFinishableCallback = {
            onFinished: (data: string, errCode: number): void => {
              IPCLog.i(this.logTag, " onfinished message received.")
            },
            onEvent: (eventType: number, info1: number, info2: number, errInfo: string): void => {
              IPCLog.i(this.logTag, " onEvent message received.")
            },
            onResponse: (reason: string, errCode: number): number => {
              IPCLog.i(this.logTag, " onResponse reson:" + reason + " errCode:" + errCode);
              return 0;
            }
          }
          this.cloudCameraManager.playCloudVideo(this.mDeviceId,1743091201,1743104342,callback)
        })

      Button('获取事件列表')
        .width('50%')
        .onClick(() => {
          this.cloudCameraManager?.getCloudEvents(this.mDeviceId,(1743350400),(1743436799)).then((response: ThingCameraResponse<ThingCameraCloudEventBeans> | undefined) => {
            console.log('dawei event ' + response?.data?.datas);
            response?.data?.datas?.forEach((item : ThingCameraCloudEventBeans) => {
              console.log(item.describe);
              console.log(item.encryption?.key + 'dawei');
            })
          })

          this.cloudCameraManager?.getCloudDays(this.mDeviceId).then((response: ThingCameraResponse<Array<ThingCameraCloudDay>> | null) => {
            response?.data?.forEach((item:ThingCameraCloudDay) => {
              console.log(item.uploadDay);
            })
          });
        })

      Button('更新声音状态')
        .width('50%')
        .onClick(() => {
          let callback: ThingFinishableCallback = {
            onFinished: (data: string, errCode: number): void => {
              IPCLog.i(this.logTag, " onfinished message received.")
            },
            onEvent: (eventType: number, info1: number, info2: number, errInfo: string): void => {
              IPCLog.i(this.logTag, " onEvent message received.")
            },
            onResponse: (reason: string, errCode: number): number => {
              IPCLog.i(this.logTag, " onResponse reson:" + reason + " errCode:" + errCode);
              return 0;
            }
          }
          this.cloudCameraManager?.enableMute(1);
        })

      Button(this.cloudPauseTitle)
        .width('50%')
        .onClick(() => {

          let pausePlayCallback: ThingFinishableCallback = {
            onFinished: (data: string, errCode: number): void => {
              IPCLog.i(this.logTag, " onfinished message received.")
            },
            onEvent: (eventType: number, info1: number, info2: number, errInfo: string): void => {
              IPCLog.i(this.logTag, " onEvent message received.")
            },
            onResponse: (reason: string, errCode: number): number => {
              IPCLog.i(this.logTag, " onResponse reson:" + reason + " errCode:" + errCode);
              return 0;
            }
          }

          if (this.pause) {
            this.pause = false;
            const value = this.cloudCameraManager?.resumePlayCloudVideo();
            this.cloudPauseTitle = '暂停播放';
          }else {
            this.pause = true;
            const value = this.cloudCameraManager?.pausePlayCloudVideo();
            this.cloudPauseTitle = '继续播放';
          }
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
