import { photoAccessHelper} from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import { image } from '@kit.ImageKit';


//点击打开相册选择照片
export function onClickSelectPhoto(callback: (result: photoAccessHelper.PhotoSelectResult | null, err?: BusinessError) => void) {
  const TAG: string = "12345";
  try {
    let options = new photoAccessHelper.PhotoSelectOptions();
    options.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    options.maxSelectNumber = 9;

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

//批量复制相册到缓存
export async function copyPhotosToCache(imgUrls: string[]): Promise<string[]> {
  const ctx = getContext();
  const cacheUrls: string[] = [];

  for (const imgUrl of imgUrls) {
    try {
      const imgName = Date.now();
      const imgData = fs.openSync(imgUrl, fs.OpenMode.READ_ONLY);
      const newPath = `${ctx.cacheDir}/${imgName}.jpg`;
      fs.copyFileSync(imgData.fd, newPath);
      cacheUrls.push(newPath);
    } catch (err) {
      console.error(`❌ 复制图片失败: ${imgUrl}`, err);
      throw new Error('复制图片到缓存失败');
    }
  }

  return cacheUrls;
}

// 定义获取图片pixelmap的函数
export async function getPixelMap(uri: string): Promise<image.PixelMap> {
  try {
    // 通过uri打开图片文件，获取文件fd
    const file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
    const imageSourceApi = image.createImageSource(file.fd);

    // 解码为 pixelmap
    const pixelmap = await imageSourceApi.createPixelMap();

    console.log('Succeeded in creating pixelmap object through image decoding parameters.');
    return pixelmap;
  } catch (err) {
    console.error('Failed to create pixelmap object:', err);
    throw new Error('Failed to create pixelmap from URI: ' + uri);
  }
}

/**
 * 根据图片路径数组，异步加载生成 PixelMap 数组
 * @param urls 图片路径数组
 * @returns Promise<image.PixelMap[]>
 */
export async function getPixelMapsFromUrls(urls: string[]): Promise<image.PixelMap[]> {
  const pixelMaps: image.PixelMap[] = [];

  for (const uri of urls) {
    try {
      // 打开文件
      const file = fs.openSync(uri, fs.OpenMode.READ_ONLY);
      const imageSource = image.createImageSource(file.fd);

      // 解码为 PixelMap
      const pixelMap = await imageSource.createPixelMap();
      pixelMaps.push(pixelMap);
    } catch (err) {
      console.error(`❌ 加载 PixelMap 失败: ${uri}`, err);
      // 可选：失败时跳过或抛出异常
      // throw new Error(`加载 PixelMap 失败: ${uri}`);
    }
  }

  return pixelMaps;
}

export function getHeight (imageCount : number) {
  console.info("图片数量为：",imageCount);

  const IMAGE_HEIGHT = 110;
  const IMAGE_SPACING = 10;

  const imagesPerRow = 3;
  const rows = Math.ceil(imageCount / imagesPerRow);
  const height = rows * (IMAGE_HEIGHT + IMAGE_SPACING) - IMAGE_SPACING;

  return height;

}


