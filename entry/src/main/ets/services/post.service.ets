//postService 配置Post笔记相关的各种service

import { PostDetail, PostSimple, PostSimpleRequest } from "../models/Post";
import { ApiService } from "./api.service"
import { AuthService } from "./auth.service";

export class PostService{
  private apiService = new ApiService();

  async getAllPost(){
    const post_ids : number[] = [1,2,3];
    console.info('post_ids: ',post_ids);

    const body : PostSimpleRequest= {
      post_ids : post_ids,
    };

    const posts : PostSimple[] = await this.apiService.post<PostSimpleRequest,PostSimple[]>('posts/simple',body);
    console.info('posts: ',JSON.stringify(posts));

    return posts;
  }

  async getPostDetail(post_id : number){
    const endpoint = 'posts/detail?post_id='+post_id.toString();
    const post = await this.apiService.get<PostDetail>(endpoint);

    console.info(JSON.stringify(post));

    return post;
  }
}