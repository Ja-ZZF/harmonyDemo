import { CommentCard } from '../components/CommentCard';
import { PostContentSection } from '../components/PostContent';
import { CommentSimple } from '../models/Comment';
import { PostDetail } from '../models/Post';
import { PostService } from '../services/post.service'

@Entry
@Component
struct PostDetailPage {
  private postService = new PostService();

  @State comments: CommentSimple[] = [];   // 评论列表
  @State content : string = ''
  @State isLoading: boolean = true;        // 加载状态
  private postId: number = 1;              // 假设是从外部传入的 post_id

  async aboutToAppear(): Promise<void> {
    const detail: PostDetail = await this.postService.getPostDetail(this.postId);
    this.comments = detail.comments;
    this.content = detail.content;
    this.isLoading = false;

    console.info('评论数据：', JSON.stringify(this.comments));
  }

  build() {
    Scroll() {
      Column({ space: 12 }) {
        // 标题或简要占位符
        Text('详细页面')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .padding({ top: 16, left: 16 })
        PostContentSection({content : this.content});

        // 评论列表
        ForEach(this.comments, (comment: CommentSimple) => {
          CommentCard({ comment: comment })
        }, (comment: CommentSimple) => comment.comment_id.toString())
      }
      .padding({ left: 16, right: 16, bottom: 16 })
    }
  }

}