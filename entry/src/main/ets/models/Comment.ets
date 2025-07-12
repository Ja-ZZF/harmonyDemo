import { MediaSimple } from "./Media";
import { LikeStats } from "./Stats";
import { UserSimple } from "./User";

export interface  CommentSimple{
  comment_id : number;
  post_id : number;
  commenter : UserSimple;
  content : string;
  medias : MediaSimple[];
  comment_time : Date;
  like_stats : LikeStats;
  children : CommentSimple[];
  parent?: CommentSimple; // ✅ 新增字段，用于嵌套中传递“被回复者”
}