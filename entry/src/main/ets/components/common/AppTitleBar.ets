@Component
export struct AppTitleBar {
  @Prop title: string = '猜诗词游戏';
  @Prop showBack: boolean = false;
  private onBackClick?: () => void;
  private onRightClick?: () => void;
  @Prop rightIcon: string = '';

  build() {
    Row() {
      // 返回按钮
      if (this.showBack) {
        Button({ type: ButtonType.Circle }) {
          Image($r('sys.media.ohos_ic_public_arrow_left'))
            .width(24)
            .height(24)
            .fillColor('#333333')
        }
        .width(40)
        .height(40)
        .backgroundColor('#F5F5F5')
        .onClick(() => {
          if (this.onBackClick) {
            this.onBackClick();
          }
        })
        .margin({ right: 12 })
      }

      // 标题
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .layoutWeight(1)

      // 右侧按钮
      if (this.rightIcon) {
        Button({ type: ButtonType.Circle }) {
          Image($r(this.rightIcon))
            .width(24)
            .height(24)
            .fillColor('#333333')
        }
        .width(40)
        .height(40)
        .backgroundColor('#F5F5F5')
        .onClick(() => {
          if (this.onRightClick) {
            this.onRightClick();
          }
        })
      }
    }
    .width('100%')
    .height(56)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .shadow({
      radius: 2,
      color: '#1A000000',
      offsetY: 2
    })
  }
}
