import { CommentSimple } from "../models/Comment";
import { MediaSimple } from "../models/Media";

@Component
export struct CommentCard {
  @Prop comment: CommentSimple;

  formatTime(date: Date): string {
    let d = new Date(date);
    return `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()} ${d.getHours()}:${d.getMinutes()}`;
  }

  build() {
    Column({ space: 6 }) {
      // 顶部: 头像 + 昵称 + 时间 + 点赞
      Row({ space: 10 }) {
        // 头像
        Image(this.comment.commenter.avatar)
          .width(32).height(32)
          .borderRadius(16)

        // 昵称 & 时间
        Column() {
          Text(this.comment.commenter.nickname)
            .fontSize(15).fontWeight(FontWeight.Medium)
          Text(this.formatTime(this.comment.comment_time))
            .fontSize(12).fontColor('#999999')
        }.layoutWeight(1)

        // 点赞
        Row({ space: 4 }) {
          Image(this.comment.like_stats.is_liked ? 'common/heart_fill.png' : 'common/heart_outline.png')
            .width(16).height(16)
          Text(`${this.comment.like_stats.like_count}`)
            .fontSize(12)
        }
      }

      // 评论内容
      if (this.comment.content.trim() !== '') {
        Text(this.comment.content)
          .fontSize(14)
          .fontColor('#333333')
      }

      // 评论图片（可选）
      if (this.comment.medias.length > 0) {
        Row({ space: 8 }) {
          ForEach(this.comment.medias, (media: MediaSimple) => {
            Image(media.url)
              .width(80)
              .height(80)
              .borderRadius(8)
              .objectFit(ImageFit.Cover)
          }, (media: MediaSimple) => media.media_id.toString())
        }
      }

      // 子评论预留：可展开的 children
      // 可以后补上递归嵌套 CommentCard 的实现
    }
    .padding(12)
    .backgroundColor('#FAFAFA')
    .borderRadius(12)
    .margin({ bottom: 8 })
  }
}
