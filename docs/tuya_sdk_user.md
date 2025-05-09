# 用户体系
@thingsmart/userlib 通过 TSmartUser 类提供用户账号管理的能力，包括手机号码验证、注册、登录、密码重置等功能。

## 初始化用户代理环境

**接口说明**

账号登录成功后，需要初始化用户代理环境，配置客户端识别信息。在调用任何其他接口之前必须先完成初始化。

```ts
static initUserAgent(): void
```

**示例代码**

```ts
if (TSmartUser.isLogin()) {
    TSmartUser.initUserAgent()
}
```

<a id="WhiteList"></a>

## 查询验证码服务可用地区

为了加强用户信息的数据安全，系统优化了验证码发送流程，并添加了账号限制。只有验证码服务可用的地区，才可以发送验证码。

:::important
如果您想为 App 启用手机号码验证服务，您需要确保您的应用已完成相关的权限和配置。
:::

**接口说明**

```ts
static getWhiteListCanSendMobileCode(): Promise<TSmartUserResponse<ITSmartUserRegionWhiteListBean>>
```

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<ITSmartUserRegionWhiteListBean>> | 返回可以发送验证码的地区列表，其中：<br>ITSmartUserRegionWhiteListBean 包含以下字段：<ul><li>countryCodes：可发送验证码的国家码数组</li></ul> |

**示例代码**

```ts
try {
  const response = await TSmartUser.getWhiteListCanSendMobileCode();
  if (response.success) {
    console.info('Get whitelist success:', response.result);
  }
} catch (error) {
  console.error('Get whitelist failed:', error);
}
```

<a id="verification"></a>

## 发送验证码

:::important
发送验证码到手机号前，您需要确保手机号可以收到验证码。详情请调用 [`getWhiteListCanSendMobileCode`](#WhiteList) 查看使用权限。
:::

**接口说明**

发送验证码，用于手机号码的验证码登录、注册、密码重置等。

```ts
static sendAuthCode(params: ITSmartUserSendAuthCodeParams): Promise<TSmartUserResponse<boolean>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| account | 发送验证码的账号（手机号码或邮箱） |
| countryCode | 国家码，例如 `86` |
| codeType | 验证码类型，见 TSmartUserAuthCodeType 枚举：<ul><li> REGISTER(1)：注册账号 </li><li> RESET_PASSWORD(3)：重置密码  </li><li> CANCEL_ACCOUNT(8)：注销账号  </li></ul> |
| region | 区域（可选） |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 发送验证码结果 |

**示例代码**

```ts
try {
  const params = {
    account: 'yourPhoneNumber',
    region: 'yourRegion',
    countryCode: '86',
    codeType: TSmartUserAuthCodeType.REGISTER
  };
  
  const response = await TSmartUser.sendAuthCode(params);
  if (response.success) {
    console.info('Send auth code success');
  }
} catch (error) {
  console.error('Send auth code failed:', error);
}
```

<a id="proofing"></a>

## 校验填入的验证码

**接口说明**

账号注册、登录、重设密码时验证码的校验。

```ts
static verifyAuthCode(params: ITSmartUserVerifyAuthCodeParams): Promise<TSmartUserResponse<boolean>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| account | 验证码接收账号（手机号或邮箱） |
| region | 区域（可选） |
| countryCode | 国家码，例如 `86` |
| codeType | 验证码类型，见 TSmartUserAuthCodeType 枚举：<ul><li> REGISTER(1)：注册账号 </li><li> RESET_PASSWORD(3)：重置密码  </li><li> CANCEL_ACCOUNT(8)：注销账号  </li></ul> |
| authCode | 要校验的验证码 |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 验证码校验结果 |

**示例代码**

```ts
try {
  const params = {
    account: 'yourPhoneNumber',
    region: 'yourRegion',
    countryCode: '86',
    authCode: 'verifyCode',
    codeType: TSmartUserAuthCodeType.REGISTER
  };
  
  const response = await TSmartUser.verifyAuthCode(params);
  if (response.success) {
    console.info('Verify code success');
  }
} catch (error) {
  console.error('Verify code failed:', error);
}
```

## 使用手机号码或邮箱注册账号

注册账号前，您需要先 [获取验证码](#verification)。

**接口说明**

```ts
static registerAccount(params: ITSmartUserRegisterParams): Promise<TSmartUserResponse<boolean>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| account | 要注册的账号（手机号码或邮箱） |
| region | 区域（可选） |
| countryCode | 国家码，例如 `86` |
| authCode | 验证码 |
| password | 密码 |
| accountType | 账号类型，见 TSmartUserAccountType 枚举：<ul><li> PHONE(1)：手机号码 </li><li> EMAIL(2)：邮箱地址  </li></ul> |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 注册结果 |

**示例代码**

```ts
try {
  const params = {
    account: 'yourPhoneNumber',
    region: 'yourRegion',
    countryCode: '86',
    accountType: TSmartUserAccountType.PHONE,
    password: 'yourPassword',
    authCode: 'verifyCode'
  };
  
  const response = await TSmartUser.registerAccount(params);
  if (response.success) {
    console.info('Register success');
  }
} catch (error) {
  console.error('Register failed:', error);
}
```

## 登录账号

**接口说明**

```ts
static loginAccount(params: ITSmartUserLoginParams): Promise<TSmartUserResponse<boolean>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| account | 登录账号（手机号码或邮箱） |
| countryCode | 国家码，例如 `86` |
| password | 账号密码 |
| accountType | 账号类型，见 TSmartUserAccountType 枚举：<ul><li> PHONE(1)：手机号码 </li><li> EMAIL(2)：邮箱地址  </li></ul> |
| twiceCode | 二次验证码（可选） |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 登录结果 |

**示例代码**

```ts
try {
  const params = {
    account: 'yourPhoneNumber',
    countryCode: '86',
    password: 'yourPassword',
    accountType: TSmartUserAccountType.PHONE
  };
  
  const response = await TSmartUser.loginAccount(params);
  if (response.success) {
    console.info('Login success');
  }
} catch (error) {
  console.error('Login failed:', error);
}
```

## 使用 UID 登录或注册账号

:::important
UID 应为您自己系统中的用户唯一标识。通过 UID，您可以建立您自己系统数据库与云端数据库之间的连接。
:::

**接口说明**

如果注册了账号就自动登录，如果没有注册账号就自动注册并且登录。

```ts
static loginOrRegisterByUid(params: ITSmartUserAccountUidParams): Promise<TSmartUserResponse<Record<string, Object>> | TSmartUserResponse<undefined>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| countryCode | 国家码，例如 `86` |
| uid | 匿名 ID，用户唯一标识，没有格式要求 |
| password | 与账户 ID 对应的随机标识 |
| createHome | 是否创建默认家庭 |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<...>> | 登录/注册结果 |

**示例代码**

```ts
try {
  const params = {
    countryCode: '86',
    uid: 'yourUniqueUserId',
    password: 'yourPassword',
    createHome: true
  };
  
  const response = await TSmartUser.loginOrRegisterByUid(params);
  if (response.success) {
    console.info('Login/Register by UID success');
  }
} catch (error) {
  console.error('Login/Register by UID failed:', error);
}
```

## 重置账号密码

重置密码前，您需要先 [获取验证码](#verification)。

**接口说明**

```ts
static resetPassword(params: ITSmartUserResetPasswordParams): Promise<TSmartUserResponse<boolean>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| account | 要重置密码的账号（手机号码或邮箱） |
| countryCode | 国家码，例如 `86` |
| newPassword | 要设置的新密码 |
| authCode | 验证码 |
| accountType | 账号类型，见 TSmartUserAccountType 枚举：<ul><li> PHONE(1)：手机号码 </li><li> EMAIL(2)：邮箱地址  </li></ul> |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 重置密码结果 |

**示例代码**

```ts
try {
  const params = {
    account: 'yourPhoneNumber',
    countryCode: '86',
    newPassword: 'yourNewPassword',
    authCode: 'verifyCode',
    accountType: TSmartUserAccountType.PHONE
  };
  
  const response = await TSmartUser.resetPassword(params);
  if (response.success) {
    console.info('Reset password success');
  }
} catch (error) {
  console.error('Reset password failed:', error);
}
```

## 修改用户头像

**接口说明**

```ts
static updateHeadIcon(url: string): Promise<TSmartUserResponse<boolean>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| url | 头像图片的 URL 地址 |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 更新头像结果 |

**示例代码**

```ts
try {
  const response = await TSmartUser.updateHeadIcon('yourHeadIconUrl');
  if (response.success) {
    console.info('Update head icon success');
  }
} catch (error) {
  console.error('Update head icon failed:', error);
}
```

## 选择温度单位

**接口说明**

```ts
static updateTempUnit(tempUnit: TSmartUserTempUnit): Promise<TSmartUserResponse<boolean>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| tempUnit | 温度单位<ul><li> 1：°C </li><li> 2：°F </li></ul> |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 更新温度单位结果 |

**示例代码**

```ts
try {
  const response = await TSmartUser.updateTempUnit(1); // 设置为摄氏度
  if (response.success) {
    console.info('Update temperature unit success');
  }
} catch (error) {
  console.error('Update temperature unit failed:', error);
}
```

## 修改账号昵称

**接口说明**

```ts
static updateNickName(nickName: string): Promise<TSmartUserResponse<boolean>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| nickName | 昵称 |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 更新昵称结果 |

**示例代码**

```ts
try {
  const response = await TSmartUser.updateNickName('yourNickname');
  if (response.success) {
    console.info('Update nickname success');
  }
} catch (error) {
  console.error('Update nickname failed:', error);
}
```

## 更新用户时区

**接口说明**

```ts
static updateTimezondId(timezoneId: string): Promise<TSmartUserResponse<boolean>>
```

**参数说明**

| 参数 | 说明 |
| ---- | ---- |
| timezoneId | 时区 ID，例如 `Asia/Shanghai` |

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 更新时区结果 |

**示例代码**

```ts
try {
  const response = await TSmartUser.updateTimezondId('Asia/Shanghai');
  if (response.success) {
    console.info('Update timezone success');
  }
} catch (error) {
  console.error('Update timezone failed:', error);
}
```

## 退出登录

**接口说明**

```ts
static logout(): Promise<TSmartUserResponse<boolean>>
```

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 退出登录结果 |

**示例代码**

```ts
try {
  const response = await TSmartUser.logout();
  if (response.success) {
    console.info('Logout success');
  }
} catch (error) {
  console.error('Logout failed:', error);
}
```

## 注销账号

**接口说明**

注销账号后，一周后才会永久注销并删除用户账户中的所有信息。但是，如果用户在永久注销之前重新登录的话，则注销请求会被取消。

```ts
static cancelAccount(): Promise<TSmartUserResponse<boolean>>
```

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| Promise<TSmartUserResponse<boolean>> | 注销账号结果 |

**示例代码**

```ts
try {
  const response = await TSmartUser.cancelAccount();
  if (response.success) {
    console.info('Cancel account success');
  }
} catch (error) {
  console.error('Cancel account failed:', error);
}
```

## 获取用户信息

### 获取用户名

**接口说明**

```ts
static getUserName(): string | undefined
```

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| string \| undefined | 用户名，未设置时返回 undefined |

**示例代码**

```ts
const userName = TSmartUser.getUserName();
if (userName) {
  console.info('User name:', userName);
}
```

### 获取手机号码

**接口说明**

```ts
static getPhoneNumber(): string | undefined
```

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| string \| undefined | 手机号码，未设置时返回 undefined |

**示例代码**

```ts
const phoneNumber = TSmartUser.getPhoneNumber();
if (phoneNumber) {
  console.info('Phone number:', phoneNumber);
}
```

### 获取邮箱地址

**接口说明**

```ts
static getEmail(): string | undefined
```

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| string \| undefined | 邮箱地址，未设置时返回 undefined |

**示例代码**

```ts
const email = TSmartUser.getEmail();
if (email) {
  console.info('Email:', email);
}
```

### 获取国家码

**接口说明**

```ts
static getCountryCode(): string | undefined
```

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| string \| undefined | 国家码，例如 "86"，未设置时返回 undefined |

**示例代码**

```ts
const countryCode = TSmartUser.getCountryCode();
if (countryCode) {
  console.info('Country code:', countryCode);
}
```

### 获取用户 ID

**接口说明**

```ts
static getUid(): string | undefined
```

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| string \| undefined | 用户唯一标识，未登录时返回 undefined |

**示例代码**

```ts
const uid = TSmartUser.getUid();
if (uid) {
  console.info('User ID:', uid);
}
```

### 检查登录状态

**接口说明**

```ts
static isLogin(): boolean
```

**返回值**

| 类型 | 说明 |
| ---- | ---- |
| boolean | true 表示用户已登录，false 表示用户未登录 |

**示例代码**

```ts
const isLoggedIn = TSmartUser.isLogin();
console.info('Is user logged in:', isLoggedIn);
```

<a id="session"></a>

## 处理登录会话过期

为了确保良好的用户体验，妥善处理登录会话过期问题至关重要。以下是可能导致会话过期的常见情况：
- 用户主动退出登录
- 长时间未进行任何操作
- 在已登录状态下，通过其他设备修改了账号密码
- 同一账号在多个设备上登录，超过设备登录限制时，最早的会话将被强制登出

您可以通过监听事件总线中的登出事件来处理会话过期：

```ts
import { LiveEventBus } from '@ohos/liveeventbus';
import { TSMART_USER_LOGOUT_EVENT } from './ITSmartUserResponseBean';

// 监听登出事件
LiveEventBus.get(TSMART_USER_LOGOUT_EVENT).on((data) => {
  console.info('User session expired');
  // 处理登出逻辑，如跳转到登录页面
});
