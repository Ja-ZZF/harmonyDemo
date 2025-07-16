export interface LikeStats{
  like_count : number;
  is_liked:boolean;
}
export interface CollectStats{
  collect_count : number;
  is_collected : boolean;
}

export interface FollowStats{
  follower_count:number;
  followee_count:number;
}

export function createEmptyLikeStats(): LikeStats{
  return {
    like_count : 0,
    is_liked : false,
  };
}

export function  createEmptyCollectStats():CollectStats{
  return {
    collect_count : 0,
    is_collected : false,
  };
}

export function  createEmptyFollowStats():FollowStats{
  return {
    follower_count : 0,
    followee_count: 0 ,
  };
}