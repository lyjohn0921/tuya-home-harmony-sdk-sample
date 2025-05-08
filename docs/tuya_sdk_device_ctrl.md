# 控制设备

**API :**

```typescript
export class TSmartDevice {
	public async publishDps(dps: string, mode: TSmartDpsPublishMode)
}
```



**入参：**

| 参数名 | 释义         | 是否可选 |
| ------ | ------------ | -------- |
| dps    | 设备dp点     | 必选     |
| mode   | 指定控制通道 | 可选     |



```typescript
export enum TSmartDpsPublishMode {
  LOCAL = 0,
  CLOUD,
  AUTO
}
```



**返回值：**

Promise<Record<string, Object> | undefined>



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('获取产品信息', async () => {
  	// 当前设备的开关dpId为20， 1是打开开关
	this.device.publishDps('{"20": "1"}', TSmartDpsPublishMode.AUTO)
}),
```



