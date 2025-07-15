//登录页 成功后转主页

import { router } from '@kit.ArkUI';
import { AuthService } from '../services/auth.service';

@Entry
@Component
struct LoginPage {
  //实例化 AuthService
  private authService = new AuthService();


  // 登录相关状态
  @State email: string = '';
  @State password: string = '';


  //登录
  async login() {
    try {
      const response = await this.authService.login(this.email, this.password); //从authService获取token和id
      console.info('登录成功');
      console.info('Token：', response.access_token);
      console.info('id：', response.user_id);

      await router.pushUrl({ url: 'pages/RootPage' }); //跳转
    } catch (err) {
      console.error('登录失败');
    }
  }

  build() {
    Column() {

      // 邮箱输入框
      TextInput({placeholder:'请输入邮箱'})
        .onChange((value: string) => {
          this.email = value;
        })
        .margin({ top: 30 })

      // 密码输入框
      TextInput({placeholder:'请输入密码'})
        .onChange((value: string) => {
          this.password = value;
        })
        .type(InputType.Password) // ArkUI标准写法，用 InputType.Password 处理密码
        .margin({ top: 20 })

      // 登录按钮
      Button('登录')
        .onClick(() => {
          this.login();
        })
        .margin({ top: 20 })
    }
  }

}