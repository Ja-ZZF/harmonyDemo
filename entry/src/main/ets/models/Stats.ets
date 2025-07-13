export interface LikeStats{
  like_count : number;
  is_liked:boolean;
}
export interface CollectStats{
  collect_count : number;
  is_collected : boolean;
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