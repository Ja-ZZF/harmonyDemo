import { CreateCommentRequest } from "../models/Comment";
import { CreateResponse } from "../models/Response";
import { ApiService } from "./api.service";

export class CommentService{
  private apiService = new ApiService();

  async createCommentForPost(post_id : number,content : string){
    const endpoint : string = 'comments/add';
    const newComment :CreateCommentRequest = {
      post_id : post_id,
      parent_comment_id : null,
      content : content
    };

    const response : CreateResponse = await this.apiService.post<CreateCommentRequest,CreateResponse>(endpoint,newComment);

    console.info(JSON.stringify(response));

    return response;
  }

  async createComment(post_id : number,content : string,parent_comment_id : number | null){
    console.info('postId = ',post_id);
    console.info('content = ',content);
    console.info('parent_comment_id = ',parent_comment_id);

    const endpoint : string = 'comments/add';
    const newComment :CreateCommentRequest = {
      post_id : post_id,
      parent_comment_id : parent_comment_id,
      content : content
    };

    const response : CreateResponse = await this.apiService.post<CreateCommentRequest,CreateResponse>(endpoint,newComment);

    console.info(JSON.stringify(response));

    return response;
  }
}