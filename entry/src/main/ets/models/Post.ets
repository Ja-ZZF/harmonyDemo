import { CommentSimple } from "./Comment";
import { MediaSimple } from "./Media";
import { Permission } from "./Permission";
import { CollectStats, LikeStats } from "./Stats";
import { TagSimple } from "./Tags";
import { UserSimple } from "./User";

export interface  PostSimpleRequest{
  post_ids : number[];
}

export interface PostSimple{
  post_id : number;
  title : string;
  publisher : UserSimple;
  like_stats : LikeStats;
  cover_url : string;
}

export interface  PostDetail{
  post_simple : PostSimple;
  content : string;
  medias : MediaSimple[];
  permission : Permission;
  publish_time : Date;
  collect_stats :CollectStats;
  browse_count : number;
  comment_count : number;
  tags : TagSimple[];
  comments : CommentSimple[];
}