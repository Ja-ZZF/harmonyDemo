import { PostSimple } from "../models/Post";

@Component
export struct PostCard {
  @Prop post: PostSimple;

  build() {
    Column({ space: 6 }) {
      // 封面图
      Image(this.post.cover_url)
        .width('100%')
        .height(180)
        .objectFit(ImageFit.Cover)
        .borderRadius({ topLeft: 16, topRight: 16 })

      // 标题
      Text(this.post.title)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .padding({ left: 12, right: 12 })
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      // 作者 & 点赞
      Row({ space: 10 }) {
        // 作者头像
        Image(this.post.publisher.avatar)
          .width(32)
          .height(32)
          .borderRadius(16)

        // 昵称
        Text(this.post.publisher.nickname)
          .fontSize(14)
          .fontWeight(FontWeight.Regular)
          .layoutWeight(1)

        // 点赞图标与数量
        Image(this.post.like_stats.is_liked ? 'common/heart_fill.png' : 'common/heart_outline.png')
          .width(20)
          .height(20)
        Text(`${this.post.like_stats.like_count}`)
          .fontSize(14)
      }
      .padding({ left: 12, right: 12, bottom: 12 })
    }
    .backgroundColor('#ffffff')
    .borderRadius(16)
    .shadow({ color: '#00000010', radius: 4, offsetX: 0, offsetY: 2 })
    .margin(8)
  }
}
