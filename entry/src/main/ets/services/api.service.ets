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

interface FileItem {
  filename: string;
  name: string;
  uri: string;
  type: string;
}

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

  async downloadFileNew(endpoint : string){
    const url = this.baseUrl + endpoint;
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

  async uploadFile(endpoint : string,path : string){
    const url = this.baseUrl + endpoint;
    console.info("request url = ",url);
    const uploadPath = `internal://cache/${path.split('cache/')[1]}`;
    console.info("uploadPath = ",uploadPath);
    const ctx = getContext();
    const token = AuthService.getToken(ctx);
    let uploadTask: request.UploadTask;

    await request.uploadFile(ctx,{
      url : url,
      header: {
        'Accept': '*/*' ,
        'Authorization': `Bearer ${token}`
      },
      method : "POST",
      files:[{filename : "file.jpg",name:"file",uri:uploadPath,type: "image/jpeg"}],
      data:[],
    }).then((data: request.UploadTask) => {
      uploadTask = data;
    }).catch((err: BusinessError) => {
      console.error(`Failed to request the upload. Code: ${err.code}, message: ${err.message}`);
    });
  }


  async uploadPostWithImages(endpoint: string, paths: string[], title: string, content: string) {
    const url = this.baseUrl + endpoint;
    const ctx = getContext();
    const token = AuthService.getToken(ctx);

    // 构造files数组，多个文件
    const files : FileItem[]= paths.map((path, index) => {
      const fileName = path.split('/').pop() || `file${index}.jpg`;
      const uri = `internal://cache/${fileName}`;
      return {
        filename: fileName,
        name: "images",       // ⚠️字段名必须和后端的 FilesInterceptor 名一致
        uri: uri,
        type: "image/jpeg",   // 你也可以动态判断后缀改type
      } as FileItem;
    });



    try {
      const uploadTask = await request.uploadFile(ctx, {
        url: url,
        header: {
          'Accept': '*/*',
          'Authorization': `Bearer ${token}`
        },
        method: "POST",
        files: files,
        data:[
          { name: "title", value: title },
          { name: "content", value: content }
        ],
      });

      uploadTask.on('complete', (result) => {
        console.info('上传完成:', result);
      });
    } catch (err) {
      console.error('上传失败:', err);
    }
  }


}
