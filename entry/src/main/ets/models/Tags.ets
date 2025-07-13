export interface TagSimple{
  tag_id : number;
  name : string;
}
export function createEmptyTagSimple() : TagSimple{
  return {
    tag_id : 0,
    name : '',
  };
}