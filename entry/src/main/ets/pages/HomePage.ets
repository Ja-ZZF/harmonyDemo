//主页

import { PostCard } from '../components/PostCard';
import { PostDetail, PostSimple } from '../models/Post';
import { UserSimple } from '../models/User';
import { PostService } from '../services/post.service';
import { UserService } from '../services/user.service';

@Entry
@Component
struct HomePage {
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

    const postDetail : PostDetail = await this.postService.getPostDetail(1);

    console.info('笔记信息：',this.posts);
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        // 顶部欢迎信息
        Text(`你好，${this.user.nickname} 👋`)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .padding({ left: 16, right: 16, top: 16 })

        // 主体：两列卡片流式布局
        Row({ space: 8 }) {
          // 左列
          Column({ space: 8 }) {
            ForEach(
              this.posts.filter((item: PostSimple, index: number) => index % 2 === 0),
              (item: PostSimple) => {
                PostCard({ post: item })
                  .width('100%')
              },
              (item: PostSimple) => item.post_id.toString()
            )
          }
          .layoutWeight(1)

          // 右列
          Column({ space: 8 }) {
            ForEach(this.posts.filter((item : PostSimple, index : number) => index % 2 === 1), (item : PostSimple) => {
              PostCard({ post: item })
                .width('100%')
            }, (item:PostSimple) => item.post_id.toString())
          }
          .layoutWeight(1)
        }
        .padding({ left: 8, right: 8, bottom: 16 })
      }
    }
  }


}
