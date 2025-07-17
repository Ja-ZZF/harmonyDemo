//主页

import { PostCardSimple } from '../components/PostCard';
import { PostDetail, PostSimple } from '../models/Post';
import { UserSimple } from '../models/User';
import { PostService } from '../services/post.service';
import { UserService } from '../services/user.service';
import { router } from '@kit.ArkUI';
import { PostSimpleDataSource } from '../models/LazyPost';

@Entry
@Component
export struct DiscoverPage {
  private userService = new UserService(); //用户服务
  private postService = new PostService(); //笔记服务

  @State user : UserSimple = {
    user_id : 0,
    nickname : '',
    avatar: '',
    email : '',
    is_followed: false,
  };
  @State posts : PostSimple[]=[];
  @State data : PostSimpleDataSource = new PostSimpleDataSource();
  @State loadedCount : number = 0;

  @State isRefreshing: boolean = false;


  async aboutToAppear(): Promise<void> {
    this.user = await this.userService.getSelf(); //获取用户信息
    this.posts = await this.postService.getAllPost(); //获取所有笔记信息

    for(const post of this.posts){//添加到懒数据
        this.data.pushData(post);
        this.loadedCount += 1;
    }

    console.info('笔记信息：',this.posts);
  }

  build() {
    if(this.loadedCount <=3){
      Column() {
        Progress({
          value: null, // 不设置 value 就是无限旋转
          type:ProgressType.Ring
        })
          .width(100)
          .height(100)
          .align(Alignment.Center)
      }
    }
    else {
      Refresh({refreshing :$$this.isRefreshing}) {
        Scroll() {
          Column({ space: 16 }) {

            // 主体：两列卡片流式布局
            WaterFlow() {
              LazyForEach(this.data, (post: PostSimple) => {
                FlowItem() {
                  PostCardSimple({
                    post: post,
                  })
                    .transition(TransitionEffect.OPACITY.animation({
                      duration: Math.floor(Math.random() * (3000 - 500 + 1)) + 500,
                      curve: Curve.Friction
                    })
                      .combine(TransitionEffect.scale({ x: 0.5, y: 0.5 })))
                    .onClick(async () => {
                      await router.push({
                        url: "pages/PostDetailPage",
                        params: {
                          postId: post.post_id,
                        }
                      })
                    })
                }
              })
            }
            .columnsTemplate('1fr 1fr')
            .columnsGap(4)
            .rowsGap(4)
          }
        }
        .backgroundColor('rgba(0,0,0,0.05)')
      }
      .onRefreshing(() => {
        setTimeout(async () => {
          this.isRefreshing = false;
          this.posts = await this.postService.getAllPost(); //获取所有笔记信息

          this.data.dataArray = [];

          for(const post of this.posts){//添加到懒数据
            this.data.pushData(post);
            this.loadedCount += 1;
          }
        }, 1000)
        console.log('onRefreshing test');
      })
      .refreshOffset(64)
      .pullToRefresh(true)
    }

    }



}
