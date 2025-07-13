export interface Permission{
  view_permission : string;
  comment_permission : string;
}

export function createEmptyPermission() : Permission{
  return {
    view_permission : '',
    comment_permission : '',
  };
}