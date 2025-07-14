import { PostDetail, PostDetailParams } from "../models/Post";
import { PostService } from "../services/post.service";
import { pdfViewManager } from "@hms.officeservice.PdfView";
import { VideoSideBar } from "../components/VideoSideBar";

@Entry
@Component
export struct HotPage {
  private postService = new PostService();

  @State videoPostIds : number[] = [];
  @State postDetailsList : PostDetail[] = [];
  @State currentIndex : number = 0;

  @State isPlaying : boolean = false;

  private videoControllers: VideoController[] = [];


  async aboutToAppear(){
    this.videoPostIds = await this.postService.getVideoPostList();

    this.postDetailsList = [];
    this.videoControllers = [];

    for(const id of this.videoPostIds){
        const postDetail = await this.postService.getPostDetail(id);
        this.postDetailsList.push(postDetail);
        this.videoControllers.push(new VideoController());
    }

    // 默认自动播放第一个视频
    if (this.videoControllers.length > 0) {
      this.videoControllers[0].start();
      this.isPlaying = true;
    }

  }

  async aboutToDisappear() {
    // 停止并释放所有视频控制器资源
    this.videoControllers.forEach(controller => {
      controller.pause(); // 暂停播放
    });
  }

  build() {
    if (this.postDetailsList.length === 0) {
      Text('加载中...')
        .fontSize(20)
        .width(300)
        .height(210)
        .textAlign(TextAlign.Center)
    } else {
        Swiper() {
          ForEach(this.postDetailsList, (post: PostDetail, index) => {
            Stack()
            {
              Video({
                src: post.post_simple.cover_url,
                controller: this.videoControllers[index]
              })
                .width('100%')// 宽度占满父容器
                .height('100%')// 固定高度
                .objectFit(ImageFit.Cover)// 保持比例裁剪显示
                .controls(false)
                .loop(true)
                .onClick(() => {
                  if (!this.isPlaying) {
                    this.videoControllers[index].start();
                  } else {
                    this.videoControllers[index].pause();
                  }
                  this.isPlaying = !this.isPlaying;
                })
              VideoSideBar({
                post : post
              })
                .width('95%')
                .height('70%')
                .align(Alignment.BottomEnd)
            }

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
              controller.start();
            } else {
              controller.pause();
            }
          });
          this.currentIndex = index;
        })




    }
  }



}