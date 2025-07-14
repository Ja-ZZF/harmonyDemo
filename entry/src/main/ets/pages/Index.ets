//入口 直接转loginPage

import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {


  build() {
    Column() {
      Text('正在跳转到登录页...')
    }
    .onAppear(() => {
      console.info('准备跳转');
      router.pushUrl({ url: 'pages/RootPage' });
      //router.pushUrl({ url: 'pages/HomePage' });
      //router.pushUrl({ url: 'pages/PostDetailPage' });
      //router.pushUrl({ url: 'pages/LoginPage' });
      console.info('跳转调用结束');

    })
  }

}