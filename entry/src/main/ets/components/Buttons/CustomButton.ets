@Component
export struct CustomButton{
  @Prop text : string;
  @Prop buttonColor : string = '#EEEEEE'
  build() {
    Button(this.text)
      .type(ButtonType.Capsule)
      .backgroundColor(this.buttonColor)
      .fontSize(12)
      .fontWeight(FontWeight.Normal)
      .fontStyle(FontStyle.Italic)
      .fontColor(Color.Black)
      .margin({left:4,right:4})
      .shadow({radius:4,color:'#DDDDDD'})
  }
}