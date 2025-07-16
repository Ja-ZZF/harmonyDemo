import { DiscoverPage } from './DiscoverPage';

@Entry
@Component
export struct HomePage {
  @Prop isActive: boolean = false;
  @State currentIndex : number = 1;

  private  tabsController : TabsController = new TabsController();

  @Builder
  tabBarBuilder(targetIndex: number, title?: string, icon?: Resource) {
    Column() {
      if(icon) {
        Image(icon)
          .width(25)
          .height(25)
      }

      if(title) {
        Text(title)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(14)
          .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : 'rgba(0,0,0,0.60)')
          .textAlign(TextAlign.Center)
          .lineHeight(14)
          .fontWeight(500)
          .margin({bottom: 6})
      }
      Divider()
        .width(24)
        .strokeWidth(2)
        .color('#0A59F7')
        .opacity(this.currentIndex === targetIndex ? 1 : 0)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex
      this.tabsController.changeIndex(targetIndex)
    })
  }

  build() {
    Tabs({barPosition : BarPosition.Start,controller : this.tabsController}) {
      TabContent() {
        DiscoverPage()
      }
      .tabBar(this.tabBarBuilder(0, '关注'))

      TabContent() {
        DiscoverPage()
      }
      .tabBar(this.tabBarBuilder(1, '发现'))

      TabContent() {
        DiscoverPage()
      }
      .tabBar(this.tabBarBuilder(2, '圈子'))
    }
    .barMode(BarMode.Fixed)
    .barWidth('40%')
    .barHeight('4%')

  }
}