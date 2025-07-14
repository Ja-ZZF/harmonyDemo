//postService 配置Post笔记相关的各种service

import { PostDetail, PostSimple, PostSimpleRequest } from "../models/Post";
import { ApiService } from "./api.service"
import { AuthService } from "./auth.service";
import { preferences } from "@kit.ArkData";

function range(a: number, b: number): number[] {
  const result: number[] = [];
  for (let i = a; i <= b; i++) {
    result.push(i);
  }
  return result;
}

export class PostService{
  private apiService = new ApiService();

  async getAllPost(){
    const posts : PostSimple[] = await this.apiService.get<PostSimple[]>('posts/simple_all');
    console.info('posts: ',JSON.stringify(posts));

    return posts;
  }

  async getPostDetail(post_id : number){
    const endpoint = 'posts/detail?post_id='+post_id.toString();
    const post = await this.apiService.get<PostDetail>(endpoint);
    console.info(JSON.stringify(post));
    return post;
  }

  async getVideoPostList(){
    const endpoint = 'posts/video_list';
    const list : number[] = await this.apiService.get<number[]>(endpoint);

    console.info(list.toString());

    return list;
  }
}
