import { BusinessError } from '@kit.BasicServicesKit'
// import {  MinePage_MyCollections } from './MinePage_MyCollections'
// import { MinePage_MyLikes } from './MinePage_MyLikes'
// import {MinePage_MyPosts} from './MinePage_MyPosts'
import { createEmptyUserDetail, UserDetail } from '../models/User'
import { ApiService } from '../services/api.service'
import { AuthService } from '../services/auth.service'
import { JSON } from '@kit.ArkTS'
import { HomePage } from './HomePage'
import { DiscoverPage } from './DiscoverPage'
import StatusPage from './StatePage'


@Entry
@Component
export struct MinePage {
  private authService = new AuthService();
  @State showStatusLayer: boolean = false;
  private apiService = new ApiService();
  private userId : number = Number(AuthService.getUserId(getContext(this)));
  @State currentTabIndex: number = 0;
  @State userDetail:UserDetail =createEmptyUserDetail();
  async aboutToAppear(): Promise<void> {
    this.userId = Number(AuthService.getUserId(getContext(this)))
    console.info(this.userId.toString())
    this.userDetail = await this.apiService.get<UserDetail>('users/detail?target_id='+this.userId.toString())
    console.info("用户信息",JSON.stringify(this.userDetail))
  }

  build() {
    if (this.userDetail) {
      Column() {

        Row() {
          Image($r('app.media.list'))
            .width(24)
            .height(24)
            .onClick(() => {
              this.showStatusLayer = true;
            });

          Column().layoutWeight(1);

          Image($r('app.media.share'))
            .width(24)
            .height(24)
            .onClick(() => {
              let uiContext: UIContext = this.getUIContext();
              let router = uiContext.getRouter();
              router.pushUrl({ url: 'pages/SearchPage' }).catch(() => {});
            });

        }
        .height(50)
        .backgroundColor(Color.Gray)
        .alignItems(VerticalAlign.Center)
        .padding({ left: 16, right: 16 });

        // 上半部分：用户信息区
        Column() {
          // 头像 + 昵称 + 账号
          Row() {
            Image(this.userDetail.user_simple.avatar)
              .borderRadius(64)
              .margin({ top: 16, right: 16 })
              .width(90)
              .height(90)

            Column() {
              Text(this.userDetail.user_simple.nickname)
                .fontSize(32)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)

              Text('账号：' + this.userId)
                .fontSize(20)
                .fontColor(Color.White)
                .margin({ top: 4 })
            }
            .justifyContent(FlexAlign.Center)
            .alignItems(HorizontalAlign.Start)
          }
          .alignItems(VerticalAlign.Center)
          .width('100%')
          .justifyContent(FlexAlign.Start)

          // 简介
          Text(this.userDetail.introduction)
            .fontSize(18)
            .fontColor(Color.White)
            .margin({ top: 24 })
            .width('100%')
            .textAlign(TextAlign.Start)

          // 关注、粉丝、获赞、收藏
          Row() {
            Column() {
              Text(this.userDetail.follow_stats.followee_count.toString())
                .fontSize(20)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
              Text('关注')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .alignItems(HorizontalAlign.Center)
            .layoutWeight(1)

            Column() {
              Text(this.userDetail.follow_stats.follower_count.toString())
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('粉丝')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .alignItems(HorizontalAlign.Center)
            .layoutWeight(1)

            Column() {
              Text(this.userDetail.like_count.toString())
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('获赞')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .alignItems(HorizontalAlign.Center)
            .layoutWeight(1)

            Column() {
              Text(this.userDetail.collect_count.toString())
                .fontSize(20)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.White)
              Text('收藏')
                .fontSize(16)
                .fontColor(Color.White)
            }
            .alignItems(HorizontalAlign.Center)
            .layoutWeight(1)
          }
          .margin({ top: 32 })

          // 编辑资料 & 设置按钮
          Row() {
            Button() {
              Row() {
                Text('编辑资料')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(Color.White)
              }
              .alignItems(VerticalAlign.Center)
              .justifyContent(FlexAlign.Center)
              .width('100%')
              .height('100%')
            }
            .type(ButtonType.Capsule)
            .backgroundColor('#808080')
            .borderColor(Color.White)
            .borderWidth(2)
            .width(120)
            .height(40)
            .borderRadius(20)
            .margin({ right: 24 })
            .onClick(() => {
              let uiContext: UIContext = this.getUIContext();
              let router = uiContext.getRouter();
              router.pushUrl({ url: 'pages/EditProfile' })
                .then(() => console.info('跳转到编辑资料页成功'))
                .catch((err: BusinessError) => {
                  console.error(`跳转失败: Code=${err.code}, Message=${err.message}`);
                });
            })

            Image($r('app.media.setting'))
              .width(24)
              .height(24)
              .onClick(() => {
                let uiContext: UIContext = this.getUIContext();
                let router = uiContext.getRouter();
                router.pushUrl({ url: 'pages/Editing' })
                  .then(() => console.info('跳转到设置页成功'))
                  .catch((err: BusinessError) => {
                    console.error(`跳转失败: Code=${err.code}, Message=${err.message}`);
                  });
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.End)
          .margin({ top: 24 })
        }
        .backgroundColor("#808080")
        .width('100%')
        .height('45%')
        .padding({ left: 16, right: 16 })

        // 下半部分：切换标签
        Row() {
          Text('我的发布')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.currentTabIndex === 0 ? Color.Black : Color.Gray)
            .onClick(() => this.currentTabIndex = 0)

          Text('收藏')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.currentTabIndex === 1 ? Color.Black : Color.Gray)
            .onClick(() => this.currentTabIndex = 1)

          Text('赞过')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.currentTabIndex === 2 ? Color.Black : Color.Gray)
            .onClick(() => this.currentTabIndex = 2)
        }
        .width('100%')
        .height(50)
        .alignItems(VerticalAlign.Top)
        .padding(16)
        .justifyContent(FlexAlign.SpaceAround)

        // 分界线
        Shape()
          .height(1)
          .width('100%')
          .backgroundColor(Color.Black)

        // 内容展示
        if ([0].includes(this.currentTabIndex)) {
          DiscoverPage()
        }
        else if ([1].includes(this.currentTabIndex)){
          DiscoverPage()
        }
        else{
          DiscoverPage()
        }
      }
      .width('100%')
      .height('100%')

      if (this.showStatusLayer) {
        Column()
          .width('100%')
          .height('100%')
          .backgroundColor("#96000000")
          .onClick(() => {
            this.showStatusLayer = false;
          });

        StatusPage()
          .position({ left: 0, top: 0 })
          .width('75%')
          .height('100%')
          .backgroundColor(Color.White);
      }

    }
  }
}
