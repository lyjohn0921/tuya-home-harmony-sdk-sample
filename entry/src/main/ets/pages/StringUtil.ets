import { util } from "@kit.ArkTS";
import { IPCLog } from "@thingsmart/ipcsdkhar";

export class StringUtil {

  static getAppConfig(context : Context) : Record<string, string>{
    try {
      return JSON.parse(StringUtil.uint8ArrayToString(context.resourceManager.getRawFileContentSync("local_config.json"))) as Record<string, string>;
    } catch (e) {
      IPCLog.e("init", "请检查 rawfile 目录下的 App 配置文件")
    }
    return {}
  }
  // 字节流转成可理解的字符串
  static uint8ArrayToString(array: Uint8Array) : string{
    let textDecoderOptions: util.TextDecoderOptions = {
      fatal: false,
      ignoreBOM: true
    }
    let decodeToStringOptions: util.DecodeToStringOptions = {
      stream: false
    }
    let textDecoder = util.TextDecoder.create('utf-8', textDecoderOptions);
    let retStr = textDecoder.decodeToString(array, decodeToStringOptions);
    console.info('字节流转成可理解的字符串：' + retStr);
    return retStr;
  }
}
