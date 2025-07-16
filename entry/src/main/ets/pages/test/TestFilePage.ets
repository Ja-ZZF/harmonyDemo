
import { ApiService } from '../../services/api.service';
import { copyPhotosToCache, copyPhotoToCache, onClickSelectPhoto } from '../../commons/utils/imageHandler';
import fs from '@ohos.file.fs';
import { PostService } from '../../services/post.service';

@Entry
@Component
export struct  TestFilePage {
  @State dir: string = ''
  private apiService = new ApiService();
  private  postService = new PostService();
  private TAG: string = "AlbumSelectPage";

  aboutToAppear(): void {
    this.dir = getContext(this).filesDir;
  }

  build() {
    Column() {
      Button('点击下载文件')
        .onClick(() => {
          this.apiService.downloadFileNew('uploads/posts/thumb/654b166a-ebb7-43f2-bdd8-bc42d228d0b8.jpg');
        })
      Button('点击打开图库')
        .onClick(()=>{
          onClickSelectPhoto(async (result, err) => {//相册选择图片
            if (err) {
              console.error("选择图片失败", err);
              return;
            }
            console.info("图片路径：", result?.photoUris);

            const cacheUrls = await copyPhotosToCache(result?.photoUris ?? []);

            const postUrls:string[] = await this.apiService.uploadPostWithImages(cacheUrls);

            if(postUrls.length>0) {
              console.info("post的url地址为：", postUrls.toString())
            }

            const post_id : number = await this.postService.addPostByUrls("从鸿蒙发出测试的标题2222",'从鸿蒙发出测试的内容',postUrls);
          });
        })
    }
  }



}

