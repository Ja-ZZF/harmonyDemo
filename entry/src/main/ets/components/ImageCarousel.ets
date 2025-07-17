import { image } from "@kit.ImageKit";
import { getPixelMapsFromUrls } from "../commons/utils/imageHandler";

@Component
export struct ImageCarousel {

  @Prop medias: string[] = [];
  @State currentIndex: number = 0;

  @State images :image.PixelMap[] = []

  async aboutToAppear(): Promise<void> {
    this.images = await getPixelMapsFromUrls(this.medias);
  }

  build() {
    Column({ space: 8 }) {
      // Swiper 不传参数，只写内容
      Swiper() {
        ForEach(this.images, (media: image.PixelMap, index: number) => {
          Image(media)
            .width('100%')
            .aspectRatio(3 / 4)
            .objectFit(ImageFit.Cover)
        })
      }
      .onChange(index => {
        this.currentIndex = index;
      })
      .indicator(false)

      // 圆点指示器
      if (this.images.length > 1) {
        Row({ space: 6 }) {
          ForEach(this.images, (media: image.PixelMap, index: number) => {
            Circle()
              .width(8)
              .height(8) // 宽高相等 = 正圆
              .fill(index === this.currentIndex
                ? Color.Blue // 当前页 蓝色
                : Color.Grey // 其他页 灰色
              )
          })
        }
        .alignSelf(ItemAlign.Center)
        .margin({ top: 4 })
      }
    }
  }

}
