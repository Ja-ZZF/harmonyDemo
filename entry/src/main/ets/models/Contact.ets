export interface CreateContact{//建立一个联系
  user_id_1 : number;
  user_id_2 : number;
}

export interface UserRef{ //用户id
  user_id : number;
}
export interface Contact { //一个联系的简单显示
  contact_id: number;
  user1 : UserRef
  user2 : UserRef;
  created_at: string;
  updated_at: string;
}