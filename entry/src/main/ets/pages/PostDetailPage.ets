import { PostAppBar } from '../components/PostAppBar';
import { PostBottomBar} from '../components/PostBottomBar'
import { CommentSimple } from '../models/Comment';
import { createEmptyPostDetail, PostDetail, PostDetailParams } from '../models/Post';
import { PostService } from '../services/post.service'
import { PostImageCarousel } from '../components/PostImageCarousel';
import { PostContent } from '../components/PostContent';
import { PostCommentNew } from '../components/PostCommentNew';
import { eventBus, EventPayload } from '../commons/utils/EventBus';
import { convertMediaUrls } from '../commons/utils/MediaUtils';
import { router } from '@kit.ArkUI';
import { getHeight } from '../commons/utils/imageHandler';
import { PostImageGrid } from '../components/PostImageGrid';


@Entry
@Component
struct PostDetailPage {
  private postService = new PostService();

  private postId: number = 1;              // 假设是从外部传入的 post_id

  @State postDetail: PostDetail = createEmptyPostDetail();

  @State imageShowingState : boolean = false;


  async aboutToAppear(): Promise<void> {
    const params = router.getParams() as PostDetailParams; //提取参数
    this.postId = params.postId ?? 0; //提取id
    this.postDetail = await this.postService.getPostDetail(this.postId); //提取笔记详情

    eventBus.on('refreshPostComments', async (payload: EventPayload) => {
      if (payload.type === 'refresh' && Number(payload.data) === this.postId) {
        console.info('刷新');
        //await this.refreshComments();
        await this.refreshDetails();
      }
    });

  }

  async refreshComments(): Promise<void> {
    console.info('正在刷新评论...');
    const detail = await this.postService.getPostDetail(this.postId);
    this.postDetail.comments = detail.comments;
    this.postDetail.comment_count = detail.comment_count;
  }

  async refreshDetails() : Promise<void>{
    console.info('正在刷新全部...');
    const newDetail = await this.postService.getPostDetail(this.postId);

    this.postDetail = {
      post_simple : newDetail.post_simple,
      content : newDetail.content,
      medias : newDetail.medias,
      permission : newDetail.permission,
      publish_time : newDetail.publish_time,
      collect_stats : newDetail.collect_stats,
      browse_count : newDetail.browse_count,
      comment_count : newDetail.comment_count,
      tags : newDetail.tags,
      comments : newDetail.comments,
    }

    console.info('全部评论：',JSON.stringify(this.postDetail.comments));
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

          //图片区域
          Column() {
            if(this.imageShowingState){
              Column() {
                PostImageGrid({medias: convertMediaUrls(this.postDetail.medias, 'medium') })
              }
                .align(Alignment.TopStart)
                .width('90%')
                .height(getHeight(this.postDetail.medias.length))
                .transition(TransitionEffect.OPACITY.animation({ duration: 1500, curve: Curve.Ease })
                  .combine(TransitionEffect.scale({x:0.5,y:0.5})))
            }else {
              //图片
              PostImageCarousel({ medias: convertMediaUrls(this.postDetail.medias, 'medium'),cover_url : this.postDetail.post_simple.cover_url})
                .transition(TransitionEffect.OPACITY.animation({ duration: 1500, curve: Curve.Ease })
                  .combine(TransitionEffect.scale({x:0.5,y:0.5})))
            }
          }
          .width('100%')
          .gesture(
            TapGesture({ count: 2 })
              .onAction((event: GestureEvent) => {
                if (event) {
                  this.imageShowingState = !this.imageShowingState;
                }
              }))

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

          // 悬浮固定栏
          if(this.imageShowingState) {
            PostBottomBar({
              comment_count: this.postDetail.comment_count,
              likeStats: this.postDetail.post_simple.like_stats,
              collectStats: this.postDetail.collect_stats,
              postId: this.postDetail.post_simple.post_id,
            })
              .width('100%')
          }

          //评论总数提示
          Text('共 '+this.postDetail.comment_count.toString()+' 条评论')
            .textAlign(TextAlign.Start)
            .width('100%')
          //评论区
          ForEach(this.postDetail.comments, (comment: CommentSimple) => {
            PostCommentNew({ comment: comment })
          }, (comment: CommentSimple) => comment.comment_id.toString())
          //如果评论为空
          if(this.postDetail.comment_count === 0){
            Image($r('app.media.write'))
              .width('15%')
              .margin({top:12})
            Text('评论空空如也')
              .fontSize(12)
              .fontWeight(FontWeight.Lighter)
              .fontStyle(FontStyle.Italic)
          }

        }
        .padding({ left: 8, right: 8, bottom: 8}) // 留出底部栏高度
        .width('100%')
      }
      .width('100%')

      // 底部固定栏
      if(!this.imageShowingState) {
        PostBottomBar({
          comment_count: this.postDetail.comment_count,
          likeStats: this.postDetail.post_simple.like_stats,
          collectStats: this.postDetail.collect_stats,
          postId: this.postDetail.post_simple.post_id,
        })
          .width('100%')
      }

    }
    .width('100%')
    .height('100%')
  }
}

