@Component
export struct LoadingDialog {
  @Prop visible: boolean = false;
  @Prop message: string = '加载中...';

  build() {
    if (this.visible) {
      Column() {
        Column() {
          LoadingProgress()
            .width(48)
            .height(48)
            .color('#3B82F6')

          Text(this.message)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ top: 16 })
        }
        .padding(24)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({
          radius: 8,
          color: '#1A000000',
          offsetY: 4
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#80000000')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
  }
}
