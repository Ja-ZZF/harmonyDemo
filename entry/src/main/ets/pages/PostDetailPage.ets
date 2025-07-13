import { PostComment } from '../components/PostComment';
import { PostAppBar } from '../components/PostAppBar';
import { PostBottomBar} from '../components/PostBottomBar'
import { CommentSimple } from '../models/Comment';
import { createEmptyPostDetail, PostDetail } from '../models/Post';
import { createEmptyUserSimple, UserSimple } from '../models/User';
import { PostService } from '../services/post.service'
import { PostImageCarousel } from '../components/PostImageCarousel';
import { PostContent } from '../components/PostContent';
import { PostCommentNew } from '../components/PostCommentNew';
import { eventBus, EventPayload } from '../commons/utils/EventBus';
import { convertMediaUrls } from '../commons/utils/MediaUtils';


@Entry
@Component
struct PostDetailPage {
  private postService = new PostService();

  private postId: number = 1;              // 假设是从外部传入的 post_id

  @State postDetail: PostDetail = createEmptyPostDetail();

  async aboutToAppear(): Promise<void> {
    this.postDetail = await this.postService.getPostDetail(this.postId);

    eventBus.on('refreshPostComments', (payload: EventPayload) => {
      if (payload.type === 'refresh' && Number(payload.data) === this.postId) {
        this.refreshComments();
      }
    });

  }

  async refreshComments(): Promise<void> {
    console.info('正在刷新评论...');
    const detail = await this.postService.getPostDetail(this.postId);
    this.postDetail.comments = detail.comments;
    this.postDetail.comment_count = detail.comment_count;
  }


  build() {
    Flex({ direction: FlexDirection.Column }) // 💡 用 Flex 撑满屏幕
    {
      // 顶部 AppBar
      PostAppBar({ user: this.postDetail.post_simple.publisher })
      // 中间 Scroll 撑满剩余空间
      Scroll()
      {
        Column({ space: 12 }) {
          //图片
          PostImageCarousel({ medias: convertMediaUrls(this.postDetail.medias,'medium') })

          //正文
          PostContent({
            title: this.postDetail.post_simple.title,
            content: this.postDetail.content,
            tags: this.postDetail.tags,
            publish_time : this.postDetail.publish_time,
          })

          //分割线
          Shape()
            .height(1)
            .width('100%')
            .backgroundColor('#EEEEEE')
            .margin({top:8,bottom:8})

          //评论总数提示
          Text('共 '+this.postDetail.comment_count.toString()+' 条评论')
            .textAlign(TextAlign.Start)
            .width('100%')
          //评论区
          ForEach(this.postDetail.comments, (comment: CommentSimple) => {
            PostCommentNew({ comment: comment })
          }, (comment: CommentSimple) => comment.comment_id.toString())
        }
        .padding({ left: 8, right: 8, bottom: 80 }) // 留出底部栏高度
        .width('100%')
      }
      .flexGrow(1) // 💡 关键
      .width('100%')
      // 底部固定栏
      PostBottomBar({
        comment_count: this.postDetail.comment_count,
        likeStats: this.postDetail.post_simple.like_stats,
        collectStats: this.postDetail.collect_stats,
        postId : this.postDetail.post_simple.post_id,
      })
        .width('100%')
        //.height(56) // 💡 设置固定高度
    }
    .width('100%')
    .height('100%')
  }
}

