import { copyPhotosToCache, onClickSelectPhoto } from "../commons/utils/imageHandler";
import { ImageCarousel } from "../components/ImageCarousel";
import { ApiService } from "../services/api.service";
import { PostService } from "../services/post.service";

@Entry
@Component
export struct EditPage {
  @Prop isActive: boolean = false;
  private apiService = new ApiService();
  private postService = new PostService();

  @State title : string = '';
  @State content : string = '';
  @State urls : string[] = [] ;
  @State uploadedUrls : string[] = [];

  aboutToAppear(): void {
    this.addImage();
  }

  build() {
    Column() {
      if(this.urls.length > 0){
        ImageCarousel({medias:this.uploadedUrls});
      }
      Text('发布新笔记')
        .width('100%')
        .align(Alignment.Center)
      TextInput({ placeholder: "请输入标题" })
        .onChange((value)=>{
          this.title = value;
        })
      TextInput({placeholder:"请输入内容"})
        .onChange((value)=>{
          this.content = value;
        })

      Button('点击查看状态')
        .onClick(()=>{
          this.showState();
      })
      Button('点击提交')
        .onClick(()=>{
          this.submitPost();
        })
    }
  }

  async addImage(){
    onClickSelectPhoto(async (result, err) => {//相册选择图片
      if (err) {
        console.error("选择图片失败", err);
        return;
      }
      console.info("图片路径：", result?.photoUris);

      this.urls = await copyPhotosToCache(result?.photoUris ?? []);
      this.uploadedUrls = await this.apiService.uploadPostWithImages(this.urls);
    });
  }
  async showState(){
    console.info("标题：",this.title);
    console.info("内容：",this.content);
    console.info("图片urls",this.urls.toString());
  }

  async submitPost(){
    const post_id = await this.postService.addPostByUrls(this.title,this.content,this.uploadedUrls);
    console.info("postId = ",post_id);
  }
}