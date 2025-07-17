@Component
export  struct  VideoTopBar{

  build() {
    Row(){
      Search()
        .width('100%')
        .searchButton('搜索')
        .backgroundBlurStyle(BlurStyle.COMPONENT_THIN)
    }
      .width('98%')
      .align(Alignment.Top)
  }
}