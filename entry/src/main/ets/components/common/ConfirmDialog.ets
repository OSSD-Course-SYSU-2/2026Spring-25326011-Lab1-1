@Component
export struct ConfirmDialog {
  @Prop visible: boolean = false;
  @Prop title: string = '确认';
  @Prop message: string = '';
  private onConfirm?: () => void;
  private onCancel?: () => void;

  build() {
    if (this.visible) {
      Column() {
        Column() {
          // 标题
          Text(this.title)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor('#333333')
            .margin({ bottom: 12 })

          // 消息
          Text(this.message)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 24 })

          // 按钮
          Row() {
            Button('取消')
              .width('45%')
              .height(40)
              .fontSize(16)
              .fontColor('#666666')
              .backgroundColor('#F5F5F5')
              .onClick(() => {
                if (this.onCancel) {
                  this.onCancel();
                }
              })

            Button('确认')
              .width('45%')
              .height(40)
              .fontSize(16)
              .fontColor('#FFFFFF')
              .backgroundColor('#3B82F6')
              .onClick(() => {
                if (this.onConfirm) {
                  this.onConfirm();
                }
              })
          }
          .width('100%')
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('80%')
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
