import { PostDetail, PostDetailParams } from "../models/Post";
import { PostService } from "../services/post.service";
import { pdfViewManager } from "@hms.officeservice.PdfView";
import { VideoSideBar } from "../components/VideoSideBar";
import { VideoBottomBar } from "../components/VideoBottomBar";
import { VideoTopBar } from "../components/VideoTopBar";
import { eventBus, EventPayload } from "../commons/utils/EventBus";
import { deviceInfo } from "@kit.BasicServicesKit";
import { CommentSimple } from "../models/Comment";
import { PostCommentNew } from "../components/PostCommentNew";
import { VideoCommentBar } from "../components/VideoCommentBar";
import { PostDetailDataSource } from "../models/LazyPost";
import { CircleShape } from "@kit.ArkUI";


@Entry
@Component
export struct HotPage {
  @Prop isActive: boolean = false; //是否活跃
  private postService = new PostService();

  //@State postDetailsList : PostDetail[] = [];
  @State videoPostIds : number[] = [];
  @State currentIndex : number = 0;

  @State isPlaying : boolean = false;
  @State isCommenting : boolean = false;

  private videoControllers: VideoController[] = [];

  @State data: PostDetailDataSource = new PostDetailDataSource();
  @State loadedCount : number = 0;


  async aboutToAppear(){
    this.videoPostIds = await this.postService.getVideoPostList();

    //this.postDetailsList = [];
    this.videoControllers = [];
    this.data = new PostDetailDataSource();

    //加载资源
    for(const id of this.videoPostIds){
        const postDetail = await this.postService.getPostDetail(id);
        //this.postDetailsList.push(postDetail);
        this.data.pushData(postDetail);
        this.videoControllers.push(new VideoController());
        this.loadedCount +=1;
    }

    // 默认自动播放第一个视频
    if (this.videoControllers.length > 0) {
      this.videoControllers[0].start();
      this.isPlaying = true;
    }

    //监听评论
    eventBus.on('COMMENT_CLICK', (payload) => {
      this.onCommentClick(payload)
    })

  }

  async aboutToDisappear() {
    // 停止并释放所有视频控制器资源
    this.videoControllers.forEach(controller => {
      controller.pause(); // 暂停播放
    });
  }

  async onPageHide() {
    // 停止并释放所有视频控制器资源
    this.videoControllers.forEach(controller => {
      controller.pause(); // 暂停播放
    });
  }

  build() {
    if (this.loadedCount <=2) {
      Column() {
        Progress({
          value: null, // 不设置 value 就是无限旋转
          type:ProgressType.Ring
        })
          .width(100)
          .height(100)
          .align(Alignment.Center)
      }

    } else {
        Swiper() {
          LazyForEach(this.data, (post: PostDetail, index) => {
            Stack({alignContent:Alignment.Center}) //覆盖布局
            {
              //视频
              Column() {
                if(this.isActive){}
                Video({
                  src: post.post_simple.cover_url,
                  controller: this.videoControllers[index]
                })
                  .width(this.isCommenting ? '45%' : '100%')// 宽度占满父容器
                  .height(this.isCommenting ? '45%' : '100%')// 固定高度
                  .objectFit(ImageFit.Cover)// 保持比例裁剪显示
                  .controls(false)
                  .loop(true)
              }
              .width('100%')// 宽度占满父容器
              .height('100%')// 固定高度
              .align(Alignment.Top)

              //顶部搜索框
              if(!this.isCommenting) {
                VideoTopBar()
                  .width('100%')
                  .height('97%')
                  .align(Alignment.Top)
              }

              //底部信息
              VideoBottomBar({
                post:post
              })
                .width('100%')
                .height('99%')
                .align(Alignment.BottomStart)

              //侧栏
              VideoSideBar({
                post : post
              })
                .width('95%')
                .height('98%')
                .align(Alignment.BottomEnd)

              //暂停按钮
              if(!this.isPlaying){
                Image($r('app.media.stop'))
                  .width('20%')
                  .align(Alignment.Center)
              }

              //显示评论区
              if(this.isCommenting){
                VideoCommentBar({post:post});
              }
            }
            .backgroundColor(Color.Black) //设置黑色背景
            .onClick(() => {
              if(!this.isCommenting) {//如果不在评论态
                if (!this.isPlaying) {
                  this.videoControllers[index].start();
                } else {
                  this.videoControllers[index].pause();
                }
                this.isPlaying = !this.isPlaying;
              }else{ //处于评论态
                animateTo({                         // 点击按钮，控制组件转场动画
                  duration: 150,                   // 设置动画的执行时长
                  curve: Curve.Linear               // 设置动画曲线
                }, () => {
                  this.isCommenting = false;       // 控制显示和隐藏
                })
              }

            })

          })
        }
        .width('100%')
        .vertical(true)
        .indicator(false)
        .curve(Curve.Friction)
        .onChange((index: number) => {
          // 切换页时播放当前视频，暂停其他视频
          this.videoControllers.forEach((controller, idx) => {
            if (idx === index) {
              this.isPlaying = true;
              this.isCommenting = false;
              controller.start();
            } else {
              controller.pause();
            }
          });
          this.currentIndex = index;
        })

    }
  }

  private onCommentClick(payload: EventPayload) {
    console.info('父组件捕获评论点击', payload)
    animateTo({                         // 点击按钮，控制组件转场动画
      duration: 150,                   // 设置动画的执行时长
      curve: Curve.Linear               // 设置动画曲线
    }, () => {
      this.isCommenting = true;       // 控制显示和隐藏
    })

  }


}