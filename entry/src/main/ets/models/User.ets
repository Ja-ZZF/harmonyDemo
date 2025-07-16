import { createEmptyFollowStats, FollowStats } from "./Stats";

export interface UserSimple {
  user_id: number;
  avatar: string;
  nickname: string;
  email: string;
  is_followed: boolean;
}

export interface UserDetail{
  user_simple: UserSimple
  introduction: string
  follow_stats:FollowStats
  like_count: number        //被点赞数
  collect_count: number     //收藏数
}
export function createEmptyUserSimple(): UserSimple {
  return {
    user_id: 0,
    avatar: '',
    nickname: '',
    email: '',
    is_followed: false
  };
}

export function createEmptyUserDetail(): UserDetail{
  return{
    user_simple:createEmptyUserSimple(),
    introduction:'',
    follow_stats:createEmptyFollowStats(),
    like_count:0,
    collect_count:0,
  }
}
