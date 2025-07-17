import { DiscoverPage } from './DiscoverPage';
import { EditPage } from './EditPage';
import { HomePage } from './HomePage';
import { HotPage } from './HotPage';


@Entry
@Component
struct RootPage {

  @State currentIndex : number = 0;

  private  tabsController : TabsController = new TabsController();

  getIcon(){
    if(this.currentIndex == 1){
      return $r('app.media.add_white');
    }
    else if(this.currentIndex == 2){
      return $r('app.media.add_on');
    }else{
      return $r('app.media.add');
    }
  }

  @Builder
  tabBarBuilder(targetIndex: number, title?: string, icon?: Resource) {
    Column() {
      if(icon) {
        Image(this.getIcon())
          .width(36)
          .height(36)
          .padding({bottom : 4})
      }

      if(title) {
        Text(title)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(18)
          .fontColor(this.currentIndex === 1 ? Color.White : Color.Black)
          .textAlign(TextAlign.Center)
          .lineHeight(14)
          .fontWeight(this.currentIndex === targetIndex ? FontWeight.Bolder : FontWeight.Normal)
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
        HomePage({isActive : this.currentIndex === 0});
      }
      .tabBar(this.tabBarBuilder(0,'首页'))

      TabContent(){
        HotPage({isActive : this.currentIndex === 1});
      }
      .tabBar(this.tabBarBuilder(1,'热门'))

      TabContent(){
        EditPage({ isActive : this.currentIndex == 2 });
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
    .barBackgroundColor(this.currentIndex === 1 ?Color.Black : Color.White)
    .animationDuration(0)
    // .barOverlap(true)
    // .barBackgroundBlurStyle(BlurStyle.Regular);
  }

}

