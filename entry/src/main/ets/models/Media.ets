export interface MediaSimple{
  media_id : number;
  url : string;
}

export function createEmptyMediaSimple() : MediaSimple{
  return {
    media_id : 0,
    url : '',
  }
}