import { DiscoverPage } from './DiscoverPage';
import { HomePage } from './HomePage';
import { HotPage } from './HotPage';

@Entry
@Component
struct RootPage {
  @State currentIndex : number = 0;

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
          .fontSize(18)
          .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : 'rgba(0,0,0,0.60)')
          .textAlign(TextAlign.Center)
          .lineHeight(14)
          .fontWeight(500)
      }
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
    Tabs({barPosition : BarPosition.End,controller : this.tabsController}){
      TabContent(){
        HomePage();
      }
      .tabBar(this.tabBarBuilder(0,'首页'))

      TabContent(){
        HotPage();
      }
      .tabBar(this.tabBarBuilder(1,'热门'))

      TabContent(){
        DiscoverPage()
      }
      .tabBar(this.tabBarBuilder(2,'',$r('app.media.add')))

      TabContent(){
        DiscoverPage()
      }
      .tabBar(this.tabBarBuilder(3,'消息'))

      TabContent(){
        DiscoverPage()
      }
      .tabBar(this.tabBarBuilder(4,'我的'))
    }
    .barHeight(50)
    .barOverlap(true)
    .barBackgroundBlurStyle(BlurStyle.Regular);
  }
}

