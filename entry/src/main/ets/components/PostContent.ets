import { generateRandomColor } from "../commons/utils/ColorUtils";
import { formatTime } from "../commons/utils/TimeUtils";
import { TagSimple } from "../models/Tags";
import { CustomButton } from "./Buttons/CustomButton";

@Component
export struct PostContent {
  @Prop title: string;
  @Prop content: string;
  @Prop tags: TagSimple[];
  @Prop publish_time: Date;

  build() {
    Column() {
      //标题
      Text(this.title)
        .fontSize(24)
        .fontColor('#000000')
        .fontWeight('bold')
        .lineHeight(32)
        .width('100%')
        .margin({bottom:6})
        .textAlign(TextAlign.Start)

      //正文
      Text(this.content)
        .fontSize(16)
        .fontColor('#222222')
        .lineHeight(24)
        .maxLines(1000)
        .width('100%')
        .textAlign(TextAlign.Start)

      //tags
      Row({
        space: 8,
      }) {
        ForEach(this.tags, (tag : TagSimple) => {
          CustomButton({text:tag.name,buttonColor:generateRandomColor()})
        });
      }
      .margin({ top: 12 })
      .width('100%')

      // 发布时间
      Text(formatTime(this.publish_time))
        .fontSize(12)
        .fontColor('#888888')
        .textAlign(TextAlign.Start)
        .width('100%')
        .margin({top : 12})
    }
    .padding({ top: 12 })
    .width('100%')
  }
}
