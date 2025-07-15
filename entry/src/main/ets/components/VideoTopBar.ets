@Component
export  struct  VideoTopBar{

  build() {
    Row(){
      TextInput({placeholder:"请输入文本"})
        .width('100%')
        .backgroundBlurStyle(BlurStyle.COMPONENT_THIN)
    }
      .width('98%')
      .align(Alignment.Top)
  }
}