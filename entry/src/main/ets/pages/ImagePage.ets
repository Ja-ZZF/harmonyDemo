import { common } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';

@Entry
@Component
struct ImagePage {
  @State message: string = 'Hello World';
  aboutToAppear(): void {
    const path : string = 'http://47.117.0.254:4000/uploads/1.png';
    const imageSourceApi : image.ImageSource = image.createImageSource(path);
  }
  build() {
  }
}