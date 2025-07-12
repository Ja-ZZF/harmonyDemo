@Component
export struct PostContentSection {
  @Prop content: string;

  build() {

    Column() {
      Text(this.content)
        .fontSize(16)
        .fontColor('#222222')
        .textAlign(TextAlign.Start)
        .lineHeight(24)
        .maxLines(1000) // 你可以在此处将其设为固定行数以实现“展开/收起”
    }
    .padding({ top: 12, bottom: 12 })
  }
}
