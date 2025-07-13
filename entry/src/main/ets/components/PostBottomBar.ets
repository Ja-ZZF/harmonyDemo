import { CollectStats, createEmptyCollectStats, createEmptyLikeStats, LikeStats } from "../models/Stats";
import { prompt } from "@kit.ArkUI";
import { CommentService } from "../services/comment.service";
import { eventBus } from "../commons/utils/EventBus";

@Component
export struct PostBottomBar {

  @Prop postId : number = 0;
  @Prop comment_count: number = 0;
  @Prop likeStats: LikeStats = createEmptyLikeStats();
  @Prop collectStats: CollectStats = createEmptyCollectStats();

  commentDialogController : CustomDialogController = new CustomDialogController({
    builder : CommentDialog({
      postId : this.postId,
    }),
    alignment : DialogAlignment.Bottom,
  })

  build() {
    Row() {

      Row()
      {
        Text('说点什么…')
          .fontSize(14)
          .fontColor(Color.Gray)
      }        .width('55%')
      .height(36)
      .backgroundColor(0xFFF0F0F0)
      .borderRadius(18)
      .alignItems(VerticalAlign.Center)
      .padding({ left: 12 })
      .onClick(() => {
        console.info('点击了说点什么');
        this.commentDialogController.open()

      })

      // 右侧功能区域
      Row({ space: 20 }) {

        // 点赞
        Row({ space: 4 }) {
          Image(this.likeStats.is_liked ? $r('app.media.liked') : $r('app.media.like'))
            .width(22)
            .height(22)
          Text(this.likeStats.like_count.toString())
            .fontSize(14)
            .fontColor(this.likeStats.is_liked ? 0xFFFF5722 : Color.Gray)
        }
        .alignItems(VerticalAlign.Center)
        .onClick(this.likeClick.bind(this))

        // 收藏
        Row({ space: 4 }) {
          Image(this.collectStats.is_collected ? $r('app.media.collected') : $r('app.media.collect'))
            .width(22)
            .height(22)
          Text(this.collectStats.collect_count.toString())
            .fontSize(14)
            .fontColor(this.collectStats.is_collected ? 0xFF317AFF : Color.Gray)
        }
        .alignItems(VerticalAlign.Center)
        .onClick(this.collectClick.bind(this))

        // 评论
        Row({ space: 4 }) {
          Image($r('app.media.comment'))
            .width(22)
            .height(22)
          Text(this.comment_count.toString())
            .fontSize(14)
            .fontColor(Color.Gray)
        }
        .alignItems(VerticalAlign.Center)



      }
      .alignItems(VerticalAlign.Center)
      .margin({ left: 16 }) // 拉开输入框和按钮区间距
    }
    .padding({ left: 16, right: 16, top: 10, bottom: 10 })
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Center)
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  likeClick() {
    // 切换点赞状态
    this.likeStats.is_liked = !this.likeStats.is_liked

    // 点赞数递增或递减
    if (this.likeStats.is_liked) {
      this.likeStats.like_count += 1
    } else {
      this.likeStats.like_count -= 1
    }

    // TODO: 可以在这里调用接口通知后端
  }

  collectClick() {
    // 切换收藏状态
    this.collectStats.is_collected = !this.collectStats.is_collected;

    // 收藏数递增或递减
    if (this.collectStats.is_collected) {
      this.collectStats.collect_count += 1;
    } else {
      this.collectStats.collect_count -= 1;
    }

    // TODO: 这里可以调用接口同步状态
  }


}

@CustomDialog
struct CommentDialog {
  controller: CustomDialogController;
  @State textInputValue: string = '';
  @State imagePath: string = ''; // 预览的图片路径
  @Prop postId : number = 0;

  private commentService = new CommentService();

  build() {
    Column() {
      Text('新增评论')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .padding({ bottom: 12 })
        .textAlign(TextAlign.Start)
        .align(Alignment.Top)

      // 文本输入
      TextInput({ text: this.textInputValue, placeholder: '请输入你的评论...' })
        .width('100%')
        .height(60)
        .borderRadius(8)
        .backgroundColor('#F5F5F5')
        .padding(8)
        .fontSize(14)
        .fontColor('#000000')
        .align(Alignment.TopStart)
        .onChange((value: string) => {
          this.textInputValue = value;
          console.log('当前id：',this.postId);
        })

      //图片上传 + 发送
      Row() {
        // 图片上传
        Row() {
          Image($r('app.media.add')) // 替换成你的上传图标资源
            .width(60)
            .height(60)
            .onClick(() => {
              this.pickImage();
            })
            .padding(8)  // 增加点击范围
          if (this.imagePath !== '') {
            Image(this.imagePath)
              .width(60)
              .height(60)
              .borderRadius(6)
              .margin({ left: 12 })
          }
        }
        .margin({ top: 12 })

        // 按钮区
        Row({ space: 12 }) {
          Button('确认')
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#317AFF')
            .borderRadius(20)
            .padding({
              left: 16,
              right: 16,
              top: 8,
              bottom: 8
            })
            .onClick(() => {
              // 确认逻辑：可传 this.textInputValue 和 this.imagePath
              eventBus.emit('refreshPostComments', { type: 'refresh', data: this.postId.toString() });
              this.commentService.createCommentForPost(this.postId,this.textInputValue);
              this.controller.close();
            })

        }
        .margin({ top: 16 })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)

  }

  pickImage() {
    // 示例：调用图片选择器
    prompt.showToast({ message: '这里调用选择图片的逻辑' });
  }
}
