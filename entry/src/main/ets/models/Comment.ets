import { createEmptyMediaSimple, MediaSimple } from "./Media";
import { createEmptyLikeStats, LikeStats } from "./Stats";
import { createEmptyUserSimple, UserSimple } from "./User";

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

export interface CreateCommentRequest{
  post_id : number;
  parent_comment_id : number | null;
  content : string;
}

export function createEmptyCommentSimple() : CommentSimple{
  return {
    comment_id : 0,
    post_id : 0,
    commenter : createEmptyUserSimple(),
    content : '',
    medias : [],
    comment_time : new Date(),
    like_stats : createEmptyLikeStats(),
    children : [],
  };
}