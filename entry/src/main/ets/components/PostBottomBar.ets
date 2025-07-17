import { CollectStats, createEmptyCollectStats, createEmptyLikeStats, LikeStats } from "../models/Stats";
import { CommentService } from "../services/comment.service";
import { eventBus } from "../commons/utils/EventBus";
import picker from "@ohos.file.picker";
import { CommentDialog } from './Dialog/CommentDialog'


@Component
export struct PostBottomBar {

  @Prop postId : number = 0;
  @Prop comment_count: number = 0;
  @Prop likeStats: LikeStats = createEmptyLikeStats();
  @Prop collectStats: CollectStats = createEmptyCollectStats();

  commentDialogController : CustomDialogController = new CustomDialogController({
    builder : CommentDialog({
      postId : this.postId,
      parentCommentId : null,
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
      }
      .width('55%')
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
            .fontColor(Color.Gray)
        }
        .alignItems(VerticalAlign.Center)
        .onClick(()=>this.likeClick())

        // 收藏
        Row({ space: 4 }) {
          Image(this.collectStats.is_collected ? $r('app.media.collected') : $r('app.media.collect'))
            .width(22)
            .height(22)
          Text(this.collectStats.collect_count.toString())
            .fontSize(14)
            .fontColor(Color.Gray)
        }
        .alignItems(VerticalAlign.Center)
        .onClick(()=>this.collectClick())

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
    .padding({ left: 8, right: 8, top: 10, bottom: 10 })
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
