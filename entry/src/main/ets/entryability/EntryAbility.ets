import {
  abilityAccessCtrl,
  AbilityConstant,
  common,
  ConfigurationConstant,
  Permissions,
  UIAbility,
  Want
} from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { TSmartSDK } from '@thingsmart/channel';
import { IPCLog, ThingIPCSdk } from '@thingsmart/ipcsdkhar';
import { getReflectMetaInfo } from "../gensrc/thingReflectMetaInfo";
import { bundleManager } from "@kit.AbilityKit";
import { thingDynamicReflect } from "@thingsmart/dynamicreflect";
import { ThingInitializer } from '@thingsmart/dynamicinitializer';
import resourceManager from '@ohos.resourceManager';
import { JSON, util } from '@kit.ArkTS';
import { StringUtil } from '../pages/StringUtil';

const DOMAIN = 0x0000;
const permissions: Array<Permissions> =
  ['ohos.permission.MICROPHONE', 'ohos.permission.WRITE_MEDIA', 'ohos.permission.READ_MEDIA'];

// 使用UIExtensionAbility：将common.UIAbilityContext 替换为common.UIExtensionContext
function reqPermissionsFromUser(permissions: Array<Permissions>, context: common.UIAbilityContext): void {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
  atManager.requestPermissionsFromUser(context, permissions).then((data) => {
    let grantStatus: Array<number> = data.authResults;
    let length: number = grantStatus.length;
    for (let i = 0; i < length; i++) {
      if (grantStatus[i] === 0) {
        // 用户授权，可以继续访问目标操作
      } else {
        // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
        return;
      }
    }
    // 授权成功
  }).catch((err: BusinessError) => {
    console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
  })
}

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');


      let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
      let bundleInfo = bundleManager.getBundleInfoForSelfSync(bundleFlags);
      // let thingDynamicReflect = getReflectMetaInfo(bundleInfo.name,"entry");

      thingDynamicReflect.init(getReflectMetaInfo(bundleInfo.name, "entry")); //入口 hap 模块的名字

      const initMetaInfo = thingDynamicReflect.filterMetaInfo(ThingInitializer.DEFAULT_GROUP);
      if (initMetaInfo && initMetaInfo.size > 0) {
        new ThingInitializer(initMetaInfo).execute(this.context);
      }

      /**
       * rawfile local_config.json 配置内容：
       {
       "bundle_name": "",
       "app_key": "",
       "app_secret": "",
       "test_home_id": "",
       "test_dev_id": "",
       "test_login_account": "",
       "test_login_password": ""
       }
       */

      let appKey: string = "";
      let appSecret: string = "";

      let localConfig = StringUtil.getAppConfig(this.context)
      if (localConfig["app_key"] !== undefined) {
        appKey = localConfig["app_key"];
      }

      if (localConfig["app_secret"] !== undefined) {
        appSecret = localConfig["app_secret"];
      }
      // let package = 'xxx'

      PersistentStorage.persistProp('countryCode', '86')
      PersistentStorage.persistProp('regionCode', 'CN')
      TSmartSDK.startWithAppKey(appKey, appSecret, this.context, bundleInfo.name)

      ThingIPCSdk.init(this.context);

      reqPermissionsFromUser(permissions, this.context);
    });
  }


  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'Ability onBackground');
  }
}