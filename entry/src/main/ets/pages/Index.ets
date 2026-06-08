import router from '@ohos.router';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Column() {
        // Logo
        Text('猜诗词游戏')
          .fontSize(32)
          .fontWeight(FontWeight.Bold)
          .fontColor('#3B82F6')
          .margin({ bottom: 16 })

        Text('基于Wordle机制的中文诗词猜谜游戏')
          .fontSize(16)
          .fontColor('#666666')
          .margin({ bottom: 48 })

        // 开始游戏按钮
        Button('开始游戏')
          .width('80%')
          .height(56)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
          .backgroundColor('#3B82F6')
          .borderRadius(12)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/GamePage'
            });
          })
      }
      .width('100%')
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
