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
     // router.pushUrl({ url: 'pages/LoginPage' });
      //router.pushUrl({ url: 'pages/test/TestFilePage' });
      //router.pushUrl({ url: 'pages/test/TestDialogPage' });
      console.info('跳转调用结束');

    })
  }

}