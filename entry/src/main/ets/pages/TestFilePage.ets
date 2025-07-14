
import { ApiService } from '../services/api.service';
import { copyPhotoToCache, onClickSelectPhoto } from '../commons/utils/imageHandler';
import fs from '@ohos.file.fs';

@Entry
@Component
export struct  TestFilePage {
  @State dir: string = ''
  private apiService = new ApiService();
  private TAG: string = "AlbumSelectPage";

  aboutToAppear(): void {
    this.dir = getContext(this).filesDir;
  }

  build() {
    Column() {
      Button('点击下载文件')
        .onClick(() => {
          this.apiService.downloadFileNew('uploads/posts/thumb/fe7a9a90-d526-4f6e-953e-d5b31fc87182.jpg');
        })
      Button('点击打开图库')
        .onClick(()=>{
          onClickSelectPhoto(async (result, err) => {
            if (err) {
              console.error("选择图片失败", err);
              return;
            }
            console.info("图片路径：", result?.photoUris[0]);
            const imgUrl = result?.photoUris[0];
            if(imgUrl) {
              const cacheUrl :string= await copyPhotoToCache(imgUrl);
              console.info("cache图片路径：",cacheUrl);
              const paths : string[] = [];
              paths.push(cacheUrl);
              //await this.apiService.uploadFile('upload/image',cacheUrl);
              await this.apiService.uploadPostWithImages('posts/add',paths,'朱子凡发的测试标题','朱子凡发的测试内容');
            }
          });
        })
    }
  }



}

