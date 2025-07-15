import { PostSimple } from "../models/Post";

@Component
export struct PostCardSimple {
  @Prop post: PostSimple;

  build() {
    Column({ space: 6 }) {
      // 封面图
      Image(this.post.cover_url)
        .width('100%')
        .objectFit(ImageFit.Cover)
        .borderRadius(4)

      // 标题
      Text(this.post.title)
        .fontSize(15)
        .fontWeight(FontWeight.Medium)
        .padding({ left: 6, right: 6 })
        .maxLines(2)
        .align(Alignment.Start)
        .width('100%')
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      // 作者 & 点赞
      Row({ space: 10 }) {
        // 作者头像
        Image(this.post.publisher.avatar)
          .width(10)
          .height(10)
          .borderRadius(10)

        // 昵称
        Text(this.post.publisher.nickname)
          .fontSize(10)
          .fontWeight(FontWeight.Regular)
          .fontColor('rgba(0,0,0,0.75)') // 半透明黑色，40%透明度，颜色会淡很多
          .layoutWeight(1)

        // 点赞图标与数量
        Image(this.post.like_stats.is_liked ? $r('app.media.liked') : $r('app.media.like'))
          .width(10)
          .height(10)
        Text(`${this.post.like_stats.like_count}`)
          .fontSize(10)
      }
      .padding({ left: 6, right: 12, bottom: 12 })
    }
    .backgroundColor('#ffffff')
    .borderRadius(4)
    .shadow({ color: '#00000010', radius: 4, offsetX: 0, offsetY: 2 })



  }
}
