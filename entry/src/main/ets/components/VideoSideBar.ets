import { playScaleAnimation } from "../commons/utils/Animations";
import { eventBus } from "../commons/utils/EventBus";
import { createEmptyPostDetail, PostDetail } from "../models/Post";
import { CollectStats, createEmptyCollectStats, createEmptyLikeStats, LikeStats } from "../models/Stats";

@Component
export struct VideoSideBar{
  private imageSize : number = 32;
  private fontSize : number = 16;
  private topImg = 6;
  private bottomImg =2;
  private bottomText = 6;
  private avatar_size = 36;
  private follow_size =14;

  @Prop
  post : PostDetail = createEmptyPostDetail();

  @State likeStats : LikeStats = createEmptyLikeStats();
  @State collectStats : CollectStats = createEmptyCollectStats();
  @State isFollowing : boolean = false;

  @State likeSize : number= 32;
  @State collectSize : number =32;

  aboutToAppear(): void {
    this.likeStats = this.post.post_simple.like_stats;
    this.collectStats = this.post.collect_stats;
    this.isFollowing = this.post.post_simple.publisher.is_followed;
  }

  build() {
    Column(){
      //头像
      Stack() {
        Image(this.post.post_simple.publisher.avatar)
          .width(this.avatar_size)
          .height(this.avatar_size)
          .borderRadius(this.avatar_size/2)
          .border({width : 2,color : Color.White})
        Image(this.isFollowing?$r('app.media.followed'):$r('app.media.follow'))
          .width(this.follow_size)
          .height(this.follow_size)
          .borderRadius(this.follow_size/2)
          .margin({top:36})
          .onClick(()=>{
            this.isFollowing = !this.isFollowing;
          })
      }
      .margin({bottom:this.bottomText})

      //点赞
      Image(this.likeStats.is_liked? $r('app.media.liked') : $r('app.media.like_white'))
        .width(this.likeSize)
        .height(this.likeSize)
        .margin({top:this.topImg,bottom:this.bottomImg})
        .onClick(()=>{
          this.likeClick();
        })
      Text(this.likeStats.like_count.toString())
        .fontSize(this.fontSize)
        .margin({bottom:this.bottomText})
        .fontColor(Color.White)

      //评论
      Image($r('app.media.comment_white'))
        .width(this.imageSize)
        .height(this.imageSize)
        .margin({top:this.topImg,bottom:this.bottomImg})
        .onClick(()=>{
          this.commentClick()
        })
      Text(this.post.comment_count.toString())
        .fontSize(this.fontSize)
        .margin({bottom:this.bottomText})
        .fontColor(Color.White)

      //收藏
      Image(this.collectStats.is_collected ? $r('app.media.collected'): $r('app.media.collect_white'))
        .width(this.collectSize)
        .height(this.collectSize)
        .margin({top:this.topImg,bottom:this.bottomImg})
        .onClick(()=>{
          this.collectClick();
        })
      Text(this.collectStats.collect_count.toString())
        .fontSize(this.fontSize)
        .margin({bottom:this.bottomText})
        .fontColor(Color.White)

      //转发
      Image($r('app.media.share_white'))
        .width(this.imageSize)
        .height(this.imageSize)
        .margin({top:this.topImg,bottom:this.bottomImg})
      Text('123')
        .fontSize(this.fontSize)
        .margin({bottom:this.bottomText})
        .fontColor(Color.White)

    }
  }

  async likeClick() {
    console.log('点击了点赞');

    // 点赞数递增或递减
    if (this.likeStats.is_liked) {
      this.likeStats.like_count -= 1
    } else {
      this.likeStats.like_count += 1
    }

    if(!this.likeStats.is_liked){
      await playScaleAnimation<VideoSideBar>((v:number)=>{this.likeSize = v},40, 32, 70, 70)
    }
    // 切换点赞状态
    this.likeStats.is_liked = !this.likeStats.is_liked
    // TODO: 可以在这里调用接口通知后端
  }

  async collectClick() {

    // 收藏数递增或递减
    if (this.collectStats.is_collected) {
      this.collectStats.collect_count -= 1;
    } else {
      this.collectStats.collect_count += 1;
    }

    if(!this.collectStats.is_collected){
      await playScaleAnimation<VideoSideBar>((v:number)=>{this.collectSize = v},40, 32, 70, 70)
    }
    // 切换收藏状态
    this.collectStats.is_collected = !this.collectStats.is_collected;

    // TODO: 这里可以调用接口同步状态
  }

  private commentClick() {
    console.info('评论被点击')
    eventBus.emit('COMMENT_CLICK', {
      type: 'comment',
      data: this.post.post_simple.post_id.toString()
    })
  }

}