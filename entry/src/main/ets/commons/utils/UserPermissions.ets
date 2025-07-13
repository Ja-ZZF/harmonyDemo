import { abilityAccessCtrl, common, Permissions } from "@kit.AbilityKit";

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