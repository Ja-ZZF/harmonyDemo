import { CommentSimple } from "./Comment";
import { MediaSimple } from "./Media";
import { createEmptyPermission, Permission } from "./Permission";
import { CollectStats, createEmptyCollectStats, createEmptyLikeStats, LikeStats } from "./Stats";
import { TagSimple } from "./Tags";
import { createEmptyUserSimple, UserSimple } from "./User";

export interface  PostSimpleRequest{
  post_ids : number[];
}

export interface PostDetailParams {
  postId?: number;
}

export interface AddPostByUrls{
  title:string;
  content : string;
  urls: string[];
}

export interface PostSimple{
  post_id : number;
  title : string;
  publisher : UserSimple;
  like_stats : LikeStats;
  cover_url : string;
  is_video : boolean;
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

export function createEmptyPostSimple() : PostSimple{
  return{
    post_id : 0,
    title: '',
    publisher : createEmptyUserSimple(),
    like_stats : createEmptyLikeStats(),
    cover_url : '',
    is_video : false,
  };
}

export function createEmptyPostDetail(): PostDetail {
  return {
    post_simple : createEmptyPostSimple(),
    content : '',
    medias :[],
    permission : createEmptyPermission(),
    publish_time : new Date(),
    collect_stats : createEmptyCollectStats(),
    browse_count : 0,
    comment_count : 0,
    tags : [],
    comments : [],
  };
}