# 0、导入依赖库

```json
{
  "name": "@xxx",
  "version": "1.0.0",
  "description": "Please describe the basic information.",
  "main": "Index.ets",
  "author": "",
  "license": "Apache-2.0",
  "packageType": "InterfaceHar",
  "dependencies": {
    "@thingsmart/activator": "x.y.z" // 导入activator 的库 
  }
}
```

# 1、API介绍
## 1.1、TSmartActivatorRequester 
**配网相关请求类**
### getActivatorToken 
获取配网token
```typescript
 getActivatorToken(homeId: number): Promise<TSmartActivatorToken | null | undefined>
 ```
**参数：**
| 参数名   | 类型         | 是否必填       | 说明           |
|----------|--------------|----------------|----------------|
| homeId   | number       | 是             | 家庭 ID        |


**返回值：**
| 类型          |                       说明                                      |
|--------------|-----------------------------------------------------------------|
| Promise      | 返回结果为TSmartActivatorToken \| null \| undefined 类型的Promise |

### parseQRCode
解析二维码，用于扫设备二维码配网时，解析设备上的二维码数据。

```typescript
 parseQRCode(content: string): Promise<Record<string, Object>>
 ```

**参数：**
| 参数名   | 类型         | 是否必填       | 说明           |
|----------|--------------|----------------|----------------|
| content   | string       | 是            | 摄像头扫码后获取的二维码的文本内容 |


**返回值：**
| 类型          |                       说明                                      |
|--------------|-----------------------------------------------------------------|
| Promise      | 返回结果为Record<string, Object> 类型的Promise |

### getMQTTDirectlyActivatorToken
用于扫设备二维码配网时获取token
```typescript
getMQTTDirectlyActivatorToken(homeId: number, uuid: string): Promise<TSmartActivatorToken>
 ```

**参数：**
| 参数名   | 类型         | 是否必填       | 说明           |
|----------|--------------|----------------|----------------|
| homeId   | number       | 是            | 家庭ID |
| uuid     | string       | 是            | 从二维码中解析得到的设备uuid |

**返回值：**
| 类型          |                       说明                                      |
|--------------|-----------------------------------------------------------------|
| Promise      | 返回结果为TSmartActivatorToken类型的Promise |

## 1.2、TSmartScannerBuilder
**设备扫描类**
### constructor
```typescript
constructor(scanListener: TSmartScannerListener)
```

**参数：**
| 参数名       | 类型                     | 是否必填 | 说明           |
|-------------|-------------------------|----------------|----------------|
| scanListener| TSmartScannerListener   | 是      | 扫描监听器，扫到设备会调用监听器内部的方法 |

### setScanTimeout
需要在开始扫描之前调用才有效果
```typescript
setScanTimeout(scanTimeout: number): TSmartScannerBuilder
```

**参数：**
| 参数名     | 类型      | 是否必填 | 说明           |
|-----------|----------|---------|----------------|
|scanTimeout| number   | 是      |  超时时间，单位毫秒，默认值120秒。到设定的时间会停止扫描|


**返回值：**
| 类型                |          说明                               |
|--------------------|---------------------------------------------|
|TSmartScannerBuilder| 返回结果为设备扫描类的实例，方便链式调用其它设置方法|

### addScanMode
添加指定的扫描方式，主要包含蓝牙类的扫描和局域网扫描。
```typescript
addScanMode(scanMode: TSmartScanMode): TSmartScannerBuilder
```
**参数：**
| 参数名  | 类型            | 是否必填 | 说明           |
|--------|----------------|---------|----------------|
|scanMode| TSmartScanMode | 是      |  扫描模式|

**返回值：**
| 类型                |          说明                               |
|--------------------|---------------------------------------------|
|TSmartScannerBuilder| 返回结果为设备扫描类的实例，方便链式调用其它设置方法|

### startScan
开始扫描，扫描结果通过扫描监听器回调
```typescript
startScan(): void
```

### stopScan
停止所有的扫描模式
```typescript
stopScan(): void
```
### stopScanMode
停止指定的扫描模式
```typescript
stopScanMode(model: TSmartScanMode): void
```

### TSmartScannerListener
| 名称         | 类型                                       | 是否必填 |                说明           |
|-------------|-------------------------------------------|---------|------------------------------|
|onDeviceFound| (scanResult: TSmartScannerResult) => void | 是      | 设备发现监听方法，当发现设备时会调用|
|onStop       | (error: Error) => void                    | 否      | 设备发现停止回调方法：当发现设备超时时会调用，主动停止后不会再有此回调|
### TSmartScannerResult
| 名称           | 类型              | 是否必填 |     说明            |
|----------------|-----------------|---------|---------------------|
|uniqueId        | string          | 是      | 设备唯一标记|
|productId       | string          | 是      | 产品ID|
|deviceType      |TSmartDeviceType  |是      |设备类型|
|name            |string            |是      |设备名称, name通过网络请求获取，请求失败时会默认为New Device|
|icon            |string            |是      |设备图标的URL, 通过网络请求获取，请求失败时默认空字符串|
|scannedBleDevice|Device           | 否      | 当设备类型是蓝牙或双模设备时有值|

### TSmartScanMode
```typescript
export enum TSmartScanMode {
  SCAN_MODE_BLE = 1 << 0,       // 蓝牙扫描
  SCAN_MODE_LAN = 1 << 1,       // 局域网扫描
}
```
### TSmartDeviceType 
```typescript
export enum TSmartDeviceType {
  BLE,              // 蓝牙设备
  WIFI_BLE,         // 双模设备
  WIRED             // 有线设备
}
```


## 1.3 TSmartActivator
**设备配网类**
### createActivator
```typescript
createActivator(builder: TSmartActivatorBuilder): ITSmartActivator
```
**参数：**
| 参数名  | 类型            | 是否必填 | 说明           |
|--------|----------------|---------|----------------|
|builder| TSmartActivatorBuilder | 是      |  通过builder,创建遵循ITSmartActivator接口的实例|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|ITSmartActivator| 返回值为遵循ITSmartActivator接口类型的实例|

### buildApActivatorBuilder
AP配网时，调用此方法创建builder
```typescript
buildApActivatorBuilder(
    ssid: string,
    password: string,
    timeout: number = 120000,
    token: TSmartActivatorToken,
    listener: ITSmartActivatorListener,
    homeId: number,
    extraParameters?: Record<string, Object>
  ): TSmartActivatorBuilder
```
**参数：**
| 参数名         | 类型                      | 是否必填 | 说明           |
|---------------|--------------------------|---------|----------------|
|ssid           | string                   | 是      |  WiFi名称|
|password       | string                   | 是      |  WiFi密码|
|timeout        | number                   | 否      |  超时时间，单位毫秒，默认120秒|
|token          | TSmartActivatorToken     | 是      |  token，通过getActivatorToken获取|
|listener       | ITSmartActivatorListener | 是      |  配网监听器，配网结果会在监听器中回调|
|homeId         | number                   | 是      |  家庭ID|
|extraParameters| Record<string, Object>   | 否      |  预留额外参数|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|TSmartActivatorBuilder| 返回类型为TSmartActivatorBuilder的builer|

### buildEzActivatorBuilder
EZ配网时，调用此方法创建builder
```typescript
buildEzActivatorBuilder(
    ssid: string,
    password: string,
    timeout: number = 120000,
    listener: ITSmartActivatorListener,
    homeId: number,
    token?: TSmartActivatorToken,
    extraParameters?: Record<string, Object>
  ): TSmartActivatorBuilder
```
**参数：**
| 参数名         | 类型                      | 是否必填 | 说明           |
|---------------|--------------------------|---------|----------------|
|ssid           | string                   | 是      |  WiFi名称|
|password       | string                   | 是      |  WiFi密码|
|timeout        | number                   | 否      |  超时时间，单位毫秒，默认120秒|
|listener       | ITSmartActivatorListener | 是      |  配网监听器，配网结果会在监听器中回调|
|homeId         | number                   | 是      |  家庭ID|
|token          | TSmartActivatorToken     | 否      |  通过getActivatorToken获取，如果不传，则内部会通过homeId获取|
|extraParameters| Record<string, Object>   | 否      |  预留额外参数|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|TSmartActivatorBuilder| 返回类型为TSmartActivatorBuilder的builer|

### buildWiredActivatorBuilder
局域网有线设备配网时，调用此方法创建builder
```typescript
buildWiredActivatorBuilder(
    homeId: number,
    gwId: string,
    productId: string,
    timeout: number = 120000,
    listener: ITSmartActivatorListener,
    token?: TSmartActivatorToken,
    extraParameters?: Record<string, Object>
  ): TSmartActivatorBuilder
```
**参数：**
| 参数名         | 类型                      | 是否必填 | 说明           |
|---------------|--------------------------|---------|----------------|
|homeId         | number                   | 是      |  家庭ID|
|gwId           | string                   | 是      |  对应TSmartScannerResult中的uniqueId|
|productId      | string                   | 是      |  对应TSmartScannerResult中的productId|
|timeout        | number                   | 否      |  超时时间，单位毫秒，默认120秒|
|listener       | ITSmartActivatorListener | 是      |  配网监听器，配网结果会在监听器中回调|
|token          | TSmartActivatorToken     | 否      |  通过getActivatorToken获取，如果不传，则内部会通过homeId获取|
|extraParameters| Record<string, Object>   | 否      |  预留额外参数|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|TSmartActivatorBuilder| 返回类型为TSmartActivatorBuilder的builer|

### buildSubDeviceActivatorBuilder
网关子设备配网时，调用此方法创建builder
```typescript
buildSubDeviceActivatorBuilder(gwId: string, timeout: number = 120000, listener: ITSmartActivatorListener, extraParameters?: Record<string, Object>): TSmartActivatorBuilder
```
**参数：**
| 参数名         | 类型                      | 是否必填 | 说明           |
|---------------|--------------------------|---------|----------------|
|gwId           | string                   | 是      |  网关设备的虚拟ID|
|timeout        | number                   | 否      |  超时时间，单位毫秒，默认120秒|
|listener       | ITSmartActivatorListener | 是      |  配网监听器，配网结果会在监听器中回调|
|extraParameters| Record<string, Object>   | 否      |  预留额外参数|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|TSmartActivatorBuilder| 返回类型为TSmartActivatorBuilder的builer|


### buildBleActivatorBuilder
蓝牙单点设备配网时，调用此方法创建builder
```typescript
buildBleActivatorBuilder(
    homeId: number,
    timeout: number = 60000,
    listener: ITSmartActivatorListener,
    extraParameters?: Record<string, Object>
  ): TSmartActivatorBuilder
```
**参数：**
| 参数名         | 类型                      | 是否必填 | 说明           |
|---------------|--------------------------|---------|----------------|
|homeId         | number                   | 是      |  家庭ID|
|timeout        | number                   | 否      |  超时时间，单位毫秒，默认60秒|
|listener       | ITSmartActivatorListener | 是      |  配网监听器，配网结果会在监听器中回调|
|extraParameters| Record<string, Object>   | 否      |  预留额外参数|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|TSmartActivatorBuilder| 返回类型为TSmartActivatorBuilder的builer|

### buildBleWifiActivatorBuilder
蓝牙双模设备配网时，调用此方法创建builder
```typescript
buildBleWifiActivatorBuilder(
    homeId: number,
    ssid: string,
    password: string,
    timeout: number = 120000,
    listener: ITSmartActivatorListener,
    token?: TSmartActivatorToken,
    extraParameters?: Record<string, Object>
  ): TSmartActivatorBuilder
```
**参数：**
| 参数名         | 类型                      | 是否必填 | 说明           |
|---------------|--------------------------|---------|----------------|
|homeId         | number                   | 是      |  家庭ID|
|ssid           | string                   | 是      |  WiFi名称|
|password       | string                   | 是      |  WiFi密码|
|timeout        | number                   | 否      |  超时时间，单位毫秒，默认120秒|
|token          | TSmartActivatorToken     | 否      |  通过getActivatorToken获取，如果不传，则内部会通过homeId获取|
|listener       | ITSmartActivatorListener | 是      |  配网监听器，配网结果会在监听器中回调|
|extraParameters| Record<string, Object>   | 否      |  预留额外参数|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|TSmartActivatorBuilder| 返回类型为TSmartActivatorBuilder的builer|


### buildQRCodeActivatorBuilder
IPC类设备扫APP上的二维码配网时，调用此方法创建builder。二维码字符串通过getQRCodeString方法获得。
```typescript
buildQRCodeActivatorBuilder(
    homeId: number,
    ssid: string,
    password: string,
    timeout: number = 120000,
    listener: ITSmartActivatorListener,
    token: TSmartActivatorToken,
    extraParameters?: Record<string, Object>
  ): TSmartActivatorBuilder
```
**参数：**
| 参数名         | 类型                      | 是否必填 | 说明           |
|---------------|--------------------------|---------|----------------|
|homeId         | number                   | 是      |  家庭ID|
|ssid           | string                   | 是      |  WiFi名称|
|password       | string                   | 是      |  WiFi密码|
|timeout        | number                   | 否      |  超时时间，单位毫秒，默认120秒|
|listener       | ITSmartActivatorListener | 是      |  配网监听器，配网结果会在监听器中回调|
|token          | TSmartActivatorToken     | 是      |  通过getActivatorToken获取，注意要与getQRCodeString方法中的token保持一致|
|extraParameters| Record<string, Object>   | 否      |  预留额外参数|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|TSmartActivatorBuilder| 返回类型为TSmartActivatorBuilder的builer|

### getQRCodeString
将ssid、password、token组装成一个字符串，用于生成二维码供IPC类设备扫码配网

```typescript
getQRCodeString(ssid: string, password: string, token: TSmartActivatorToken): string
```
**参数：**
| 参数名         | 类型                      | 是否必填 | 说明           |
|---------------|--------------------------|---------|----------------|
|ssid           | string                   | 是      |  WiFi名称|
|password       | string                   | 是      |  WiFi密码|
|token          | TSmartActivatorToken     | 是      |  通过getActivatorToken获取，注意要与buildQRCodeActivatorBuilder方法中的token保持一致|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|string          | 返回的字符串用于生成二维码|

### buildMQTTDirectlyActivatorBuilder

APP扫设备二维码配网时，调用此方法创建builder。其中的参数uuid是通过二维码解析得到的，调用parseQRCode方法解析。参数token是通过调用getMQTTDirectlyActivatorToken方法获取的。
```typescript
buildMQTTDirectlyActivatorBuilder(
    homeId: number,
    uuid: string,
    timeout: number = 120000,
    listener: ITSmartActivatorListener,
    token?: TSmartActivatorToken,
    extraParameters?: Record<string, Object>
  ): TSmartActivatorBuilder
```

**参数：**
| 参数名         | 类型                      | 是否必填 | 说明           |
|---------------|--------------------------|---------|----------------|
|homeId         | number                   | 是      |  家庭ID|
|uuid           | string                   | 是      |  设备uuid，通过调用parseQRCode方法解析得到|
|timeout        | number                   | 否      |  超时时间，单位毫秒，默认120秒|
|listener       | ITSmartActivatorListener | 是      |  配网监听器，配网结果会在监听器中回调|
|token          | TSmartActivatorToken     | 是      |  通过getMQTTDirectlyActivatorToken获取|
|extraParameters| Record<string, Object>   | 否      |  预留额外参数|

**返回值：**
| 类型            |          说明                          |
|----------------|----------------------------------------|
|TSmartActivatorBuilder| 返回类型为TSmartActivatorBuilder的builer|


### ITSmartActivatorListener
配网监听器

| 名称         | 类型                                       | 是否必填 |                说明           |
|-------------|-------------------------------------------|---------|------------------------------|
|onActiveSetpAndError| (step: TSmartActivatorStep, error?: Error, device?: TSmartDeviceModel) => void | 是      | 配网过程监听方法，当配网过程中有变化或者错误时会回调|
|onActiveSuccess| (deviceModel: TSmartDeviceModel) => void| 是      | 配网成功时会回调|

#### TSmartActivatorStep
```typescript
enum TSmartActivatorStep {
  Start,        // 配网开始
  Found,        // 轮询到设备
  Registered,   // 设备注册
  Initialized,  // 设备激活完成
  TimeOut,      // 配网超时
}
```

### TSmartActivatorError
配网相关错误码，可以根据Error的name判断对应的错误码。
```typescript
enum TSmartActivatorError {
  //   未定义错误
  Unknown = 'UNKNOWN',
  //   参数错误
  ParameterError = 'PARAM_ERROR',
  //   超时
  Timeout = 'TIMEOUT',
  //   配网token错误，没有获取到token
  TokenError = 'TOKEN_ERROR',
  //   蓝牙配网失败
  BleActiveError = 'BLE_ACTIVE_ERROR',
  //   强绑定设备，设备已被绑定
  DeviceAlreadyBind = 'DEVICE_ALREADY_BIND',// 这个值不要动，与云端的错误码对应的
  //   双模配网失败
  BleWifiActiveError = 'BLE_WIFI_ACTIVE_ERROR'
}
```
### appendDevice
添加配网设备，对于蓝牙和双模类型的设备，需要先调用此方法添加待配网设备，再开始配网。
```typescript
appendDevice(...device: Device[]): void
```

### startActive
开始配网
```typescript
startActive(): void
```
### stopActive
停止配网
```typescript
stopActive(): voidd
```

# 2、配网API使用示例
## 2.0、获取配网token
```typescript
// 获取token
this.activatorToken = await TSmartActivatorRequester.getActivatorToken(this.homeId)
```


## 2.1、EZ配网
#### 实现配网监听器中的方法
```typescript
activatorListener: ITSmartActivatorListener = {
    onActiveSetpAndError: (step: TSmartActivatorStep, error?: Error, device?: TSmartDeviceModel) => {
      // 实现相关逻辑
    },

    onActiveSuccess: (deviceModel: TSmartDeviceModel) => {
      // 处理配网成功的逻辑，例如更新UI，跳转到下一个页面
    },
};
```
#### 创建EZ配网实例
```typescript
const activatorBuilder = TSmartActivator.buildEzActivatorBuilder(
          this.ssid,
          this.password,
          120 * 1000,
          this.activatorListener,
          this.homeId,
        )
this.activator = TSmartActivator.createActivator(activatorBuilder);
```

#### 调用开始配网
```typescript
this.activator.startActive()
```

#### 调用停止配网
```typescript
this.activator.stopActive()
```


## 2.2、AP配网

#### 实现配网监听器中的方法
```typescript
activatorListener: ITSmartActivatorListener = {
    onActiveSetpAndError: (step: TSmartActivatorStep, error?: Error, device?: TSmartDeviceModel) => {
      // 实现相关逻辑
    },

    onActiveSuccess: (deviceModel: TSmartDeviceModel) => {
      // 处理配网成功的逻辑，例如更新UI，跳转到下一个页面
    },
};
```
#### 创建AP配网实例
```typescript
const activatorBuilder = TSmartActivator.buildApActivatorBuilder(
            this.ssid,
            this.password,
            120 * 1000,
            this.activatorToken,
            this.activatorListener,
          )
this.activator = TSmartActivator.createActivator(activatorBuilder);
```

#### 调用开始配网
```typescript
this.activator.startActive()
```

#### 调用停止配网
```typescript
this.activator.stopActive()
```

## 2.3、有线设备配网

### 局域网设备扫描
#### 实现扫描结果监听器
```typescript
  scanListener: TSmartScannerListener = {
    onDeviceFound: (scanResult: TSmartScannerResult): void => {
      // 实现相关逻辑
    }
  };
```
#### 构造扫描实例
```typescript
// 使用扫描监听器创建扫描实例
this.scanner = new TSmartScannerBuilder(this.scanListener);
// 设置扫描超时时间和扫描方式
this.scanner.setScanTimeout(120000).addScanMode(TSmartScanMode.SCAN_MODE_LAN);
```
#### 开始扫描
```typescript
this.scanner.startScan();
```
#### 停止扫描
```typescript
this.scanner.stopScan();
```
### 配网

#### 实现配网监听器中的方法
```typescript
activatorListener: ITSmartActivatorListener = {
    onActiveSetpAndError: (step: TSmartActivatorStep, error?: Error, device?: TSmartDeviceModel) => {
      // 实现相关逻辑
    },

    onActiveSuccess: (deviceModel: TSmartDeviceModel) => {
      // 处理配网成功的逻辑，例如更新UI，跳转到下一个页面
    },
};
```
#### 创建有线配网实例
```typescript
const activatorBuilder = TSmartActivator.buildWiredActivatorBuilder(
          this.homeId,
          gwId,
          productId,
          120 * 1000,
          this.activatorListener,
        )
this.activator = TSmartActivator.createActivator(activatorBuilder);
```

#### 调用开始配网
```typescript
this.activator.startActive()
```

#### 调用停止配网
```typescript
this.activator.stopActive()
```


## 2.4、网关子设备配网

#### 实现配网监听器中的方法
```typescript
activatorListener: ITSmartActivatorListener = {
    onActiveSetpAndError: (step: TSmartActivatorStep, error?: Error, device?: TSmartDeviceModel) => {
      // 实现相关逻辑
    },

    onActiveSuccess: (deviceModel: TSmartDeviceModel) => {
      // 处理配网成功的逻辑，例如更新UI，跳转到下一个页面
    },
};
```
#### 创建有线配网实例
```typescript
const activatorBuilder = TSmartActivator.buildSubDeviceActivatorBuilder('网关设备的设备ID', 120000, this.activatorListener);
this.activator = TSmartActivator.createActivator(activatorBuilder);
```

#### 调用开始配网
```typescript
this.activator.startActive()
```

#### 调用停止配网
```typescript
this.activator.stopActive()
```

## 2.5、蓝牙点设备配网

### 蓝牙扫描
#### 实现扫描结果监听器
```typescript
  scanListener: TSmartScannerListener = {
    onDeviceFound: (scanResult: TSmartScannerResult): void => {
      // 实现相关逻辑
    }
  };
```
#### 构造扫描实例
```typescript
// 使用扫描监听器创建扫描实例
this.scanner = new TSmartScannerBuilder(this.scanListener);
// 设置扫描超时时间和扫描方式
this.scanner.setScanTimeout(120000).addScanMode(TSmartScanMode.SCAN_MODE_BLE);
```
#### 开始扫描
```typescript
this.scanner.startScan();
```
#### 停止扫描
```typescript
this.scanner.stopScan();
```
### 配网

#### 实现配网监听器中的方法
```typescript
activatorListener: ITSmartActivatorListener = {
    onActiveSetpAndError: (step: TSmartActivatorStep, error?: Error, device?: TSmartDeviceModel) => {
      // 实现相关逻辑
    },

    onActiveSuccess: (deviceModel: TSmartDeviceModel) => {
      // 处理配网成功的逻辑，例如更新UI，跳转到下一个页面
    },
};
```
#### 创建配网实例
```typescript
const activatorBuilder = TSmartActivator.buildBleActivatorBuilder(homeId, 120000,listener)
this.activator = TSmartActivator.createActivator(activatorBuilder);
// 添加待配网的设备
this.activator.appendDevice(scannedBleDevice)
```

#### 调用开始配网
```typescript
this.activator.startActive()
```

#### 调用停止配网
```typescript
this.activator.stopActive()
```


## 2.6、双模设备配网

### 蓝牙扫描
与单点蓝牙设备相同
### 配网

#### 实现配网监听器中的方法
```typescript
activatorListener: ITSmartActivatorListener = {
    onActiveSetpAndError: (step: TSmartActivatorStep, error?: Error, device?: TSmartDeviceModel) => {
      // 实现相关逻辑
    },

    onActiveSuccess: (deviceModel: TSmartDeviceModel) => {
      // 处理配网成功的逻辑，例如更新UI，跳转到下一个页面
    },
};
```
#### 创建配网实例
```typescript
const activatorBuilder = TSmartActivator.buildBleWifiActivatorBuilder(
                homeId,
                this.ssid,
                this.password,
                120000,
                listener,
              )
this.activator = TSmartActivator.createActivator(activatorBuilder);
// 添加待配网的设备
this.activator.appendDevice(scannedBleDevice)
```

#### 调用开始配网
```typescript
this.activator.startActive()
```

#### 调用停止配网
```typescript
this.activator.stopActive()
```

## 2.7、IPC类设备扫码配网

### 二维码生成与展示
#### 获取二维码字符串
```typescript
this.qrCodeString = TSmartActivator.getQRCodeString(this.ssid, this.password, this.activatorToken)
```
#### 二维码数据生成
```typescript
let content: string = this.qrCodeString;
let options: generateBarcode.CreateOptions = {
  scanType: scanCore.ScanType.QR_CODE,
  height: 400,
  width: 400,
  margin: 1,
  level: generateBarcode.ErrorCorrectionLevel.LEVEL_M,// 默认是LEVEL_H，有的IPC设备识别不了，需要设置成M
  backgroundColor: 0xFFFFFF,
  pixelMapColor: 0x000000
}
try {
  // 码图生成接口，成功返回PixelMap格式图片
  generateBarcode.createBarcode(content, options).then((pixelMap: image.PixelMap) => {
  this.pixelMap = pixelMap;
}).catch((error: BusinessError) => {
  hilog.error(0x0001, '[generateBarcode]',
  `Failed to get PixelMap by promise with options. Code: ${error.code}, message: ${error.message}`);
  })
} catch (error) {
  hilog.error(0x0001, '[generateBarcode]',
  `Failed to createBarcode by promise with options. Code: ${error.code}, message: ${error.message}`);
}
```
#### 二维码展示
二维码用Image展示PixelMap格式的图片，不能用QRCode。QRCode生成的二维码有的IPC设备识别不了。
```typescript
Row() {
  Image(this.pixelMap)
    .width(300)
    .height(300)
    .objectFit(ImageFit.Contain)
}
.margin({ top: 10 })
```

### 配网
#### 实现配网监听器中的方法
```typescript
activatorListener: ITSmartActivatorListener = {
    onActiveSetpAndError: (step: TSmartActivatorStep, error?: Error, device?: TSmartDeviceModel) => {
      // 实现相关逻辑
    },

    onActiveSuccess: (deviceModel: TSmartDeviceModel) => {
      // 处理配网成功的逻辑，例如更新UI，跳转到下一个页面
    },
};
```
#### 创建配网实例
```typescript
const activatorBuilder = TSmartActivator.buildQRCodeActivatorBuilder(
            this.homeId,
            this.ssid,
            this.password,
            120 * 1000,
            this.activatorListener,
            this.activatorToken,
          )
this.activator = TSmartActivator.createActivator(activatorBuilder);
```

#### 调用开始配网
```typescript
this.activator.startActive()
```

#### 调用停止配网
```typescript
this.activator.stopActive()
```

## 2.8、扫设备二维码配网
### 扫码与解析二维码
#### 扫码
```typescript
build() {
    Column() {
      Row() {
        Button("点击扫码")
          .backgroundColor('#0D9FFB')
          .fontSize(20)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Normal)
          .align(Alignment.Center)
          .type(ButtonType.Capsule)
          .width('90%')
          .height(40)
          .margin({ top: 50, bottom: 5 })
          .enabled(this.scanBtnEnable)
          .onClick(() => {
            this.scanBtnEnable = false;
            // 定义扫码参数options
            let options: scanBarcode.ScanOptions = {
              scanTypes: [scanCore.ScanType.ALL],
              enableMultiMode: true,
              enableAlbum: true
            };
            try {
              scanBarcode.startScanForResult(getContext(this), options).then((result: scanBarcode.ScanResult) => {
                // 解析码值结果
                hilog.info(0x0001, '[Scan CPSample]', `Succeeded in getting ScanResult by promise with options, result is ${JSON.stringify(result)}`);
                this.parseQRCode(result['originalValue'] as string);

              }).catch((error: BusinessError) => {
                this.scanBtnEnable = true;
                hilog.error(0x0001, '[Scan CPSample]',
                  `Failed to get ScanResult by promise with options. Code:${error.code}, message: ${error.message}`);
              });
            } catch (error) {
              this.scanBtnEnable = true;
              hilog.error(0x0001, '[Scan CPSample]',
                `Failed to start the scanning service. Code:${error.code}, message: ${error.message}`);
            }
          })
      }

    }
    .width('100%')
  }
```

#### 解析扫描结果
```typescript
  parseQRCode(code: string) {
    TSmartActivatorRequester.parseQRCode(code).then(res => {
      console.log('parseQRCode ', JSON.stringify(code));
      // {"actionData":{"uuid":"dc18219067cf0516"},"actionName":"device_net_conn_multi_ver"}
      if (res['actionName'] === 'device_net_conn_multi_ver') {
        this.uuid = (res['actionData'] as Record<string, string>)['uuid'];
      }
    }).catch((error: Error) => {
      console.log('parseQRCode error');
    })
  }
```

### 配网
#### 实现配网监听器中的方法
```typescript
activatorListener: ITSmartActivatorListener = {
    onActiveSetpAndError: (step: TSmartActivatorStep, error?: Error, device?: TSmartDeviceModel) => {
      // 实现相关逻辑
    },

    onActiveSuccess: (deviceModel: TSmartDeviceModel) => {
      // 处理配网成功的逻辑，例如更新UI，跳转到下一个页面
    },
};
```
#### 创建配网实例
```typescript
    const builder = TSmartActivator.buildMQTTDirectlyActivatorBuilder(homeId, this.uuid!, 120000,this.activatorListener);
    this.activator = TSmartActivator.createActivator(builder);
```

#### 调用开始配网
```typescript
this.activator.startActive()
```

#### 调用停止配网
```typescript
this.activator.stopActive()
```

