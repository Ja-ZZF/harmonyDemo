import { eventBus } from "../../commons/utils/EventBus";

@CustomDialog
export struct SaveImageDialog {
  controller: CustomDialogController;

  build(){
    Column(){
      Text('是否保存图片？')
        .fontSize(12)
        .fontWeight(FontWeight.Bold)
        .margin({top:8,bottom:12})
      Row(){
        Button('是')
          .onClick(()=>{
            //保存图片
            eventBus.emit('saveImage', { type: 'saveImage', data: 'hhh'});
            this.controller.close();
          })
          .width('40%')
          .backgroundColor(Color.Blue)
          .fontColor(Color.White)
        Button('否')
          .onClick(()=>{
            this.controller.close();
          })
          .width('40%')
          .backgroundColor(Color.Grey)
          .fontColor(Color.White)
      }
      .justifyContent(FlexAlign.SpaceEvenly)
    }
    .padding(12)
    .width('100%')
    .height('18%')
    .backgroundColor('#F9F9F9')
    .borderRadius(12)
  }

}
