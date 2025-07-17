import { image } from "@kit.ImageKit";
import { getPixelMapsFromUrls } from "../commons/utils/imageHandler";

//表格组件
@Component
export struct ImageGrid {

  @Prop medias: string[] = [];

  @State images :image.PixelMap[] = []

  async aboutToAppear(): Promise<void> {
    this.images = await getPixelMapsFromUrls(this.medias);
  }


  build() {
    if(this.images.length>0){
      Column() {
        Grid(){
          ForEach(this.images,(media:image.PixelMap)=>{
            GridItem(){
              Image(media)
                .width('100%')                // 填充 GridItem 宽度
                .aspectRatio(1)               // 宽高比为 1:1（自动计算高度）
                .objectFit(ImageFit.Cover)    // 居中裁剪，保持比例
                .borderRadius(4)              // 可选：添加圆角
            }
          })
        }
        .columnsTemplate("1fr 1fr 1fr")     // 设置Grid为3列，并且均分
        .columnsGap(10)                     // 设置列间距为10vp
        .rowsGap(10)                        // 设置行间距为10vp
        .width('100%')
      }
    }

  }

}
