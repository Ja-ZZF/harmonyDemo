import { copyPhotosToCache, getPixelMapsFromUrls, onClickSelectPhoto } from "../commons/utils/imageHandler";
import { ImageCarousel } from "../components/ImageCarousel";
import { ImageGrid } from "../components/ImageGrid";
import { ApiService } from "../services/api.service";
import { PostService } from "../services/post.service";
import { image } from "@kit.ImageKit";
import { router } from "@kit.ArkUI";
import { CustomButton } from "../components/Buttons/CustomButton";

@Entry
@Component
export struct EditPage {
  @Prop isActive: boolean = false;
  private postService = new PostService();
  private apiService = new ApiService();

  @State title : string = '';
  @State content : string = '';
  @State urls : string[] = [] ;
  @State uploadedUrls : string[] = [];
  @State hasImage : boolean = false;

  @State imageShowingState : boolean = true;

  getHeight() {
    const IMAGE_HEIGHT = 110;
    const IMAGE_SPACING = 10;

    const imageCount = this.urls.length;
    const imagesPerRow = 3;
    const rows = Math.ceil(imageCount / imagesPerRow);
    const height = rows * (IMAGE_HEIGHT + IMAGE_SPACING) - IMAGE_SPACING;

    return height;

  }

    async aboutToAppear(){
    if(this.isActive){
      await this.addImage();
    }
  }

  build() {
    Scroll() {
      Column() {

        //顶部说明和工具栏
        Row() {
          //添加图片工具栏
          Image($r('app.media.menu'))
            .width(24)
            .height(24)
            .onClick(()=>{
              this.addImage();
            })

          Text('—— 发布新笔记 ——')
            .fontSize(16)
            .fontWeight(FontWeight.Lighter)
            .padding({ top: 6, bottom: 6})
            .textAlign(TextAlign.Center)
            .width('75%')

          //发送工具栏
          Image($r('app.media.OK'))
            .onClick(()=>{
              this.submitPost();
            })
            .width(24)
            .height(24)
        }
        .justifyContent(FlexAlign.SpaceAround)
        .width('98%')
        .margin({bottom:12})


        //图片预览
        if (this.urls.length > 0) {
          Column() {
            if (this.imageShowingState) {
              //栅格类型显示
              Column() {
                ImageGrid({ medias: this.urls })
              }
              .width('90%')
              .height(this.getHeight())
              .transition(TransitionEffect.OPACITY.animation({ duration: 1500, curve: Curve.Ease })
                .combine(TransitionEffect.scale({x:0.5,y:0.5})))
            } else {
              //滑动类型显示
              Column() {
                ImageCarousel({ medias: this.urls })
              }
              .width('90%')
              .transition(TransitionEffect.OPACITY.animation({ duration: 1500, curve: Curve.Ease})
                .combine(TransitionEffect.scale({x:0.5,y:0.5})))
            }
          }
          .gesture(
            TapGesture({ count: 2 })
              .onAction((event: GestureEvent) => {
                if (event) {
                  this.imageShowingState = !this.imageShowingState;
                }
              }))

          //分割线
          Shape()
            .height(1)
            .width('95%')
            .backgroundColor('#EEEEEE')
            .margin({top:8,bottom:8})
        }

        //标题编辑
        TextArea({ placeholder: "点击添加标题" })
          .width('100%')
          .height('5%')
          .backgroundColor(Color.White)
          .placeholderFont({
            size: 20,
            style: FontStyle.Italic,
            weight: FontWeight.Bold
          })
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .maxLength(15)
          .onChange((value) => {
            this.title = value;
          })

        //正文编辑
        TextArea({ placeholder: "点击添加内容" })
          .width('100%')
          .height('20%')
          .backgroundColor(Color.White)
          .maxLength(150)
          .showCounter(true, { thresholdPercentage: 1, highlightBorder: true })
          .placeholderFont({
            style: FontStyle.Italic,
            weight: FontWeight.Regular
          })
          .onChange((value) => {
            this.content = value;
          })

        //功能按钮
        Row(){
          CustomButton({text:'#话题'})
          CustomButton({text:'@朋友'})
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .margin({left:8})


      }
        .align(Alignment.TopStart)
        .alignItems(HorizontalAlign.Center)
        .height(900)
    }
    .width('100%')
    .padding(10)
  }

  async addImage(){
    onClickSelectPhoto(async (result, err) => {//相册选择图片
      if (err) {
        console.error("选择图片失败", err);
        return;
      }
      console.info("图片路径：", result?.photoUris);

      const newUrls : string[] = await copyPhotosToCache(result?.photoUris ?? []);

      for(const url of newUrls){
        this.urls.push(url);
      }

    });
    this.hasImage = true;
  }
  async showState(){
    console.info("标题：",this.title);
    console.info("内容：",this.content);
    console.info("图片urls",this.urls.toString());
  }

  async submitPost(){
    this.uploadedUrls = await this.apiService.uploadPostWithImages(this.urls);
    const post_id = await this.postService.addPostByUrls(this.title,this.content,this.uploadedUrls);

    router.replaceUrl({url:"pages/RootPage"})
    console.info("postId = ",post_id);
  }
}