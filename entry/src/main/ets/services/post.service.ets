//postService 配置Post笔记相关的各种service

import { AddPostByUrls, GetInterestsRequest, PostDetail, PostSimple, PostSimpleRequest } from "../models/Post";
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

  //获取所有post
  async getAllPost(){
    const posts : PostSimple[] = await this.apiService.get<PostSimple[]>('posts/simple_all');
    console.info('posts: ',JSON.stringify(posts));

    // 简单随机排序
    const postsNew = posts.sort(() => Math.random() - 0.5);

    return postsNew;
  }

  //获取感兴趣的post
  async getInterestedPosts(numPosts: number): Promise<PostSimple[]> {
    try {
      const result :PostSimple[]= await this.apiService.post<GetInterestsRequest, PostSimple[]>(
        'posts/interests',
        { num_posts: numPosts }
      );
      console.log('获取到的推荐帖子:', result);
      return result;
    } catch (error) {
      console.error('获取推荐帖子失败:', error);
      return [];
    }
  }

  //获取post详情
  async getPostDetail(post_id : number){
    const endpoint = 'posts/detail?post_id='+post_id.toString();
    const post = await this.apiService.get<PostDetail>(endpoint);
    console.info(JSON.stringify(post));
    return post;
  }

  //获取视频post列表
  async getVideoPostList(){
    const endpoint = 'posts/video_list';
    const list : number[] = await this.apiService.get<number[]>(endpoint);

    const Sortedlist :number[]= list.sort(() => Math.random() - 0.5);  // 简单随机排序

    console.info(list.toString());

    return Sortedlist;
  }

  //上传帖子 by Urls
  async addPostByUrls(title:string,content:string,urls:string[]){
    const endpoint = 'posts/add-by-urls'
    const body : AddPostByUrls = {
      title : title,
      content: content,
      urls : urls,
    };

    const post_id : number = await this.apiService.post<AddPostByUrls,number>(endpoint,body);

    return post_id;
  }
}
