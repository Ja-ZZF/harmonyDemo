import { abilityAccessCtrl, common,Permissions } from "@kit.AbilityKit";

interface rejectObj {
  code: number
  message: string
}

export async function applyPermission(context: common.UIAbilityContext, permissions: Array<Permissions>): Promise<boolean> {
  let atManager = abilityAccessCtrl.createAtManager();
  return new Promise((resolve: (res: boolean) => void, reject: (e: rejectObj) => void) => {
    atManager.requestPermissionsFromUser(context, permissions).then((data) => {
      let grantStatus: Array<number> = data.authResults;
      resolve(grantStatus.every(item => item === 0))
    }).catch((err: rejectObj) => {
      reject(err)
    })

  })
}

export async function checkAndRequestPermissions(context: common.UIAbilityContext) {
  const permissions: Permissions[] = [
    'ohos.permission.READ_MEDIA',
    'ohos.permission.WRITE_MEDIA',
    'ohos.permission.WRITE_DOCUMENT',
  ];

  try {
    const granted: boolean = await applyPermission(context, permissions);
    if (granted) {
      console.info('用户授权成功，可以执行后续操作');
    } else {
      console.warn('部分权限未授权，相关功能可能不可用');
    }
  } catch (err) {
    console.error('申请权限失败: ', JSON.stringify(err));
  }
}



