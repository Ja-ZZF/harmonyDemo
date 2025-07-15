import { Core } from "@ohos/hypium";
import { createEmptyPostDetail, PostDetail } from "../models/Post";

@Component
export struct VideoBottomBar{
  @Prop post : PostDetail = createEmptyPostDetail();

  private name_size = 18;
  private title_size =14;

  build() {
    Column(){
      Text('@'+this.post.post_simple.publisher.nickname)
        .fontSize(this.name_size)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .padding({left:4})
        .margin({left:8,bottom:12})
      Text(this.post.post_simple.title)
        .maxLines(1)
        .fontSize(this.title_size)
        .fontColor(Color.White)
        .width('100%')
        .padding({left:4})
        .margin({left:8,bottom:12})
    }
    .width('100%')
  }
}