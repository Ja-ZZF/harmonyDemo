export interface UserSimple {
  user_id: number;
  avatar: string;
  nickname: string;
  email: string;
  is_followed: boolean;
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
