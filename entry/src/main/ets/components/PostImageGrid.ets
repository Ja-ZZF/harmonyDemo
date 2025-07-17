import { MediaSimple } from "../models/Media";

//表格组件
@Component
export struct PostImageGrid {

  @Prop medias: MediaSimple[] = [];

  build() {
    if(this.medias.length>0){
      Column() {
        Grid(){
          ForEach(this.medias,(media:MediaSimple)=>{
            GridItem(){
              Image(media.url)
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
