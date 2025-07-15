import { photoAccessHelper} from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';


//点击打开相册选择照片
export function onClickSelectPhoto(callback: (result: photoAccessHelper.PhotoSelectResult | null, err?: BusinessError) => void) {
  const TAG: string = "12345";
  try {
    let options = new photoAccessHelper.PhotoSelectOptions();
    options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    options.maxSelectNumber = 1;

    let picker = new photoAccessHelper.PhotoViewPicker();
    picker.select(options, (err: BusinessError, result: photoAccessHelper.PhotoSelectResult) => {
      if (err) {
        console.error(TAG, "选择图片失败：" + JSON.stringify(err));
        callback(null, err);
        return;
      }
      console.info(TAG, "选择图片成功：" + JSON.stringify(result));
      callback(result);
    });
  } catch (error) {
    let err = error as BusinessError;
    console.error(TAG, "catch异常：" + JSON.stringify(err));
    callback(null, err);
  }
}

//复制相册到缓存
export async function copyPhotoToCache(imgUrl : string) {
  const ctx = getContext();
  const imgName = Date.now();
  const imgData = fs.openSync(imgUrl,fs.OpenMode.READ_ONLY);
  const newDir = `${ctx.cacheDir}/${imgName}.jpg`;
  fs.copyFileSync(imgData.fd,newDir);

  return newDir;
}
