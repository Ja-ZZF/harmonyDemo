import { eventBus, EventPayload } from '../commons/utils/EventBus';
import { MediaSimple } from '../models/Media';
import { ApiService } from '../services/api.service';
import { SaveImageDialog } from './Dialog/SaveImageDialog';

@Component
export struct PostImageCarousel {
  private apiService = new ApiService();

  @Prop medias: MediaSimple[] = [];
  @State currentIndex: number = 0;

  imageDialogController : CustomDialogController = new CustomDialogController({
    builder : SaveImageDialog({
    }),
    alignment : DialogAlignment.Bottom,
  })

  aboutToAppear() {
    eventBus.on('saveImage', this.handleSaveImage.bind(this));
  }

  


  build() {
    Column({ space: 8 }) {
      // Swiper 不传参数，只写内容
      Swiper() {
        ForEach(this.medias, (media: MediaSimple, index: number) => {
          Image(media.url)
            .width('100%')
            .aspectRatio(3 / 4)
            .objectFit(ImageFit.Cover)
            .gesture(
              // 绑定可以重复触发的LongPressGesture
              LongPressGesture({ repeat: false })
                .onAction((event: GestureEvent|undefined) => {
                  if(event){
                    this.imageDialogController.open();
                  }
                }
                ))
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

  private handleSaveImage(payload: EventPayload) {
    if (payload.type === 'saveImage' && payload.data) {
      console.info('收到保存请求:', payload.data);
      this.apiService.downloadFileNew(this.medias[this.currentIndex].url);
    }
  }
}
