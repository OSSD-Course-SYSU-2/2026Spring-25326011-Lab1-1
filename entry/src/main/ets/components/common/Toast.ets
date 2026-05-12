@Component
export struct Toast {
  @Prop message: string = '';
  @Prop duration: number = 2000;
  @State private visible: boolean = false;

  aboutToAppear() {
    if (this.message) {
      this.visible = true;
      setTimeout(() => {
        this.visible = false;
      }, this.duration);
    }
  }

  build() {
    if (this.visible) {
      Column() {
        Text(this.message)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .padding({ left: 16, right: 16, top: 10, bottom: 10 })
          .backgroundColor('#CC000000')
          .borderRadius(20)
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.End)
      .alignItems(HorizontalAlign.Center)
      .padding({ bottom: 100 })
    }
  }
}
