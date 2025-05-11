
# homelib 接入指南

## 导入homelib依赖

oh-package.json

```json
"dependencies": {
    "@thingsmart/homeLib": "^0.0.38",
    "@thingsmart/channel": "1.0.1",
    "@thingsmart/mqtt": "2.0.8",
    "@thingsmart/thinglogmodule": "^0.1.1",
    "@thingsmart/dynamicstring": "^1.0.0",
    "@thingsmart/securitykv": "^1.0.0",
    "@ohos/axios": "^2.2.4",
    "@thingsmart/device": "^1.0.2",
    "@thingsmart/userlib": "^1.0.1",
    "class-transformer": "^0.5.1",
    "reflect-metadata": "^0.1.13",
  }
```


# `TSmartHomeManager` 接口文档

## 📌 概述

`TSmartHomeManager` 是家庭管理的核心类，提供以下功能：

- 家庭列表获取与缓存
- 创建、加入家庭
- 接受/拒绝邀请
- 监听家庭变更
- 设置和切换当前家庭
- 清理家庭缓存等操作

---

## 🔧 方法说明

### 1. `getInstance(): TSmartHomeManager`

获取单例实例。

- **用途**：用于创建家庭、获取家庭列表等与当前家庭无关的操作。
- **返回值**：`TSmartHomeManager` 实例。

**实例代码**

```javascript
TSmartHomeManager.getInstance()
```

---


### 2. `registerHomeChangeListener(homeChangeListener: ITSmartHomeChangeListener)`

注册家庭变更监听器。

- **参数**：
  - `homeChangeListener`: 要注册的家庭变更监听器（类型：`ITSmartHomeChangeListener`）。
- **说明**：当家庭信息变化时会触发回调。

**实例代码**

```javascript
 homeChangeListener: ITSmartHomeChangeListener = {

    onHomeAdded: (homeId: number): void => {
      L.d(HomeMQTTPage.TAG, "onHomeAdded - " + homeId);
    },
    onHomeInvite: (homeId: number, homeName: string): void => {
      L.d(HomeMQTTPage.TAG, "onHomeInvite - " + homeId);
    },
    onHomeRemoved: (homeId: number): void => {
      L.d(HomeMQTTPage.TAG, "onHomeRemoved - " + homeId);
    },
    onHomeInfoChanged: (homeId: number): void => {
      L.d(HomeMQTTPage.TAG, "onHomeInfoChanged - " + homeId);

    },
    onHomeShift: (homeId: number, homeName: string): void => {
      L.d(HomeMQTTPage.TAG, "onHomeShift - " + homeId);
    },
    onSharedDeviceList: (sharedDeviceList: TSmartDeviceModel[]): void => {

    },
    onSharedGroupList: (sharedGroupList: ThingSmartGroupModel[]): void => {

    },
    onServerConnectSuccess: (): void => {

    }
    
    TSmartHomeManager.getInstance().registerHomeChangeListener(this.homeChangeListener);

```
---

### 3. `unRegisterHomeChangeListener(homeChangeListener: ITSmartHomeChangeListener)`

取消注册家庭变更监听器。

- **参数**：
  - `homeChangeListener`: 要移除的监听器。

**实例代码**

```javascript
TSmartHomeManager.getInstance().unRegisterHomeChangeListener(this.homeChangeListener);
```

---

### 4. `unRegisterAllHomeChangeListener()`

取消注册所有监听器。

**实例代码**

```javascript
TSmartHomeManager.getInstance().unRegisterAllHomeChangeListener();
```

---

### 5. `getHomeList(): Promise<TSmartAtopResponse<Array<TSmartHomeBean>>>`

异步获取用户所属的所有家庭列表。

- **返回值**：包含家庭数组的响应对象 `TSmartAtopResponse<Array<TSmartHomeBean>>`。


** 实例代码 **：
``` javascript
    let resultData = await TSmartHomeManager.getInstance().getHomeList();
    if (resultData.result !== undefined && resultData.result !== null) {
      console.log("log--->", "queryHomeList = " + resultData.result);
      this.homeBeanList = resultData.result as Array<TSmartHomeBean>;
      this.detailHomeBean = this.homeBeanList[this.homeBeanList.length - 1]
    }
```
---


### 6. `getHomeCacheList(): Array<TSmartHomeBean>`

获取本地缓存的家庭列表。

- **返回值**：家庭数组。
- **说明**：不发起网络请求，直接从缓存读取。


** 实例代码 **：
```javascript

TSmartHomeManager.getInstance().getHomeCacheList()

```

---


### 7. `addHome(params: TSmartCreateHomeDataParams): Promise<TSmartAtopResponse<TSmartHomeBean>>`

创建一个新家庭。

- **参数**：
  - `params`: 创建家庭所需参数，包括名称、城市、经纬度、房间列表等。
- **返回值**：创建结果封装在 `TSmartAtopResponse<TSmartHomeBean>` 中。


** 实例代码 **：
```javascript

const params : TSmartCreateHomeDataParams = {
       "name":"xxx",
       "geoName":"xxx",
       "lon":28.938372995675447,
       "lat":-81.970044345651758,
       "rooms": ["room1","room2"],
       "homeMode": TSmartHomeMode.HOME_MODE_DEFAULT
       }
TSmartHomeManager.getInstance().createHome(params).then(resultData => {
       console.log(HomePage.TAG, "createHome = " + JSON.stringify(resultData.result));
}).catch((error: Error) => {
       console.log(HomePage.TAG, "createHome = " + error.message);
})

```
---



### 8. `createDefaultHome(defaultName: string): Promise<TSmartAtopResponse<TSmartHomeBean>>`

创建默认命名的家庭。

- **参数**：
  - `defaultName`: 默认家庭名。
- **返回值**：创建结果封装在 `TSmartAtopResponse<TSmartHomeBean>` 中。

**实例代码**

```javascript
TSmartHomeManager.getInstance().createDefaultHome('xxxxx').then(resultData => {
       console.log(HomePage.TAG, "create Default Home = " + JSON.stringify(resultData.result));
    }).then(() => {
       console.log(HomePage.TAG, "create Default Home error");
    })

```


---

### 9. `joinHomeWithInvitationCode(invitationCode: string): Promise<TSmartAtopResponse<boolean>>`

使用邀请码加入家庭。

- **参数**：
  - `invitationCode`: 邀请码字符串。
- **返回值**：是否成功加入的结果封装在 `TSmartAtopResponse<boolean>` 中。

**实例代码**

```javascript
TSmartHomeManager.getInstance().joinHomeWithInvitationCode('CKPR6A').then((result) => {
    console.log('家庭加入成功')
}).catch(() => {
    console.log('家庭加入失败')
})

```

---

### 10. `acceptJoinHome(homeId: number): Promise<TSmartAtopResponse<boolean>>`

接受加入某家庭的邀请。

- **参数**：
  - `homeId`: 家庭 ID。
- **返回值**：是否成功接受邀请的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：接受后更新本地缓存状态为已加入。

**实例代码**

```javascript

TSmartHomeManager.getInstance()
                .acceptJoinHome(this.detailHomeBean.homeId)
                .then((result) => {
                  console.log('接受家庭成功')
                }).catch(() => {
                 console.log('接受家庭失败')
              })

```

---

### 11. `rejectJoinHome(homeId: number): Promise<TSmartAtopResponse<boolean>>`

拒绝加入某家庭的邀请。

- **参数**：
  - `homeId`: 家庭 ID。
- **返回值**：是否成功拒绝邀请的结果封装在 `TSmartAtopResponse<boolean>` 中。

**实例代码**

```javascript
TSmartHomeManager.getInstance()
                .rejectJoinHome(this.detailHomeBean.homeId)
                .then((result) => {
                  console.log('拒绝家庭成功')
                }).then(() => {
                console.log('拒绝家庭失败')
              })

```

---

### 12. `getCurrentHomeId(): number | undefined`

获取当前家庭 ID。

- **返回值**：当前家庭 ID 或 `undefined`。

**实例代码**

```javascript
TSmartHomeManager.getInstance().getCurrentHomeId()

```

---

### 13. `getCurrentHome(): TSmartHomeBean | undefined`

获取当前家庭的对象模型。

- **返回值**：当前家庭对象 `TSmartHomeBean` 或 `undefined`。
- **说明**：基于当前家庭 ID 查询本地缓存。

**实例代码**

```javascript
TSmartHomeManager.getInstance().getCurrentHome()
```

---

### 14. `setCurrentHomeId(homeId: number)`

设置当前家庭 ID，并触发回调通知。

- **参数**：
  - `homeId`: 家庭 ID。
- **说明**：设置后会更新缓存并触发家庭切换的消息处理。

**实例代码**

```javascript
TSmartHomeManager.getInstance().setCurrentHomeId(123456)

```

---

### 15. `setupValidHome()`

尝试启动一个有效的家庭。

- **说明**：当当前家庭被其他设备删除或移除成员时，自动选择下一个可用家庭作为当前家庭。

**实例代码**

```javascript
TSmartHomeManager.getInstance().setupValidHome()

```

---

### 16. `clearCurrentHome()`

清除当前家庭的缓存信息。

**实例代码**

```javascript
TSmartHomeManager.getInstance().clearCurrentHome()
```

---

### 17. `onClear()`

清理资源，如消息监听器等。

**实例代码**

```javascript
TSmartHomeManager.getInstance().onClear()
```


# `TSmartHome` 接口文档

## 📌 概述

`TSmartHome` 是用于管理 **特定家庭（通过 homeId）** 的核心类，提供以下功能：

- 家庭详情获取与更新
- 天气信息查询
- 设备/群组管理
- 离开或删除家庭
- 注册监听器处理家庭状态变更
- 数据分阶段加载（Worker 异步处理）

---

## 🔧 方法说明

### 1. `getInstance(homeId: number): TSmartHome`

获取指定家庭 ID 的单例实例。

- **参数**：
  - `homeId`: 家庭 ID。
- **返回值**：`TSmartHome` 实例。
- **用途**：用于操作特定家庭的数据。

**实例代码**

```javascript
TSmartHome.getInstance(12344)

```

---

### 2. `registerHomeStatusListener(listener: ITSmartHomeStatusListener)`

注册家庭状态变化监听器。

- **参数**：
  - `listener`: 监听器对象，实现 `ITSmartHomeStatusListener` 接口。

**实例代码**

```javascript

  homeStatusListener: ITSmartHomeStatusListener = {
    onDeviceAdded: (devId: string): void => {
      L.d(HomeMQTTPage.TAG, "onDeviceAdded - " + devId);
    },
    onDeviceRemoved: (devId: string): void => {
      L.d(HomeMQTTPage.TAG, "onDeviceRemoved - " + devId);
    },
    onGroupAdded: (groupId: string): void => {
      L.d(HomeMQTTPage.TAG, "onGroupAdded - " + groupId);
    },
    onGroupRemoved: (groupId: string): void => {
      L.d(HomeMQTTPage.TAG, "onGroupRemoved - " + groupId);
    },
    onMeshAdded: (meshId: string): void => {

    }
  };


TSmartHome.getInstance(this.homeBean?.homeId!!).registerHomeStatusListener(this.homeStatusListener);

```


---

### 3. `unRegisterHomeStatusListener(listener: ITSmartHomeStatusListener)`

取消注册家庭状态变化监听器。

- **参数**：
  - `listener`: 要移除的监听器。

**实例代码**

```javascript
TSmartHome.getInstance(this.homeBean?.homeId!!).unRegisterHomeStatusListener(this.homeStatusListener);


```

---

### 4. `registerDeviceRoomInfoChangeListener(listener: IThingHomeRoomInfoChangeListener)`

注册设备房间信息变化监听器。

- **参数**：
  - `listener`: 监听器对象，实现 `IThingHomeRoomInfoChangeListener` 接口。

**实例代码**

```javascript

  roomInfoChangeListener: IThingHomeRoomInfoChangeListener = {
    onDeviceRoomInfoChanged: (homeId: number, roomId: number, devId: string, add: boolean): void => {
      L.d(HomeMQTTPage.TAG, 'onDeviceRoomInfoChanged - " + "roomId : ' + roomId + " devId : " + devId + " add : " + add );
    },
    onGroupRoomInfoChanged: (homeId: number, roomId: number, devId: string, add: boolean): void => {

    },
    onRoomAdd: (homeId: number, roomId: number): void => {
      L.d(HomeMQTTPage.TAG, 'onRoomAdd - " + "roomId : ' + roomId );
    },
    onRoomDelete: (homeId: number, roomId: number): void => {
      L.d(HomeMQTTPage.TAG, 'onRoomDelete - " + "roomId : ' + roomId );
    },
    onRoomNameChanged: (homeId: number, roomId: number, name: string): void => {
      L.d(HomeMQTTPage.TAG, 'onRoomNameChanged - " + "roomId : ' + roomId + " name : " + name);
    },
    onRoomOrderChanged: (): void => {
      L.d(HomeMQTTPage.TAG, 'onRoomOrderChanged');
    }
  }

TSmartHome.getInstance(this.homeBean?.homeId!!).registerDeviceRoomInfoChangeListener(this.roomInfoChangeListener);

```


---

### 5. `unRegisterDeviceRoomInfoChangeListener(listener: IThingHomeRoomInfoChangeListener)`

取消注册设备房间信息变化监听器。

- **参数**：
  - `listener`: 要移除的监听器。

**实例代码**

```javascript
TSmartHome.getInstance(this.homeBean?.homeId!!).unRegisterDeviceRoomInfoChangeListener(this.roomInfoChangeListener);

```

---

### 6. `getHomeLocalCache(): Promise<TSmartHomeBean | null>`

异步获取本地缓存的家庭数据。

- **返回值**：家庭信息对象 `TSmartHomeBean` 或 `null`。
- **说明**：如果本地无缓存，则尝试从数据库加载。

**实例代码**

```javascript
TSmartHome.getInstance(this.detailHomeBean.homeId).getHomeLocalCache().then((result) => {
                console.log(HomeSetPage.TAG, "getHomeLocalCache = " + JSON.stringify(result));
              }).catch(() => {
                console.error(HomeSetPage.TAG, "getHomeLocalCache 失败");
              })

```


---

### 7. `getHomeBean(): TSmartHomeBean | null`

直接获取当前家庭的对象模型（不触发网络请求）。

- **返回值**：家庭信息对象 `TSmartHomeBean` 或 `null`。

**实例代码**

```javascript
TSmartHome.getInstance(this.homeBean?.homeId!!).getHomeBean()

```

---

### 8. `deleteHome(): Promise<TSmartAtopResponse<boolean>>`

删除当前家庭。

- **返回值**：删除结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后清除本地缓存。

**实例代码**

```javascript
TSmartHome.getInstance(this.detailHomeBean.homeId).deleteHome().then((result) => {
                  this.showPromote('家庭删除成功')
                  this.loadHomeList()
                }).catch(() => {
                  console.error(HomeSetPage.TAG, "dismissHome 失败");
                })

```

---

### 9. `updateHome(updateHomeInfoParams: TSmartUpdateHomeDataParams): Promise<TSmartAtopResponse<boolean>>`

更新家庭信息。

- **参数**：
  - `updateHomeInfoParams`: 更新参数，包括名称、城市、经纬度等。
- **返回值**：更新结果封装在 `TSmartAtopResponse<boolean>` 中。

**实例代码**

```javascript
const params: TSmartUpdateHomeDataParams = {
                'name': 'fix the home name',
              }
              TSmartHome.getInstance(this.detailHomeBean.homeId).updateHome(params).then((result) => {
                console.log(HomeListPage.TAG, "updateHomeInfo = " + JSON.stringify(result.result));
              }).catch((error: Error) => {
                console.error(HomeListPage.TAG, "updateHomeInfo = " + JSON.stringify(error));
              })

```

---

### 10. `getHomeInfo(): Promise<TSmartAtopResponse<TSmartHomeBean>>`

获取家庭基本信息（如房间、地理位置等）。

- **返回值**：包含家庭信息的响应对象。

**实例代码**

```javascript

   TSmartHome.getInstance(this.detailHomeBean.homeId).getHomeInfo().then((result) => {
                console.log(HomeSetPage.TAG, "getHomeInfo = " + JSON.stringify(result));
              }).catch(() => {
                console.error(HomeSetPage.TAG, "getHomeInfo 失败");
              })

```

---

### 11. `getHomeDetail(callback: (homeBean?: TSmartHomeBean) => void)`

获取家庭详细信息（包括设备、群组等）。

- **参数**：
  - `callback`: 获取到家庭数据后的回调函数。

**实例代码**

```javascript

 TSmartHome.getInstance(homeId).getHomeDetail((homeBean?: TSmartHomeBean) => {
      //获取详情
      console.log(HomeSetPage.TAG, "getHomeDetail = " + JSON.stringify(homeBean));
}.catch(() => {
})

```

---

### 12. `getCityInfo(lon?: number, lat?: number): Promise<TSmartAtopResponse<TSmartCityBean>>`

根据经纬度获取城市信息。

- **参数**：
  - `lon`: 经度（可选）
  - `lat`: 纬度（可选）
- **返回值**：城市信息封装在 `TSmartAtopResponse<TSmartCityBean>` 中。

**实例代码**

```javascript
TSmartHome.getInstance(this.detailHomeBean.homeId).getCityInfo(117.17,39.17).then((result) => {
                this.showPromote('获取城市信息成功')
              }).catch(() => {
                this.showPromote('获取城市信息失败')
              })

```

---

### 13. `getHomeWeatherSketch(lon?: number, lat?: number): Promise<TSmartAtopResponse<TSmartWeatherSketchBean>>`

获取家庭天气概览信息。

- **参数**：
  - `lon`: 经度（可选）
  - `lat`: 纬度（可选）
- **返回值**：天气概览信息封装在 `TSmartAtopResponse<TSmartWeatherSketchBean>` 中。

**实例代码**

```javascript
TSmartHome.getInstance(this.detailHomeBean.homeId).getHomeWeatherSketch(117.17,39.17).then((result) => {
                this.weatherBean = result.result as TSmartWeatherSketchBean;
                this.showPromote('获取天气成功')
              }).catch(() => {
                console.error(HomeListPage.TAG, "getHomeWeatherSketch 失败");
              })

```

---

### 14. `getHomeWeatherDetail(optionParams: TSmartWeatherOptionParams): Promise<TSmartAtopResponse<TSmartWeatherBean[]>>`

获取家庭天气详细信息。

- **参数**：
  - `optionParams`: 查询天气的参数对象。
- **返回值**：天气详细信息封装在 `TSmartAtopResponse<Array<TSmartWeatherBean>>` 中。

**实例代码**

```javascript
const params:TSmartWeatherOptionParams = {
                'pressureUnit': TSmartWeatherOptionPressureUnit.WEATHER_OPTION_PRESSURE_UNIT_HPA,
                'windspeedUnit': TSmartWeatherOptionWindSpeedUnit.WEATHER_OPTION_WIND_SPEED_UNIT_KM_H,
                'temperatureUnit': TSmartWeatherOptionTemperatureUnit.WEATHER_OPTION_TEMPERATURE_UNIT_CENTIGRADE,
                'limit': 100,
                'lat': 39.17,
                'lon': 117.17
              }
              TSmartHome.getInstance(this.detailHomeBean.homeId).getHomeWeatherDetail(params).then((result) => {
                console.log("Joe--->", "getHomeWeatherDetail = " + JSON.stringify(result))
                this.showPromote('获取天气详情成功')
              }).catch(() => {
                this.showPromote('获取天气详情失败')
                console.error(HomeListPage.TAG, "getHomeWeatherDetail 失败");
              })
```


---

### 15. `leaveHome(memberId: number): Promise<TSmartAtopResponse<boolean>>`

离开当前家庭。

- **参数**：
  - `memberId`: 成员 ID。
- **返回值**：是否成功离开的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后清除本地缓存。

**实例代码**

```javascript
TSmartHome.getInstance(this.detailHomeBean.homeId)
                .leaveHome(this.deleteMemberId)
                .then((result) => {
                  this.showPromote('离开家庭成功')
                }).catch( () => {
                this.showPromote('离开家庭失败')
              })

```

---

### 16. `sortDeviceOrGroup(devBeanList: DeviceAndGroupInHomeParams[]): Promise<TSmartAtopResponse<boolean>>`

对家庭中的设备和群组进行排序。

- **参数**：
  - `devBeanList`: 排序参数列表。
- **返回值**：是否排序成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**实例代码**

```javascript
let updateParamsList:Array<DeviceAndGroupInHomeParams> = new Array<DeviceAndGroupInHomeParams>();
              let reserveDeviceList = this.deviceList.reverse()
              for (const element of reserveDeviceList) {
                const deviceParams: DeviceAndGroupInHomeParams = {
                  'bizId': element.devId,
                  'bizType': TSmartHomeResBizType.DEVICE,
                }
                updateParamsList.push(deviceParams)
              }
              TSmartHome.getInstance(this.detailHomeBean.homeId).sortDeviceOrGroup(updateParamsList)
                .then((result) => {
                  console.log(HomeDevicePage.TAG, 'sortDevInHome:  ' +JSON.stringify(result.result));
                }).catch((error: Error) => {
                console.error(HomeDevicePage.TAG,'sortDevInHome error')
              })

```

---

### 17. `getDiyHomeHiddenItems(): Promise<TSmartAtopResponse<Array<DeviceAndGroupSortedBean>>>`

获取隐藏的设备和群组列表。

- **返回值**：隐藏项列表封装在 `TSmartAtopResponse<Array<DeviceAndGroupSortedBean>>` 中。

**实例代码**

```javascript
TSmartHome.getInstance(detailHomeId).getDiyHomeHiddenItems()
      .then((result) => {
        if (result.result) {
          this.hiddenDeviceList = result.result;
        }

      }).catch(() => {
        console.error(HomeDevicePage.TAG, 'get room list error');
    })

```

---

### 18. `updateDiyHomeItems(params: ModifyDeviceOrGroupHiddenParams): Promise<TSmartAtopResponse<boolean>>`

更新家庭中隐藏的设备或群组列表。

- **参数**：
  - `params`: 修改参数对象。
- **返回值**：是否修改成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**实例代码**

```javascript
TSmartHome.getInstance(this.detailHomeBean.homeId).updateDiyHomeItems(params)
                      .then((result) => {
                        this.showPromote('修改成功')
                        this.loadHomeHiddenDeviceList()
                      }).catch((error: Error) => {
                      this.showPromote('修改失败')
                    });

```

---

### 19. `clearAllCache()`

清除所有相关的缓存数据。

- **说明**：包括家庭消息、房间、设备、关系缓存等。

**实例代码**

```javascript
TSmartHome.getInstance(this.detailHomeBean.homeId).clearAllCache()
```

---



# `TSmartHomeDataManager` 接口文档

## 📌 概述

`TSmartHomeDataManager` 是用于管理家庭与设备、房间等数据关系的核心类。它主要负责：

- 获取家庭模型
- 获取设备模型
- 管理家庭中的设备列表
- 查询房间信息

该类采用单例模式，确保全局访问一致性。

---

## 🔧 方法说明

### 1. `getInstance(): TSmartHomeDataManager`

获取 `TSmartHomeDataManager` 的单例实例。

- **返回值**：`TSmartHomeDataManager` 实例。

**实例代码**

```javascript
TSmartHomeDataManager.getInstance()

```

---

### 2. `getHomeModel(homeId: number)`

获取指定家庭 ID 的家庭模型。

- **参数**：
  - `homeId`: 家庭 ID。
- **返回值**：家庭对象模型（`TSmartHomeBean`）。

**实例代码**

```javascript
TSmartHomeDataManager.getInstance().getHomeModel(111)
```

---

### 3. `addDevToHome(mDevModel: TSmartDeviceModel, homeId: number)`

将设备添加到指定家庭中。

- **参数**：
  - `mDevModel`: 设备模型对象，类型为 `TSmartDeviceModel`。
  - `homeId`: 家庭 ID。
- **说明**：通过缓存管理器更新家庭设备关系。

**实例代码**

```javascript
TSmartHomeDataManager.getInstance().addDevToHome(new TSmartDeviceModel(),homeId)

```

---

### 4. `getHomeDeviceModel(mDevId: string): Promise<TSmartHomeDeviceModel | undefined>`

根据设备 ID 获取家庭设备模型。

- **参数**：
  - `mDevId`: 设备 ID 字符串。
- **返回值**：一个 `Promise`，解析后返回 `TSmartHomeDeviceModel` 或 `undefined`。
- **异常处理**：
  - 如果设备 ID 无效或未找到设备，会触发 `reject`。

**实例代码**

```javascript
 TSmartHomeDataManager.getInstance().getHomeDeviceModel(homeId).then((model) => {
          if (model === undefined) {
                    resolve([]);
                    return
                }
            }).catch((error) => {
                reject(error);
            })

```

---

### 5. `getHomeDeviceList(homeId: number): Promise<Array<TSmartDeviceModel>>`

异步获取指定家庭下的所有设备列表。

- **参数**：
  - `homeId`: 家庭 ID。
- **返回值**：包含设备模型的数组 `Array<TSmartDeviceModel>`。

**实例代码**

```javascript
  TSmartHomeDataManager.getInstance().getHomeDeviceList(homeId).then((devList) => {
                if (devList === undefined || devList.length === 0) {
                    resolve([]);
                    return
                }
            }).catch((error) => {
                reject(error);
            })

```

---

### 6. `getDeviceModel(devId: string): Promise<TSmartHomeDeviceModel | undefined>`

获取指定设备 ID 的设备模型。

- **参数**：
  - `devId`: 设备 ID。
- **返回值**：设备模型对象 `TSmartHomeDeviceModel` 或 `undefined`。

**实例代码**

```javascript
TSmartHomeDataManager.getInstance().getDeviceModel("")

```

---

### 7. `getRoomBean(roomId: number)`

获取指定房间 ID 的房间模型。

- **参数**：
  - `roomId`: 房间 ID。
- **返回值**：房间模型对象。

**实例代码**

```javascript
 TSmartHomeDataManager.getInstance().getRoomBean(1222)

```


# `TSmartRoom` 接口文档

## 📌 概述

`TSmartRoom` 是用于管理家庭中房间信息的核心类，提供以下功能：

- 房间增删改查
- 设备/群组与房间绑定关系管理
- 房间排序
- 房间标签管理
- 房间快照获取

该类采用单例模式，通过指定 `homeId` 获取对应实例。

---

## 🔧 方法说明

### 1. `getInstance(homeId: number): TSmartRoom`

获取指定家庭 ID 的房间管理实例。

- **参数**：
  - `homeId`: 家庭 ID。
- **返回值**：`TSmartRoom` 实例。

**实例代码**

```javascript
TSmartRoom.getInstance(12222)

```

---

### 2. `addRoom(createRoomParams: TSmartCreateRoomParams): Promise<TSmartAtopResponse<TSmartRoomBean>>`

添加一个房间。

- **参数**：
  - `createRoomParams`: 创建房间所需的参数（如名称、标签 ID 等）。
- **返回值**：创建结果封装在 `TSmartAtopResponse<TSmartRoomBean>` 中。
- **说明**：成功后更新缓存中的房间列表。

**实例代码**

```javascript
const params: TSmartCreateRoomParams = {
                'name': 'Joe',
                'background': ''
              }
              TSmartRoom.getInstance(this.detailHomeBean.homeId).addRoom(params).then((result) => {
                this.showPromote('创建成功');
              }).catch(() => {
                this.showPromote('创建失败');
              });
```

---

### 3. `addRoomWithName(roomName: string): Promise<TSmartAtopResponse<TSmartRoomBean>>`

仅通过名称创建房间。

- **参数**：
  - `roomName`: 房间名称。
- **返回值**：创建结果封装在 `TSmartAtopResponse<TSmartRoomBean>` 中。

**实例代码**

```javascript
TSmartRoom.getInstance(this.detailHomeBean.homeId).addRoomWithName('haotian').then((result) => {
                this.showPromote('创建成功');
              }).catch(() => {
                this.showPromote('创建失败');
              })
```

---

### 4. `removeRoom(roomId: number): Promise<TSmartAtopResponse<boolean>>`

删除指定 ID 的房间。

- **参数**：
  - `roomId`: 房间 ID。
- **返回值**：是否删除成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后清除本地缓存。

**实例代码**

```javascript
let roomBeanList = this.detailHomeBean.rooms as TSmartRoomBean[];
              if (roomBeanList.length > 0) {
                let roomBean = this.roomBean;
                TSmartRoom.getInstance(this.detailHomeBean.homeId).removeRoom(roomBean.roomId);
              }

```

---

### 5. `updateRoomName(roomId: number, roomName: string): Promise<TSmartAtopResponse<boolean>>`

修改房间名称。

- **参数**：
  - `roomId`: 房间 ID。
  - `roomName`: 新房间名称。
- **返回值**：是否修改成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后更新本地缓存中的房间名。

**实例代码**

```javascript
let roomBean = this.roomBean;
              let randomInt = this.getRandomInt(0, 100000);
              TSmartRoom.getInstance(this.detailHomeBean.homeId)
                .updateRoomName(roomBean.roomId, 'xxxmmm--' + randomInt.toString())
                .then((result) => {
                  this.showPromote('修改成功')
                })
                .catch(() => {
                  this.showPromote('修改失败');
                });
```

---

### 6. `getRoomList(): Promise<Array<TSmartRoomBean>>`

获取当前家庭下的所有房间列表。

- **返回值**：房间对象数组 `Array<TSmartRoomBean>`。
- **异常处理**：失败时抛出错误。

**实例代码**

```javascript
 let detailHomeId = this.detailHomeBean.homeId as number
    TSmartRoom.getInstance(detailHomeId).getRoomList().then((result) => {
      console.log("Joe--->", "getRoomList = " + JSON.stringify(result))
      this.detailHomeBean.rooms = result as Array<TSmartRoomBean>;
      if (this.detailHomeBean.rooms !== undefined && this.detailHomeBean.rooms.length > 0) {
        this.deleteRoomText = "删除最后一个房间"
      }
    }).catch(() => {

    })
```

---

### 7. `getDefaultRoomList(): Promise<TSmartAtopResponse<Array<TSmartDefaultRoomBean>>>`

获取默认房间列表。

- **返回值**：默认房间列表封装在 `TSmartAtopResponse<Array<TSmartDefaultRoomBean>>` 中。

**实例代码**

```javascript
TSmartRoom.getInstance(this.detailHomeBean.homeId).getDefaultRoomList()
                .then((result) => {
                  this.showPromote('获取默认房间列表成功')
                }).catch(() => {
                this.showPromote('获取默认房间列表失败')
              })
```

---

### 8. `getRecommenRoomList(): Promise<TSmartAtopResponse<Array<TSmartRecommendRoomBean>>>`

获取推荐房间列表。

- **返回值**：推荐房间列表封装在 `TSmartAtopResponse<Array<TSmartRecommendRoomBean>>` 中。

**实例代码**

```javascript
TSmartRoom.getInstance(this.detailHomeBean.homeId).getRecommenRoomList().then((result) => {
                this.showPromote('获取成功');
              }).catch(() => {
                this.showPromote('获取失败');
              })
```

---

### 9. `sortRoomList(roomIdList: Array<number>): Promise<TSmartAtopResponse<boolean>>`

对房间进行排序。

- **参数**：
  - `roomIdList`: 房间 ID 列表。
- **返回值**：是否排序成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后更新本地缓存中的房间顺序。

**实例代码**

```javascript
let roomBeanList = this.detailHomeBean.rooms as TSmartRoomBean[];
              if (roomBeanList.length > 0) {
                let roomIds: Array<number> = new Array<number>();
                for (const element of roomBeanList.reverse()) {
                  roomIds.push(element.roomId);
                }
                let roomBean = roomBeanList[roomBeanList.length - 1] as TSmartRoomBean;
                TSmartRoom.getInstance(this.detailHomeBean.homeId)
                  .sortRoomList(roomIds)
                  .then((result) => {
                    this.showPromote('修改成功')
                  })
                  .catch(() => {
                    this.showPromote('修改失败');
                  });
              }
```

---

### 10. `saveBatchRoomRelation(roomId: number, relationList: Array<TSmartSortRoomRelationParams>): Promise<TSmartAtopResponse<boolean>>`

批量保存房间内设备或群组的归属关系。

- **参数**：
  - `roomId`: 房间 ID。
  - `relationList`: 设备或群组归属关系参数列表。
- **返回值**：是否保存成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后更新缓存并设置设备显示顺序。

**实例代码**

```javascript

 let saveBatchDevList: TSmartSortRoomRelationParams[] = []

      this.beanAddDeviceIds.forEach(deviceId => {
        if (deviceId.length > 0) {
          saveBatchDevList.push({
            id: deviceId,
            type: TSmartHomeResBizType.DEVICE
          })
        }
      })

      if (saveBatchDevList.length > 0) {
        TSmartRoom.getInstance(this.homeId)
        let req = await TSmartRoom.getInstance(this.homeId).saveBatchRoomRelation(this.roomId, saveBatchDevList)
        if (req.result) {
          L.i('RoomDeviceViewModel', JSON.stringify(req))
        }else {
          L.e('RoomDeviceViewModel', JSON.stringify(req))
        }
      }

    } catch (e) {
      L.e('saveBatchRoomDevice', JSON.stringify(e))
    }


```

---

### 11. `addDevice(roomId: number, devId: string): Promise<TSmartAtopResponse<boolean>>`

将设备加入房间。

- **参数**：
  - `roomId`: 房间 ID。
  - `devId`: 设备 ID。
- **返回值**：是否添加成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后更新缓存。

**实例代码**

```javascript
 TSmartRoom.getInstance(this.detailHomeBean.homeId).addDevice(this.roomBean.roomId, '10001').then(
                (result) => {
                  this.showPromote('添加设备成功')
                }
              ).catch((result) => {
                this.showPromote('添加设备失败')
              })

```

---

### 12. `removeDevice(roomId: number, devId: string): Promise<TSmartAtopResponse<boolean>>`

从房间中移除设备。

- **参数**：
  - `roomId`: 房间 ID。
  - `devId`: 设备 ID。
- **返回值**：是否移除成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后更新缓存。

**实例代码**

```javascript
  TSmartRoom.getInstance(this.detailHomeBean.homeId).removeDevice(11111,'xxx').then((result) => {
                this.showPromote('删除设备成功')
              }).catch(() => {
                this.showPromote('删除设备失败')
              })

```

---


---

### 15. `fetchRoomSnapshop(roomId: number): Promise<TSmartAtopResponse<TSmartDiyHomeRoomSnapshotBean>>`

获取房间快照数据。

- **参数**：
  - `roomId`: 房间 ID。
- **返回值**：房间快照信息封装在 `TSmartAtopResponse<TSmartDiyHomeRoomSnapshotBean>` 中。

**实例代码**

```javascript
TSmartRoom.getInstance(this.detailHomeBean.homeId).fetchRoomSnapshop(this.currentRoom.roomId)
                .then((result) => {
                  this.showPromote('成功');

                }).catch((error: Error) => {
                this.showPromote('失败');
              });

```

---

### 16. `getRoomTagList(): Promise<TSmartAtopResponse<Array<TSmartRoomTagBean>>>`

获取房间标签列表。

- **返回值**：标签列表封装在 `TSmartAtopResponse<Array<TSmartRoomTagBean>>` 中。

**实例代码**

```javascript
let detailHomeId = this.detailHomeBean.homeId as number
    TSmartRoom.getInstance(detailHomeId).getRoomTagList().then((result) => {
      this.roomTagBeanList = result.result as Array<TSmartRoomTagBean>;
    }).catch(() => {

    })

```

---

### 17. `createRoomTag(roomTagName: string): Promise<TSmartAtopResponse<boolean>>`

创建房间标签。

- **参数**：
  - `roomTagName`: 标签名。
- **返回值**：是否创建成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**实例代码**

```javascript
let randomInt = this.getRandomInt(0, 100000);
              TSmartRoom.getInstance(this.detailHomeBean.homeId).createRoomTag('Haotian' + randomInt.valueOf())
                .then((result) => {
                  this.getRoomTagList();
                }).catch(() => {
                  this.showPromote('操作失败');
              })

```

---

### 18. `deleteRoomTag(roomTagId: number): Promise<TSmartAtopResponse<boolean>>`

删除房间标签。

- **参数**：
  - `roomTagId`: 标签 ID。
- **返回值**：是否删除成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**实例代码**

```javascript
if (this.roomTagBean.roomTagId) {
                TSmartRoom.getInstance(this.detailHomeBean.homeId).deleteRoomTag(this.roomTagBean.roomTagId)
                  .then((result) => {
                    this.getRoomTagList();
                  }).catch( () => {
                    this.showPromote('操作失败')
                })
              }

```

---

### 19. `updateRoomTagName(roomTagId: number, roomTagName: string): Promise<TSmartAtopResponse<boolean>>`

修改房间标签名称。

- **参数**：
  - `roomTagId`: 标签 ID。
  - `roomTagName`: 新标签名称。
- **返回值**：是否修改成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
**实例代码**

```javascript
let roomTagBean = this.roomTagBean;
              let randomInt = this.getRandomInt(0, 100000);
              TSmartRoom.getInstance(this.detailHomeBean.homeId)
                .updateRoomTagName(roomTagBean.roomTagId, "haotianTag" + randomInt.valueOf())
                .then((result) => {
                  this.getRoomTagList();
                }).catch(() => {
                this.showPromote('操作失败')
              })
```

---

### 20. `sortRoomTagIds(roomTagIds: Array<number>): Promise<TSmartAtopResponse<boolean>>`

对房间标签进行排序。

- **参数**：
  - `roomTagIds`: 标签 ID 列表。
- **返回值**：是否排序成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
**实例代码**

```javascript
let roomTagBeanList = this.roomTagBeanList as TSmartRoomTagBean[];
              if (roomTagBeanList.length > 0) {
                let roomTagIds: Array<number> = new Array<number>();
                for (const element of roomTagBeanList.reverse()) {
                  roomTagIds.push(element.roomTagId);
                }
                TSmartRoom.getInstance(this.detailHomeBean.homeId)
                  .sortRoomTagIds(roomTagIds)
                  .then((result) => {
                    this.getRoomTagList()
                  }).catch(() => {
                  this.showPromote('操作失败')
                })
              }
```

---

### 21. `getRoomTagRelationship(): Promise<TSmartAtopResponse<TSmartRoomTagListRelationBean>>`

获取房间与标签的关联关系。

- **返回值**：关联关系封装在 `TSmartAtopResponse<TSmartRoomTagListRelationBean>` 中。
**实例代码**

```javascript
 TSmartRoom.getInstance(this.detailHomeBean.homeId)
                .getRoomTagRelationship()
                .then((result) => {
                  console.log(JSON.stringify(result));
                }).catch(() => {
                  this.showPromote('操作失败');
              })
```

---

### 22. `manageRoomTagRelationship(roomRelationship: Map<number, Array<number>>, roomTagIds: Array<number>): Promise<TSmartAtopResponse<boolean>>`

更新房间与标签的关联关系。

- **参数**：
  - `roomRelationship`: 房间与标签的关系映射。
  - `roomTagIds`: 标签 ID 列表。
- **返回值**：是否操作成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
**实例代码**

```javascript
let newRoomTagMap = new Map<number,Array<number>>();
              let roomTagIdList = new Array<number>();

              let roomIdList = new Array<number>();
              roomTagIdList.push(this.roomTagBean.roomTagId);

              roomIdList.push(this.roomBean.roomId);
              newRoomTagMap.set(this.roomTagBean.roomTagId,roomIdList);

              TSmartRoom.getInstance(this.detailHomeBean.homeId)
                .manageRoomTagRelationship(newRoomTagMap,roomTagIdList)
                .then((result) => {
                  console.log(JSON.stringify(result));
                }).catch(() => {
                this.showPromote('操作失败');
              })
```

---

### 23. `addRoomWithNameAndTag(roomName: string, roomTagId: number): Promise<TSmartAtopResponse<TSmartRoomBean>>`

通过名称和标签创建房间。

- **参数**：
  - `roomName`: 房间名称。
  - `roomTagId`: 标签 ID。
- **返回值**：创建结果封装在 `TSmartAtopResponse<TSmartRoomBean>` 中。
**实例代码**

```javascript
TSmartRoom.getInstance(this.detailHomeBean.homeId)
                .addRoomWithNameAndTag("haotianTag",this.roomTagBean.roomTagId)
                .then((result) => {
                  this.getRoomTagList();
                }).catch(() => {
                  this.showPromote('操作失败');
              });

```

---

### 24. `getRoomDevList(roomId: number): Promise<Array<TSmartDeviceModel>>`

获取房间内的设备列表。

- **参数**：
  - `roomId`: 房间 ID。
- **返回值**：设备模型数组 `Array<TSmartDeviceModel>`。
- **说明**：按设备显示顺序排序。
**实例代码**

```javascript

```


---

### 26. `sortRoomRelation(roomId: number, relationList: Array<TSmartSortRoomRelationParams>): Promise<TSmartAtopResponse<boolean>>`

对房间内的设备或群组进行排序。

- **参数**：
  - `roomId`: 房间 ID。
  - `relationList`: 排序参数列表。
- **返回值**：是否排序成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后更新设备显示顺序。
**实例代码**

```javascript
let roomRelation1 : TSmartSortRoomRelationParams = {
                roomTagId: 111,
                name:  "haotianTag"
              }

              TSmartRoom.getInstance(this.detailHomeBean.homeId).sortRoomRelation(111,[roomRelation1]).then(
                (result) => {
                  console.log(JSON.stringify(result));
                }
              ).catch(() => {
                this.showPromote('操作失败');
              })

```

---

### 27. `addRoomRelation(roomId: number, relationList: Array<TSmartSortRoomRelationParams>): Promise<TSmartAtopResponse<boolean>>`

新增房间内的设备或群组关系。

- **参数**：
  - `roomId`: 房间 ID。
  - `relationList`: 关系参数列表。
- **返回值**：是否添加成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：成功后更新缓存并设置设备显示顺序。
**实例代码**

```javascript
TSmartRoom.getInstance(this.detailHomeBean.homeId).getRoomDevList(111).then(
                (result) => {
                  console.log(JSON.stringify(result));
                }
              ).catch(() => {
                this.showPromote('操作失败');
              })

```

---



# `TSmartMember` 接口文档

## 📌 概述

`TSmartMember` 是用于管理家庭成员的核心类，提供以下功能：

- 成员增删改查
- 权限管理（房间、场景）
- 家庭邀请与接受/拒绝
- 成员角色绑定
- 成员设备权限管理
- 转移家庭所有权

该类采用单例模式，确保全局访问一致性。

---

## 🔧 方法说明

### 1. `static getInstance(): TSmartMember`

获取 `TSmartMember` 的单例实例。

- **返回值**：`TSmartMember` 实例。

**示例代码：**

```javascript
TSmartMember.getInstance()
```

---

### 2. `addMember(requestParams: AddMemberRequestParams): Promise<TSmartAtopResponse<number>>`

添加新成员到家庭。

- **参数**：
  - `requestParams`: 添加成员所需的参数。
- **返回值**：添加结果封装在 `TSmartAtopResponse<number>` 中。

**示例代码：**

```javascript
const params: AddMemberRequestParams = {
     homeId: this.homeBean?.homeId ?? 0,
     name: "测试成员-" + util.generateRandomUUID(),
     role: TSmartHomeRoleType.HOME_ROLE_TYPE_MEMBER,
     autoAccept: false
}
await TSmartMember.getInstance().addMember(params);
```

---

### 3. `updateMember(requestParams: MemberRequestParams): Promise<TSmartAtopResponse<boolean>>`

更新成员基本信息（不包括昵称）。

- **参数**：
  - `requestParams`: 更新参数。
- **返回值**：是否更新成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
const params: MemberRequestParams = {
  homeId: this.homeBean?.homeId ?? 0,
  memberId: member?.memberId ?? 0,
  name: "修改测试-" + util.generateRandomUUID(),
  role: member?.role ?? TSmartHomeRoleType.HOME_ROLE_TYPE_MEMBER,
}
await TSmartMember.getInstance().updateMember(params);
```

---

### 4. `static updateMemberName(memberId: number, name: string): Promise<TSmartAtopResponse<boolean>>`

更新成员的备注名称。

- **参数**：
  - `memberId`: 成员 ID。
  - `name`: 新名称。
- **返回值**：是否更新成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().updateMemberName(member?.memberId, "修改成员名称");
```

---

### 5. `removeMember(memberId: number): Promise<TSmartAtopResponse<boolean>>`

将指定成员从其所属家庭中移除。

- **参数**：
  - `memberId`: 成员 ID。
- **返回值**：是否移除成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().removeMember(member?.memberId);
```

---

### 6. `getMemberList(homeId: number): Promise<TSmartAtopResponse<Array<TSmartHomeMemberBean>>>`

获取指定家庭下的所有成员列表。

- **参数**：
  - `homeId`: 家庭 ID。
- **返回值**：成员对象数组封装在 `TSmartAtopResponse<Array<TSmartHomeMemberBean>>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().removeMember(member?.memberId);
```

---

### 7. `getMemberDeviceList(memberId: number): Promise<TSmartAtopResponse<Record<string, Object>>>`

获取指定成员关联的设备权限信息。

- **参数**：
  - `memberId`: 成员 ID。
- **返回值**：设备权限信息封装在 `TSmartAtopResponse<Record<string, Object>>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().getMemberList(this.homeBean.homeId);
```

---

### 8. `getAuthRoomList(homeId: number, memberId: number): Promise<TSmartAtopResponse<Array<RoomAuthBean>>>`

获取成员对当前家庭下各房间的授权状态。

- **参数**：
  - `homeId`: 家庭 ID。
  - `memberId`: 成员 ID。
- **返回值**：房间授权信息封装在 `TSmartAtopResponse<Array<RoomAuthBean>>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().getAuthRoomList(this.homeBean.homeId, member?.memberId);
```

---

### 9. `saveAuthRoomList(homeId: number, memberId: number, rooms: Array<number>): Promise<TSmartAtopResponse<boolean>>`

保存成员对某些房间的授权状态。

- **参数**：
  - `homeId`: 家庭 ID。
  - `memberId`: 成员 ID。
  - `rooms`: 房间 ID 列表。
- **返回值**：是否操作成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().saveAuthRoomList(this.homeBean.homeId, member?.memberId, [roomId]);
```

---

### 10. `getAuthSceneList(homeId: number, memberId: number): Promise<TSmartAtopResponse<Array<SceneAuthBean>>>`

获取成员对当前家庭下各场景的授权状态。

- **参数**：
  - `homeId`: 家庭 ID。
  - `memberId`: 成员 ID。
- **返回值**：场景授权信息封装在 `TSmartAtopResponse<Array<SceneAuthBean>>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().getAuthSceneList(this.homeBean.homeId, member?.memberId);
```

---

### 11. `saveAuthSceneList(homeId: number, memberId: number, ruleIds: Array<string>): Promise<TSmartAtopResponse<boolean>>`

保存成员对某些场景的授权状态。

- **参数**：
  - `homeId`: 家庭 ID。
  - `memberId`: 成员 ID。
  - `ruleIds`: 场景规则 ID 列表。
- **返回值**：是否操作成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().saveAuthSceneList(this.homeBean.homeId, member?.memberId, [ruleId]);
```

---

### 12. `addMemberAccountRole(requestParams: MemberAccountRoleReqParams): Promise<TSmartAtopResponse<boolean>>`

为成员绑定账号角色权限。

- **参数**：
  - `requestParams`: 绑定参数。
- **返回值**：是否绑定成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
const params: MemberAccountRoleReqParams = {
  id: member?.memberId ?? 0,
  countryCode: "86",
  userAccount: member?.userName ?? "",
  role: TSmartHomeRoleType.HOME_ROLE_TYPE_ADMIN
}
await TSmartMember.getInstance().addMemberAccountRole(params);
```

---

### 13. `acceptHomeInvitation(homeId: number, accept: boolean): Promise<TSmartAtopResponse<boolean>>`

接受或拒绝加入家庭的邀请。

- **参数**：
  - `homeId`: 家庭 ID。
  - `accept`: 是否接受邀请。
- **返回值**：是否操作成功的结果封装在 `TSmartAtopResponse<boolean>` 中。
- **说明**：接受后更新本地缓存；拒绝则清除家庭缓存。

# `TSmartMember` 接口文档

## 📌 概述

`TSmartMember` 是用于管理家庭成员的核心类，提供以下功能：

- 成员增删改查
- 权限管理（房间、场景）
- 家庭邀请与接受/拒绝
- 成员角色绑定
- 成员设备权限管理
- 转移家庭所有权

该类采用单例模式，确保全局访问一致性。

---

## 🔧 方法说明

### 1. `static getInstance(): TSmartMember`

获取 `TSmartMember` 的单例实例。

- **返回值**：`TSmartMember` 实例。

**示例代码：**

```javascript
TSmartMember.getInstance()
```

---

### 2. `addMember(requestParams: AddMemberRequestParams): Promise<TSmartAtopResponse<number>>`

添加新成员到家庭。

- **参数**：
  - `requestParams`: 添加成员所需的参数。
- **返回值**：添加结果封装在 `TSmartAtopResponse<number>` 中。

**示例代码：**

```javascript
const params: AddMemberRequestParams = {
     homeId: this.homeBean?.homeId ?? 0,
     name: "测试成员-" + util.generateRandomUUID(),
     role: TSmartHomeRoleType.HOME_ROLE_TYPE_MEMBER,
     autoAccept: false
}
await TSmartMember.getInstance().addMember(params);
```

---

### 3. `updateMember(requestParams: MemberRequestParams): Promise<TSmartAtopResponse<boolean>>`

更新成员基本信息（不包括昵称）。

- **参数**：
  - `requestParams`: 更新参数。
- **返回值**：是否更新成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
const params: MemberRequestParams = {
  homeId: this.homeBean?.homeId ?? 0,
  memberId: member?.memberId ?? 0,
  name: "修改测试-" + util.generateRandomUUID(),
  role: member?.role ?? TSmartHomeRoleType.HOME_ROLE_TYPE_MEMBER,
}
await TSmartMember.getInstance().updateMember(params);
```

---

### 4. `static updateMemberName(memberId: number, name: string): Promise<TSmartAtopResponse<boolean>>`

更新成员的备注名称。

- **参数**：
  - `memberId`: 成员 ID。
  - `name`: 新名称。
- **返回值**：是否更新成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().updateMemberName(member?.memberId, "修改成员名称");
```

---

### 5. `removeMember(memberId: number): Promise<TSmartAtopResponse<boolean>>`

将指定成员从其所属家庭中移除。

- **参数**：
  - `memberId`: 成员 ID。
- **返回值**：是否移除成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().removeMember(member?.memberId);
```

---

### 6. `getMemberList(homeId: number): Promise<TSmartAtopResponse<Array<TSmartHomeMemberBean>>>`

获取指定家庭下的所有成员列表。

- **参数**：
  - `homeId`: 家庭 ID。
- **返回值**：成员对象数组封装在 `TSmartAtopResponse<Array<TSmartHomeMemberBean>>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().removeMember(member?.memberId);
```

---

### 7. `getMemberDeviceList(memberId: number): Promise<TSmartAtopResponse<Record<string, Object>>>`

获取指定成员关联的设备权限信息。

- **参数**：
  - `memberId`: 成员 ID。
- **返回值**：设备权限信息封装在 `TSmartAtopResponse<Record<string, Object>>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().getMemberList(this.homeBean.homeId);
```

---

### 8. `getAuthRoomList(homeId: number, memberId: number): Promise<TSmartAtopResponse<Array<RoomAuthBean>>>`

获取成员对当前家庭下各房间的授权状态。

- **参数**：
  - `homeId`: 家庭 ID。
  - `memberId`: 成员 ID。
- **返回值**：房间授权信息封装在 `TSmartAtopResponse<Array<RoomAuthBean>>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().getAuthRoomList(this.homeBean.homeId, member?.memberId);
```

---

### 9. `saveAuthRoomList(homeId: number, memberId: number, rooms: Array<number>): Promise<TSmartAtopResponse<boolean>>`

保存成员对某些房间的授权状态。

- **参数**：
  - `homeId`: 家庭 ID。
  - `memberId`: 成员 ID。
  - `rooms`: 房间 ID 列表。
- **返回值**：是否操作成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().saveAuthRoomList(this.homeBean.homeId, member?.memberId, [roomId]);
```

---

### 10. `getAuthSceneList(homeId: number, memberId: number): Promise<TSmartAtopResponse<Array<SceneAuthBean>>>`

获取成员对当前家庭下各场景的授权状态。

- **参数**：
  - `homeId`: 家庭 ID。
  - `memberId`: 成员 ID。
- **返回值**：场景授权信息封装在 `TSmartAtopResponse<Array<SceneAuthBean>>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().getAuthSceneList(this.homeBean.homeId, member?.memberId);
```

---

### 11. `saveAuthSceneList(homeId: number, memberId: number, ruleIds: Array<string>): Promise<TSmartAtopResponse<boolean>>`

保存成员对某些场景的授权状态。

- **参数**：
  - `homeId`: 家庭 ID。
  - `memberId`: 成员 ID。
  - `ruleIds`: 场景规则 ID 列表。
- **返回值**：是否操作成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().saveAuthSceneList(this.homeBean.homeId, member?.memberId, [ruleId]);
```

---

### 12. `addMemberAccountRole(requestParams: MemberAccountRoleReqParams): Promise<TSmartAtopResponse<boolean>>`

为成员绑定账号角色权限。

- **参数**：
  - `requestParams`: 绑定参数。
- **返回值**：是否绑定成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
const params: MemberAccountRoleReqParams = {
  id: member?.memberId ?? 0,
  countryCode: "86",
  userAccount: member?.userName ?? "",
  role: TSmartHomeRoleType.HOME_ROLE_TYPE_ADMIN
}
await TSmartMember.getInstance().addMemberAccountRole(params);
```

---

### 14. `getInvitationMessage(homeId: number, role: TSmartHomeRoleType, customRoleId?: number): Promise<TSmartAtopResponse<InviteMessageBean>>`

获取邀请消息内容。

- **参数**：
  - `homeId`: 家庭 ID。
  - `role`: 成员角色类型。
  - `customRoleId`: 自定义角色 ID（可选）。
- **返回值**：邀请消息内容封装在 `TSmartAtopResponse<InviteMessageBean>` 中。

**示例代码：**

```javascript
TSmartMember.getInstance().getInvitationMessage(this.homeBean?.homeId, TSmartHomeRoleType.HOME_ROLE_TYPE_MEMBER);
```

---

### 15. `getInvitationFamilyInfo(inviteCode: string): Promise<TSmartAtopResponse<InviteFamilyInfoBean>>`

通过邀请码获取家庭信息。

- **参数**：
  - `inviteCode`: 邀请码字符串。
- **返回值**：家庭信息封装在 `TSmartAtopResponse<InviteFamilyInfoBean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().getInvitationFamilyInfo(item.invitationCode);
```

---

### 16. `reInviteMember(invitationId: number): Promise<TSmartAtopResponse<InviteMessageBean>>`

重新发送邀请消息。

- **参数**：
  
  - `invitationId`: 邀请记录 ID。
  
- **返回值**：新的邀请消息封装在 `TSmartAtopResponse<InviteMessageBean>` 中。

  **示例代码：**

  ```javascript
  await TSmartMember.getInstance().reInviteMember(item.invitationId);
  ```

---

### 17. `cancelMemberInvite(invitationId: number): Promise<TSmartAtopResponse<boolean>>`

取消已发送的邀请。

- **参数**：
  - `invitationId`: 邀请记录 ID。
- **返回值**：是否取消成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().reInviteMember(item.invitationId);
```

---

### 18. `getInvitationList(homeId: number): Promise<TSmartAtopResponse<Array<InviteMemberInfoBean>>>`

获取家庭的所有邀请记录。

- **参数**：
  - `homeId`: 家庭 ID。
- **返回值**：邀请记录列表封装在 `TSmartAtopResponse<Array<InviteMemberInfoBean>>` 中。

**示例代码：**

```javascript
 TSmartMember.getInstance().getInvitationList(this.homeBean?.homeId);
```

---

### 19. `updateInvitedMember(requestParams: MemberInvitationReqParams): Promise<TSmartAtopResponse<boolean>>`

更新受邀成员的信息。

- **参数**：
  - `requestParams`: 更新参数。
- **返回值**：是否更新成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
const updateParams: MemberInvitationReqParams = {
                      invitationId: item.invitationId ?? 0,
                      memberName: "修改邀请成员姓名",
                      role: TSmartHomeRoleType.HOME_ROLE_TYPE_MEMBER
                    };
await TSmartMember.getInstance().updateInvitedMember(updateParams);
```

---

### 20. `transferOwner(homeId: number, memberId: number): Promise<TSmartAtopResponse<boolean>>`

转移家庭所有权给指定成员。

- **参数**：
  - `homeId`: 家庭 ID。
  - `memberId`: 新房主的成员 ID。
- **返回值**：是否转移成功的结果封装在 `TSmartAtopResponse<boolean>` 中。

**示例代码：**

```javascript
await TSmartMember.getInstance().transferOwner(homeId, memberId);
```

---







