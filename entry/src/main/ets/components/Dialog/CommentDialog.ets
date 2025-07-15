import { CommentService } from '../../services/comment.service';
import { picker } from '@kit.CoreFileKit';
import { eventBus } from '../../commons/utils/EventBus';

@CustomDialog
export struct CommentDialog {
  controller: CustomDialogController;
  @State textInputValue: string = '';
  @State imagePath: string = ''; // 预览的图片路径
  @Prop postId : number = 0;
  @Prop parentCommentId : number|null = 0;

  private commentService = new CommentService();

  build() {
    Column() {
      Text('新增评论')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
        .padding({ bottom: 12 })
        .textAlign(TextAlign.Start)
        .align(Alignment.Top)

      // 文本输入
      TextInput({ text: this.textInputValue, placeholder: '请输入你的评论...' })
        .width('100%')
        .height(60)
        .borderRadius(8)
        .backgroundColor('#F5F5F5')
        .padding(8)
        .fontSize(14)
        .fontColor('#000000')
        .align(Alignment.TopStart)
        .onChange((value: string) => {
          this.textInputValue = value;
          console.log('当前id：',this.postId);
        })

      //图片上传 + 发送
      Row() {
        // 图片上传
        Row() {
          Image($r('app.media.add')) // 替换成你的上传图标资源
            .width(60)
            .height(60)
            .onClick(() => {
              this.pickImage();
            })
            .padding(8)  // 增加点击范围
          if (this.imagePath !== '') {
            Image(this.imagePath)
              .width(60)
              .height(60)
              .borderRadius(6)
              .margin({ left: 12 })
          }
        }
        .margin({ top: 12 })

        // 按钮区
        Row({ space: 12 }) {
          Button('确认')
            .fontSize(14)
            .fontColor(Color.White)
            .backgroundColor('#317AFF')
            .borderRadius(20)
            .padding({
              left: 16,
              right: 16,
              top: 8,
              bottom: 8
            })
            .onClick(async () => {

              await this.commentService.createComment(this.postId,this.textInputValue,this.parentCommentId);

              // 确认逻辑：可传 this.textInputValue 和 this.imagePath
              eventBus.emit('refreshPostComments', { type: 'refresh', data: this.postId.toString() });

              this.controller.close();
            })

        }
        .margin({ top: 16 })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(16)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)

  }

  async pickImage() {
    //从相册选择
    let PhotoSelectOptions = new picker.PhotoSelectOptions();
    PhotoSelectOptions.MIMEType = picker.PhotoViewMIMETypes.IMAGE_TYPE;
    PhotoSelectOptions.maxSelectNumber = 1;
    let photoPicker = new picker.PhotoViewPicker();
    photoPicker.select(PhotoSelectOptions).then(async (PhotoSelectResult) => {
      if (PhotoSelectResult.photoUris.length) {
        console.log(`图片本地路径：${PhotoSelectResult.photoUris[0]}`)
      }
    })
  }
}
