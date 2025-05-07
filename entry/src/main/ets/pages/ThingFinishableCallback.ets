import { ThingFinishableCallback } from "@thingsmart/thingcamerasdk";

export class ThingCloudFinishableCallbackImpl implements ThingFinishableCallback {
  onResponse(reason: string, errCode: number): number {
    return 0;
  }

  onFinished(data: string, errCode: number): void {
    console.log(`Operation finished with data: ${data} and error code: ${errCode}`);
  }

  onEvent(eventType: number, info1: number, info2: number, errInfo: string): void {
    console.log(`Event occurred: eventType=${eventType}, info1=${info1}, info2=${info2}, errInfo=${errInfo}`);
  }
}

