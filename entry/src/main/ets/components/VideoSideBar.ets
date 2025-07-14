import { createEmptyPostDetail, PostDetail } from "../models/Post";
import { CollectStats, createEmptyCollectStats, createEmptyLikeStats, LikeStats } from "../models/Stats";

@Component
export struct VideoSideBar{
  private imageSize : number = 32;
  private fontSize : number = 16;
  private topImg = 6;
  private bottomImg =2;
  private bottomText = 6;

  @Prop
  post : PostDetail = createEmptyPostDetail();

  @State likeStats : LikeStats = createEmptyLikeStats();
  @State collectStats : CollectStats = createEmptyCollectStats();

  aboutToAppear(): void {
    this.likeStats = this.post.post_simple.like_stats;
    this.collectStats = this.post.collect_stats;
  }

  build() {
    Column(){
      Image(this.likeStats.is_liked? $r('app.media.liked') : $r('app.media.like_white'))
        .width(this.imageSize)
        .height(this.imageSize)
        .margin({top:this.topImg,bottom:this.bottomImg})
        .onClick(()=>{
          this.likeClick();
        })
      Text(this.likeStats.like_count.toString())
        .fontSize(this.fontSize)
        .margin({bottom:this.bottomText})
        .fontColor(Color.White)

      Image($r('app.media.comment_white'))
        .width(this.imageSize)
        .height(this.imageSize)
        .margin({top:this.topImg,bottom:this.bottomImg})
      Text(this.post.comment_count.toString())
        .fontSize(this.fontSize)
        .margin({bottom:this.bottomText})
        .fontColor(Color.White)

      Image(this.collectStats.is_collected ? $r('app.media.collected'): $r('app.media.collect_white'))
        .width(this.imageSize)
        .height(this.imageSize)
        .margin({top:this.topImg,bottom:this.bottomImg})
        .onClick(()=>{
          this.collectClick();
        })
      Text(this.collectStats.collect_count.toString())
        .fontSize(this.fontSize)
        .margin({bottom:this.bottomText})
        .fontColor(Color.White)

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

  likeClick() {
    console.log('点击了点赞');
    // 切换点赞状态
    this.likeStats.is_liked = !this.likeStats.is_liked

    // 点赞数递增或递减
    if (this.likeStats.is_liked) {
      this.likeStats.like_count += 1
    } else {
      this.likeStats.like_count -= 1
    }

    // TODO: 可以在这里调用接口通知后端
  }

  collectClick() {
    // 切换收藏状态
    this.collectStats.is_collected = !this.collectStats.is_collected;

    // 收藏数递增或递减
    if (this.collectStats.is_collected) {
      this.collectStats.collect_count += 1;
    } else {
      this.collectStats.collect_count -= 1;
    }

    // TODO: 这里可以调用接口同步状态
  }

}