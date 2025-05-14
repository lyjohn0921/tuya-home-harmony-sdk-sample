import { ITSmartLocalKeyProvider, TSmartAtopRequestError, TSmartMqtt, TSmartMqttConfig } from '@thingsmart/channel';
import { TSmartUser, TSmartUserAccountType } from '@thingsmart/userlib';
import { DpStaticHelper, ThingIPCSdk } from '@thingsmart/ipcsdkhar';
import { ThingCameraCloudDay } from '@thingsmart/ipcsdkhar/src/main/ets/api/bean/ThingCameraCloudBean';
import { IPCLog } from '@thingsmart/ipcsdkhar';
import { ThingCameraResponse } from '@thingsmart/ipcsdkhar/src/main/ets/listener/ThingCameraResponse';
import { TSmartDeviceCache, TSmartDeviceModel, TSmartDeviceUtil } from '@thingsmart/device';
import { TSmartHome, TSmartHomeBean } from '@thingsmart/homelib';
import {
  ThingCameraEngineManager,
  ThingCameraInterface,
  ThingCameraListener,
  ThingFinishableCallback
} from '@thingsmart/thingcamerasdk';
import { ThingCameraConstants } from '@thingsmart/thingcamerasdk';
import { ThingCameraVideoFrame } from '@thingsmart/thingcamerasdk/Index';
import { ThingCameraAudioFrame } from '@thingsmart/thingcamerasdk/Index';
import { ThingCameraErrorCode } from '@thingsmart/ipcsdkhar/src/main/ets/utils/ThingCameraErrorCode';
import { ThingCameraCallback } from '@thingsmart/ipcsdkhar/src/main/ets/listener/ThingCameraCallback';
import { XComponentContext } from '@thingsmart/thingvideorenderersdk';
import { Permissions } from '@kit.AbilityKit';
import { PermissionUtil } from './PermissionUtil';
import { MD5 } from '@thingsmart/util';
// import { router } from '@kit.ArkUI';
import { OnP2PCameraListener } from '@thingsmart/ipcsdkhar/src/main/ets/listener/OnP2PCameraListener';
import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  logTag: string = "index";

  private thingCamera: ThingCameraInterface | undefined = undefined;
  onP2PCameraListener?: OnP2PCameraListener = undefined

  videomessageTest() {
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
    let url: string =
      "https://ty-storage-permanent-1254153901.cos.tuyacn.com/76a999-12627043-0043614468572d20da1d/common/1614751269.media?sign=q-sign-algorithm%3Dsha1%26q-ak%3DAKIDUifQtRiiPowlKddLkriIZYEchUyA4h38%26q-sign-time%3D1742905189%3B1742908789%26q-key-time%3D1742905189%3B1742908789%26q-header-list%3Dhost%26q-url-param-list%3D%26q-signature%3D5835b18b96f80ad5dbf8b42458c4a7df7156f2b9";
    this.thingCamera?.playVideoMessage(url, 0, "752abc4576b9b210", callback);
  }

  aboutToAppear(): void {
    IPCLog.d(this.logTag, "aboutToAppear");
  }

  aboutToDisappear(): void {
    IPCLog.d(this.logTag, "aboutToDisappear");
  }

  onPageShow(): void {
    IPCLog.d(this.logTag, "onPageShow");
  }

  onPageHide(): void {
    IPCLog.d(this.logTag, "onPageHide");
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

      // 第一个按钮
      Button('登录')
        .width('50%')
        .onClick(async () => {
          IPCLog.d(this.logTag, '登录按钮被点击了')
          try {
            let resp = await TSmartUser.loginAccount({
              account: '',
              countryCode: '86',
              password: '',
              accountType: TSmartUserAccountType.PHONE
            })
            if (resp.success) {
              // 登录成功
              IPCLog.d(this.logTag, "登录成功:" + resp);
              TSmartMqtt.initClient(TSmartUser.getDomain()?.mobileMqttsUrl ?? '',
                (TSmartUser.getPartnerIdentity() ?? '') + (TSmartUser.getSid() ?? ''), TSmartUser.getSid() ?? '',
                (await MD5.digest(TSmartUser.getEcode())).substring(8, 24), TSmartDeviceUtil.getInstance());

              TSmartMqtt.connect().then((result) => {
                IPCLog.d(this.logTag, 'TSmartMqtt.connect')
              });

              ThingIPCSdk.getP2P().initP2P(TSmartUser.getUid() as string);
            } else {
              // 登录失败
              IPCLog.d(this.logTag, "登录失败:" + resp.errorMsg);
            }
          } catch (e) {
            // 接口报错
            IPCLog.d(this.logTag, "登录失败:" + e);
          }
        })

      Row() {
        Button('获取家庭信息')
          .width('30%')
          .onClick(async () => {
            IPCLog.d(this.logTag, 'getHomeDetail start')
            let homeId = 0
            TSmartHome.getInstance(homeId).getHomeDetail((homeDetail: TSmartHomeBean) => {
              IPCLog.d(this.logTag, 'getHomeDetail callback' + homeDetail.homeName)
            })
          })

        Button('获取设备信息')
          .width('30%')
          .onClick(async () => {
            IPCLog.d(this.logTag, 'getDevice start')
            let devId = ""
            const device = await TSmartDeviceCache.get(devId)
            IPCLog.d(this.logTag, 'getDevice end' + device?.name)
          })
      }

      Row() {
        Button('测试 dp')
          .width('30%')
          .onClick(async () => {
            IPCLog.d(this.logTag, 'getHomeDetail start')
            // 155188206 直播
            // 41168339  回放
            let devId = ""
            let dpid = ""
            DpStaticHelper.getInstance().isDPSupport(devId, dpid).then((result) => {
              IPCLog.d(this.logTag, 'isDPSupport end ' + result)
            })

            DpStaticHelper.getInstance().getCurrentValue<string>(devId, dpid).then((result) => {
              IPCLog.d(this.logTag, 'getCurrentValue end ' + result)
            })
          })
      }

      Button('直播')
        .width('50%')
        .onClick(async () => {
          router.push({ url: 'pages/PreviewIndex' })
        })

      Button('回放')
        .width('50%')
        .onClick(async () => {
          router.push({ url: 'pages/PlayBackIndex' })
        })

      Button('云存储')
        .width('50%')
        .onClick(() => {
          router.pushUrl({
            url: 'pages/CloudIndex'
          })
        })
    }
    .width
    ('100%')
    .height
    ('100%'
    )
    .justifyContent
    (FlexAlign
      .Center
    )
    .alignItems
    (HorizontalAlign
      .Center
    )
  }
}