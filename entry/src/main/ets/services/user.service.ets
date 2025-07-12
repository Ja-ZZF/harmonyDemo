//UserService 配置用户相关的各种服务

import { UserSimple } from "../models/User";
import { ApiService } from "./api.service";
import { AuthService } from "./auth.service";

export class UserService{
  private apiService = new ApiService;

  async getSelf(){
    const userId = AuthService.getUserId(getContext(this));
    const endpoint : string = 'users/simple?target_id='+userId;

    const response : UserSimple = await this.apiService.get<UserSimple>(endpoint);
    console.info('User : ',JSON.stringify(response));
    return response;
  }
}