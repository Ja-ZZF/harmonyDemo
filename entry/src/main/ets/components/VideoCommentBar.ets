import { CommentSimple } from "../models/Comment"
import { createEmptyPostDetail, PostDetail, PostSimple } from "../models/Post"
import { CommentDialog } from "./Dialog/CommentDialog"
import { PostCommentNew } from "./PostCommentNew"

//视频的评论区
@Component
export struct VideoCommentBar{
  @Prop post : PostDetail = createEmptyPostDetail()

  commentDialogController : CustomDialogController = new CustomDialogController({
    builder : CommentDialog({
      postId : this.post.post_simple.post_id,
      parentCommentId : null,
    }),
    alignment : DialogAlignment.Bottom,
  })

  build() {
    Column(){
      Text(this.post.comment_count.toString()+'条评论')
        .fontSize(12)
        .padding({top:8,bottom:8})

      //输入评论
      Row()
      {
        Text('说点什么…')
          .fontSize(14)
          .fontColor(Color.Gray)
      }
      .width('100%')
      .height(36)
      .backgroundColor(0xFFF0F0F0)
      .borderRadius(18)
      .alignItems(VerticalAlign.Center)
      .padding({ left: 12 })
      .onClick(() => {
        console.info('点击了说点什么');
        this.commentDialogController.open()
      })

      //评论区
      Scroll() {
        Column() {
          ForEach(this.post.comments, (comment: CommentSimple) => {
            PostCommentNew({ comment: comment })
          }, (comment: CommentSimple) => comment.comment_id.toString())
        }
      }
      .padding({bottom:60,left: 8, right: 8,}) // 留出底部栏高度
      .flexGrow(1) // 💡 关键

    }
    .width('100%')
    .height('55%')
    .borderRadius(8)
    .margin({top:'85%'})
    .backgroundColor(Color.White)
    .align(Alignment.Bottom)
    .transition({//入场动画
      type: TransitionType.Insert,
      opacity: 1,
      translate: {
        y: '100%'
      }
    })
    .transition({//离场动画
      type: TransitionType.Delete,
      opacity: 0,
      translate: {
        y: '100%'
      }
    })
  }
}