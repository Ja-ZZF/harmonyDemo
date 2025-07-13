import { MediaSimple } from '../models/Media';

@Component
export struct PostImageCarousel {
  @Prop medias: MediaSimple[] = [];

  @State currentIndex: number = 0;

  build() {
    Column({ space: 8 }) {
      // Swiper 不传参数，只写内容
      Swiper() {
        ForEach(this.medias, (media: MediaSimple, index: number) => {
          Image(media.url)
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
      if (this.medias.length > 1) {
        Row({ space: 6 }) {
          ForEach(this.medias, (media: MediaSimple, index: number) => {
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
    .width('100%')
  }
}
