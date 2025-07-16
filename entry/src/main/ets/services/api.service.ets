//处理各种网络请求
import http from '@ohos.net.http';
import { Config } from '../configs/config';
import { HeadersMap } from '../models/HeadersMap';
import { AuthService } from './auth.service';
import { fileIo } from '@kit.CoreFileKit';
import { edgeWidths } from '@kit.ArkUI';
import { common, Permissions } from '@kit.AbilityKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import fs from '@ohos.file.fs';
import { checkAndRequestPermissions } from '../commons/utils/UserPermissions';
import { BusinessError, request, RequestData } from '@kit.BasicServicesKit';
import  File  from '@ohos.request';  // 这里的路径根据你的项目实际调整

// interface FileItem {
//   filename: string;
//   name: string;
//   uri: string;
//   type: string;
// }

export class ApiService {
  private baseUrl = Config.baseUrl;

  private getAuthHeader(context: Context): HeadersMap {
    const token = AuthService.getToken(context);
    return {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`,
    };
  }


  async get<T>(endpoint: string): Promise<T> {
    const url = this.baseUrl + endpoint;
    console.log('请求地址:', url);
    const httpRequest = http.createHttp();

    try {
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        header: this.getAuthHeader(getContext(this)),
      });

      if ((response.responseCode === 200 || response.responseCode === 201) && response.result) {
        return JSON.parse(response.result as string) as T;
      } else {
        throw new Error(`请求失败，状态码：${response.responseCode}`);
      }
    } catch (err) {
      if (err instanceof Error) {
        throw err;
      } else {
        throw new Error(String(err));
      }
    } finally {
      httpRequest.destroy();
    }
  }

  async post<TReq,TRes>(endpoint: string, body: TReq): Promise<TRes> {
    const url = this.baseUrl + endpoint;
    const httpRequest = http.createHttp();

    try {
      const response = await httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          header: this.getAuthHeader(getContext(this)),
          extraData:JSON.stringify(body),
        }
      );

      if ((response.responseCode === 200 || response.responseCode === 201) && response.result) {
        return JSON.parse(response.result as string) as TRes;
      } else {
        throw new Error(`请求失败，状态码：${response.responseCode}`);
      }
    } catch (err) {
      if (err instanceof Error) {
        throw err;
      } else {
        throw new Error(String(err));
      }
    } finally {
      httpRequest.destroy();
    }

  }

  async saveImage(buffer: ArrayBuffer | string): Promise<void> {

    checkAndRequestPermissions(getContext(this) as common.UIAbilityContext);

    let context = getContext(this) as common.UIAbilityContext;
    let helper = photoAccessHelper.getPhotoAccessHelper(context);
    let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
    let file = await fs.open(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    await fs.write(file.fd, buffer);
    await fs.close(file.fd);
  }

  async downloadFileNew(url : string){
    //const url = this.baseUrl + endpoint;
    const request = http.createHttp();

    try{
      const response = await request.request(
        url,
        {
        method : http.RequestMethod.GET,
      })
      console.info('文件访问成功')
      const buffer : ArrayBuffer = response.result as ArrayBuffer;

      this.saveImage(buffer);
      console.info('文件保存成功');
    }catch (err){
      throw new Error('错误！');
    }
  }


  //上传图片到服务器 ！！！
  async uploadPostWithImages(paths: string[]) : Promise<string[]>{
    const endpoint = 'upload/image';
    const url = this.baseUrl + endpoint; // 上传地址
    const ctx = getContext(); //上下文
    const token = AuthService.getToken(ctx); //token解析

    // 构造files数组，多个文件
    const files: request.File[] = paths.map((path, index) => {
      const fileName = path.split('/').pop() || `file${index}.jpg`;
      const uri = `internal://cache/${fileName}`;
      console.info("image URI = ", uri);
      return {
        filename: fileName,
        name: "images", // ⚠️字段名必须和后端的 FilesInterceptor 名一致
        uri: uri,
        type: "image/jpeg", // 你也可以动态判断后缀改type
      } as request.File;
    });

    console.info('files: ', JSON.stringify(files));

    return new Promise<string[]>(async (resolve, reject) => {
      try {
        const arr: string[] = [];
        const uploadTask = await request.uploadFile(ctx, {
          url: url,
          header: {
            'Accept': '*/*',
            'Authorization': `Bearer ${token}`
          },
          method: "POST",
          files: files,
          data: [],
        });

        uploadTask.on('headerReceive', (header) => {
          if (header["body"]) {
            try {
              // 假设响应体是 {"data": "图片url"} 格式
              const result: string = header["body"] as string
              console.info('result =', result);
              if (result) {
                arr.push(result);
              }
            } catch (err) {
              console.warn('解析 header body 失败:', err);
            }
          }
        });

        uploadTask.on('complete', (event) => {
          console.log('上传完成:', event);
          resolve(arr);
        });

      } catch (error) {
        console.error('上传异常:', error);
        reject(error);
      }
    });
  }




}
