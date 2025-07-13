import { formatSmartTime } from "../commons/utils/TimeUtils";
import { CommentSimple } from "../models/Comment";
import { MediaSimple } from "../models/Media";
import { UserSimple } from "../models/User";


@Component
export struct PostComment {
  @Prop comment: CommentSimple;
  @Prop depth: number = 0;

  // 获取安全 commenter 信息（带默认值）
  private getCommenter(): UserSimple {
    return this.comment.commenter ?? {
      user_id: 0,
      nickname: '匿名用户',
      avatar: 'common/default_avatar.png',
      email: 'default@abc.com',
      is_followed: false,
    };
  }

  // 生成显示名：顶层评论显示昵称，子评论显示“xxx 回复 yyy”
  private getDisplayName(): string {
    const commenter = this.getCommenter();
    if (this.depth > 0 && this.comment.parent?.commenter?.nickname) {
      const parentNickname = this.comment.parent.commenter.nickname;
      return `${commenter.nickname} 回复 ${parentNickname}`;
    } else {
      return commenter.nickname;
    }
  }


  // ArkTS 不支持 {...child}，手动复制构造新对象
  private createChildComment(child: CommentSimple, parent: CommentSimple): CommentSimple {
    return {
      comment_id: child.comment_id,
      post_id: child.post_id,
      commenter: child.commenter,
      content: child.content,
      medias: child.medias,
      comment_time: child.comment_time,
      like_stats: child.like_stats,
      children: child.children,
      parent: parent, // 显式添加 parent 字段
    };
  }

  build() {
    Column(){
    Column() {
      Row() {
        // 头像 - 固定宽度
        Image(this.getCommenter().avatar)
          .width(32)
          .height(32)
          .borderRadius(16)

        // 头像右侧内容区，左边距10
        Column({ space: 6 }) {
          // 第一行：昵称/回复 + 点赞（右侧）
          Row() {
            Text(this.getDisplayName())
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
              .flexGrow(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })

            Row({ space: 4 }) {
              Image(this.comment.like_stats.is_liked ? $r('app.media.liked') : $r('app.media.like'))
                .width(16)
                .height(16)
              Text(this.comment.like_stats.like_count.toString())
                .fontSize(12)
            }
            .width(60) // 给个宽度
            .onClick(this.likeClick.bind(this))
          }
          .width('100%')
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.SpaceBetween)

          // 第二行：正文内容
          if (this.comment.content.trim() !== '') {
            Text() {
              Span(this.comment.content)
                .fontSize(14)
                .fontColor('#333333')

              Span('  ')

              Span(formatSmartTime(this.comment.comment_time))
                .fontSize(12)
                .fontColor('#999999')
            }
            .width('100%')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .textAlign(TextAlign.Start)
          }


        }
        .margin({ left: 10 })
        .flexGrow(1)
      }
      .width('100%')
      .padding(12)
      //.backgroundColor('#FAFAFA')
      .backgroundColor('#FFFFFF') // 或直接移除这一行
      .borderRadius(12)
      .margin({ bottom: 8 })
      .alignItems(VerticalAlign.Top)

      // 子评论递归，放外层单独 Column
      if (this.comment.children.length > 0) {
        Column({ space: 6 }) {
          ForEach(this.comment.children, (child: CommentSimple) => {
            PostComment({
              comment: this.createChildComment(child, this.comment),
              depth: this.depth + 1
            })
          }, (child: CommentSimple) => child.comment_id.toString())
        }
        .width('100%')
      }
    }
    .width('100%')
  }
    .margin({ left: this.depth == 1 ? 42 : 0 }) // 仅对一级评论缩进
  }

  likeClick() {
    // 切换点赞状态
    const newIsLiked = !this.comment.like_stats.is_liked;
    let newLikeCount = this.comment.like_stats.like_count;

    if (newIsLiked) {
      newLikeCount += 1;
    } else {
      newLikeCount -= 1;
    }

    // 重新赋值新对象，触发视图更新
    this.comment.like_stats = {
      is_liked: newIsLiked,
      like_count: newLikeCount,
    };
  }



}
