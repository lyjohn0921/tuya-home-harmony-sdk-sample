# 设备实例与设备模型



设备实例：TSmartDevice

开发者可以通过 `TSmartDevice` 进行设备的增删查改灯操作，以及对设备的监听



设备模型：TSmartDeviceModel

设备的基础信息都保存在 TSmartDeviceModel 中



## 注册设备服务

此方法调用后才可使用局域网、mqtt、蓝牙在离线等功能，在登录成功之后调用

**API :**

```typescript
export class TSmartDevice {
	public static register(uid: string)
}
```



**入参：**

| 参数名 | 释义   | 是否可选 |
| ------ | ------ | -------- |
| uid    | 用户id | 必选     |



**返回值：**

void



**示例：**

```typescript
TSmartDevice.register(userModel.uid)
```



## 获取设备信息

**API :**

```typescript
export class TSmartDevice {
	public static async syncDeviceInfo(devId: string, gid?: string): Promise<TSmartDeviceModel | undefined>
}
```



**入参：**

| 参数名 | 释义   | 是否可选 |
| ------ | ------ | -------- |
| devId  | 设备id | 必选     |
| gid    | 家庭id | 可选     |



**返回值：**

Promise<TSmartDeviceModel | undefined>



**示例：**

```typescript
	const deviceModel = await TSmartDevice.syncDeviceInfo(devId, homeId)
```



## 获取设备实例

**API :**

```typescript
export class TSmartDevice {
  public static create(devId: string): TSmartDevice | undefined
}
```



**入参：**

| 参数名 | 释义   | 是否可选 |
| ------ | ------ | -------- |
| devId  | 设备id | 必选     |



**返回值：**

TSmartDevice | undefined



**示例：**

```typescript
const device = TSmartDevice.create(devId)
```



**注意：**

**当设备缓存中存在设备模型时，才能成功获取设备实例**



## 移除设备

**API :**

```typescript
export class TSmartDevice {
	public remove(reset: boolean = false)
}
```



**入参：**

| 参数名 | 释义                 | 是否可选                 |
| ------ | -------------------- | ------------------------ |
| reset  | 是否需要恢复出厂设置 | 可选，默认不恢复出厂设置 |



**返回值：**

void



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('移除设备', () => {
	this.device.remove()
}),
```



## 修改设备名称

**API :**

```typescript
export class TSmartDevice {
	public async updateName(name: string)
}
```



**入参：**

| 参数名 | 释义         | 是否可选 |
| ------ | ------------ | -------- |
| name   | 设备的新名称 | 必选     |



**返回值：**

void



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('修改设备名称', () => {
	this.device.updateName("new name")
}),
```



## 同步设备信息

**API :**

```typescript
export class TSmartDevice {
	public async syncDeviceInfo(ownerId: string = "")
}
```



**入参：**

| 参数名  | 释义   | 是否可选 |
| ------- | ------ | -------- |
| ownerId | 家庭id | 必选     |



**返回值：**

Promise<TSmartDeviceModel | undefined>



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('同步设备信息', async () => {
	const deviceModel = await this.device.syncDeviceInfo(homeId)
}),
```



**注意：**

**当设备信息成功同步之后，如果已经监听了设备的变化，还会通过触发**

```typescript
onDeviceInfoUpdated: (devId: string) => void;
```

**进行相关业务处理**



## 查询WiFi信号强度

**API :**

```typescript
export class TSmartDevice {
	public queryWifiSignal(callback:(signal:number) => void)
}
```



**返回值：**

void



**回调：**

callback:(signal:number) => void



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('查询设备信号', () => {
	this.device!.queryWifiSignal(signal => {
      console.log("signal is =" + signal)
    })
}),
```





## 获取产品信息

**API :**

```typescript
export class TSmartDevice {
	public static async syncProductInfo(productId: string, uuid?: string, mac?: string): Promise<Record<string, Object> | undefined>
}
```



**入参：**

| 参数名  | 释义        | 是否可选 |
| ------- | ----------- | -------- |
| ownerId | 家庭id      | 必选     |
| uuid    | 设备uuid    | 可选     |
| mac     | 设备mac地址 | 可选     |



**返回值：**

Promise<Record<string, Object> | undefined>



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('获取产品信息', async () => {
	const res = await this.device.syncProductInfo(productId)
    if (res) {
    	console.log("productInfo: " + res)
    }
}),
```



## 获取设备在线状态

只要设备云端、局域网、蓝牙有一项是在线的，那么就会返回true

**API :**

```typescript
export class TSmartDeviceModel {
	public isOnline(): boolean
}
```

**返回值：**

boolean



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('获取设备在线状态', async () => {
	const online = this.device.deviceModel.isOnline()
}),
```



## 获取局域网在线状态

**API :**

```typescript
export class TSmartDeviceModel {
	public getIsLocalOnline(): boolean
}
```



**返回值：**

boolean



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('获取设备局域网在线状态', async () => {
	const online = this.device.deviceModel.getIsLocalOnline()
}),
```



## 获取云端在线状态

**API :**

```typescript
export class TSmartDeviceModel {
	public isCloudOnline(): boolean
}
```



**返回值：**

boolean



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('获取设备云端在线状态', async () => {
	const online = this.device.deviceModel.isCloudOnline()
}),
```



## 获取设备在线类型

**API :**

```typescript
export class TSmartDeviceModel {
	public onlineType(): TSmartDeviceOnlineType
}
```



**返回值：**

TSmartDeviceOnlineType



```typescript
export enum TSmartDeviceOnlineType {
  Offline = 0,
  WiFi = 1 << 0,
  LAN = 1 << 1,
  BLE = 1 << 2,
}
```



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('获取设备在线状态类型', async () => {
	const onlineType = this.device.deviceModel.onlineType()
}),
```



## 判断设备是否是网关

**API :**

```typescript
export class TSmartDeviceModel {
	public isGateway(): boolean
}	
```



**返回值：**

boolean



**示例：**

```
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('是否是网关', async () => {
	const isGw = this.device.deviceModel.isGateway()
}),
```



## 判断设备是否是子设备

**API :**

```typescript
export class TSmartDeviceModel {
	public isSubDev(): boolean
}
```



**返回值：**

boolean



**示例：**

```
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('是否是子设备', async () => {
	const isSub = this.device.deviceModel.isSubDev()
}),
```



## 判断设备是否支持Zigbee

**API :**

```
export class TSmartDeviceModel {
	public supportZigbee(): boolean
}
```



**返回值：**

boolean



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('是否支持Zigbee', async () => {
	const supportZigbee = this.device.deviceModel.supportZigbee()
}),
```





## 判断设备是否支持蓝牙

**API :**

```typescript
export class TSmartDeviceModel {
	public hasBLECapability(): boolean
}
```



**返回值：**

boolean



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('是否支持蓝牙', async () => {
	const supportBLE = this.device.deviceModel.hasBLECapability()
})
```





# 设备状态监听

当需要监听设备的状态更新时，可通过注册设备监听来达成

**API :**

```typescript
export class TSmartDevice {
	public registerListener(listener: TSmartDeviceListener): void
}
```



**入参：**

| 参数名   | 释义             | 是否可选 |
| -------- | ---------------- | -------- |
| listener | 设备状态监听回调 | 必选     |



```typescript
export interface TSmartDeviceListener {
  onDpsChanged: (devId: string, dps: DpsType, dpsTime: Record<string, Object>) => void;
  onOnlineChanged: (devId: string) => void;
  onDeviceInfoUpdated: (devId: string) => void;
  onDeviceRemoved: (devId: string) => void
  onWarningInfoUpdate: (devId: string, info: Record<string, Object>) => void
  onSignalQuery: (devId: string, signal: number) => void
}
```

**返回值：**

void



**示例：**

```typescript
public device: TSmartDevice = TSmartDevice.create(devId)

new Action('注册设备监听', async () => {
  	this.device.registerListener({
      	// 设备dp点发生变化
        onDpsChanged: (devId: string, dps: DpsType, dpsTime: Record<string, Object>) => {
          console.log(`onDpsChanged devId=${devId}, dps=${dps}`) 
        },
      	// 设备在线状态发生变化
        onOnlineChanged: async (devId: string) => {
          const o = await this.deviceModel!.isOnline()
          console.log("在线状态：" + (o ? "在线" : "离线"))
        },
      	// 设备信息更新
        onDeviceInfoUpdated: (devId: string) => {
          console.log(devId + "设备信息更新")
        },
      	// 设备被移除
        onDeviceRemoved: (devId: string) => {
          console.log(devId + "设备被移除")
        },
      	// 设备收到警告信息
        onWarningInfoUpdate: (devId: string, info: Record<string, Object>) => {
          console.log(devId + "设备收到警告信息")
        },
        onSignalQuery: (devId: string, signal: number) => {
          console.log(devId + "设备信号查询结果:" + signal)
        }
      })
})
```



# 设备缓存

通常已经获取到的设备模型会保存进缓存中，通过缓存可以快速存取设备模型



## 添加设备

**API :**

```typescript
export class TSmartDeviceCache {
	public static async add(dm: TSmartDeviceModel): Promise<void>
}
```



**入参：**

| 参数名 | 释义     | 是否可选 |
| ------ | -------- | -------- |
| dm     | 设备模型 | 必选     |



**返回值：**

Promise<void>



**示例：**

```typescript
TSmartDeviceCache.add(model)
```



## 批量添加

**API :**

```typescript
export class TSmartDeviceCache {
	public static async addBatch(deviceModels: TSmartDeviceModel[]): Promise<void>
}
```



**入参：**

| 参数名       | 释义         | 是否可选 |
| ------------ | ------------ | -------- |
| deviceModels | 设备模型数组 | 必选     |



**返回值：**

Promise<void>



**示例：**

```typescript
TSmartDeviceCache.addBatch(models)
```



## 获取设备

**API :**

```typescript
export class TSmartDeviceCache {
	public static getSync(devId: string): TSmartDeviceModel | undefined
}
```



**入参：**

| 参数名 | 释义   | 是否可选 |
| ------ | ------ | -------- |
| devId  | 设备id | 必选     |



**返回值：**

TSmartDeviceModel | undefined



**示例：**

```typescript
const deviceModel = TSmartDeviceCache.getSync("devId")
```



## 通过UUID获取缓存设备

**API :**

```typescript
export class TSmartDeviceCache {
	public static getByUuid(devId: string): TSmartDeviceModel | undefined
}
```



**入参：**

| 参数名 | 释义     | 是否可选 |
| ------ | -------- | -------- |
| uuid   | 设备uuid | 必选     |



**返回值：**

TSmartDeviceModel | undefined



**示例：**

```typescript
const deviceModel = TSmartDeviceCache.getByUuid("uuid")
```



## 获取家庭下的缓存设备列表

**API :**

```typescript
export class TSmartDeviceCache {
	 public static async getByOwnerId(ownerId: string): Promise<TSmartDeviceModel[]>
}
```



**入参：**

| 参数名  | 释义   | 是否可选 |
| ------- | ------ | -------- |
| ownerId | 家庭id | 必选     |



**返回值：**

Promise<TSmartDeviceModel[]>



**示例：**

```typescript
const deviceModels = await TSmartDeviceCache.getByOwnerId("ownerId")
```



## 获取缓存内的所有设备

**API :**

```typescript
export class TSmartDeviceCache {
	 public static async getAll(): Promise<TSmartDeviceModel[]>
}
```



**返回值：**

Promise<TSmartDeviceModel[]>



**示例：**

```typescript
const deviceModels = await TSmartDeviceCache.getAll()
```



## 移除设备

**API :**

```typescript
export class TSmartDeviceCache {
	 public static async remove(devId: string):  Promise<void>
}
```



**入参：**

| 参数名 | 释义   | 是否可选 |
| ------ | ------ | -------- |
| devId  | 设备id | 必选     |



**返回值：**

Promise<void>



**示例：**

```typescript
const deviceModels = await TSmartDeviceCache.remove("devId")
```



# 离线提醒

设备离线是指设备完成配网后，出现掉线、无网络响应的情况。您可以为设备开启离线告警，发生设备离线的情况后，设备会向指定用户发送通知。用户可以订阅消息推送功能来开启该功能。

## 

## 检查设备是否支持离线告警

**API :**

```typescript
export class TSmartDevice {
	 public async getOfflineReminderSupportStatus(): boolean
}
```



**返回值：**

boolean



**示例：**

```typescript
const support = await this.device?.getOfflineReminderSupportStatus()
console.log("是否支持离线提醒:" + support)
```



## 获取设备离线告警状态

**API :**

```typescript
export class TSmartDevice {
	 public async getOfflineReminderStatus(): boolean
}
```



**返回值：**

boolean



**示例：**

```typescript
const getRes = await this.device?.getOfflineReminderStatus()
console.log("离线提醒查询结果:" + getRes)
```



## 设置设备离线告警状态

**API :**

```typescript
export class TSmartDevice {
	 public async setOfflineReminder(): boolean
}
```



**返回值：**

boolean



**示例：**

```typescript
const setRes = await this.device?.setOfflineReminder(false)
console.log("离线提醒设置结果:" + setRes)
```

