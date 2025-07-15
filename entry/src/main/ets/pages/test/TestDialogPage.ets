import { TestDialog } from "../../components/test/TestDialog"

@Entry
@Component

export struct TestDialogPage{
  testDialogController : CustomDialogController = new CustomDialogController({
      builder:TestDialog(),
      alignment :DialogAlignment.Bottom
  })

  build() {
    Column() {
      Button('点击跳出弹窗')
        .width(50)
        .height(50)
        .align(Alignment.Center)
        .onClick(()=>{
          this.testDialogController.open();
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}


