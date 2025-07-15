@Entry
@Component
struct TestAnimationPage {
  @State message: string = 'Hello World';

  @State scaleValue : number = 80;

  private bigValue : number= 100;
  private smallValue : number = 80;

  @State liked : boolean = false;

  build() {
      Column() {
        Image(this.liked?$r('app.media.liked'):$r('app.media.like'))
          .width(this.scaleValue)
          .height(this.scaleValue)
          .align(Alignment.Center)
          .onClick(() => {
            if(!this.liked) {
              this.animateLike()
            }else{
              this.liked = false;
            }
          })
      }
      .width('100%')
      .height('100%')
      .align(Alignment.Center)
      .justifyContent(FlexAlign.Center)           // 控制垂直方向
  }

  async animateLike() {
    // 先放大
    animateTo({duration: 70,
      tempo: 1,
      curve: Curve.Sharp,
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish:()=>{}},()=>{
        this.scaleValue =this.bigValue})

    // 再缩小
    animateTo({duration: 200,
      tempo: 1,
      curve: Curve.Sharp,
      delay: 100,
      iterations: 1,
      playMode: PlayMode.Normal,
      onFinish:()=>{}},()=>{
      this.scaleValue =this.smallValue;
      this.liked =true;
    })
  }
}