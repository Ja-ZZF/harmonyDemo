//主页

import { PostCardSimple } from '../components/PostCard';
import { PostDetail, PostSimple } from '../models/Post';
import { UserSimple } from '../models/User';
import { PostService } from '../services/post.service';
import { UserService } from '../services/user.service';
import { router } from '@kit.ArkUI';

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


  async aboutToAppear(): Promise<void> {
    this.user = await this.userService.getSelf(); //获取用户信息
    this.posts = await this.postService.getAllPost(); //获取所有笔记信息

    console.info('笔记信息：',this.posts);
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {

        // 主体：两列卡片流式布局
        WaterFlow(){
          ForEach(this.posts,(post:PostSimple)=>{
            FlowItem(){
              PostCardSimple({
                post:post,
              })
                .onClick(async ()=>{
                  await router.push({
                    url:"pages/PostDetailPage",
                    params:{
                      postId:post.post_id,
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



}
