import { UserSimple } from "../models/User";
import { router } from "@kit.ArkUI";

@Component
export struct PostAppBar {
  @Prop user: UserSimple;

  build() {
    Row({ space: 10 }) {
      // 返回按钮
      Image($r('app.media.back'))
        .width(24)
        .height(24)
        .onClick(()=>{
          router.back();
        })

      // 头像
      Image(this.user.avatar)
        .width(28)
        .height(28)
        .borderRadius(14)

      // 昵称
      Text(this.user.nickname)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Blank() // 中间占位拉伸

      // 关注/已关注 按钮
      Button(this.user.is_followed ? '已关注' : '关注', {
        type: ButtonType.ROUNDED_RECTANGLE,
        stateEffect: true
      })
        .width(72)
        .height(32)
        .fontSize(this.user.is_followed?12:14)
        .borderRadius(18)
        .backgroundColor(Color.White) // 镂空背景
        .border({ width: 1, color: this.user.is_followed?Color.Grey:Color.Blue }) // 蓝色边框
        .fontColor(this.user.is_followed?Color.Grey:Color.Blue) // 蓝色文字
        .onClick(() => {
          this.user.is_followed = !this.user.is_followed;
        })

      // 转发图标
      Image($r('app.media.share'))
        .width(24)
        .height(24)
    }
    .padding({ left: 16, right: 16, top: 12, bottom: 12 })
    .backgroundColor(Color.White)
    .width('100%')
  }
}

