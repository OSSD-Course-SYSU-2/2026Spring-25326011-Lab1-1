@Component
export struct GuessInput {
  @Link text: string;
  @Prop disabled: boolean = false;
  private onSubmit?: () => void;

  build() {
    Row() {
      TextInput({ placeholder: '请输入诗句', text: this.text })
        .width('70%')
        .height(48)
        .fontSize(16)
        .fontColor('#333333')
        .placeholderColor('#999999')
        .backgroundColor('#F5F5F5')
        .borderRadius(8)
        .padding({ left: 16, right: 16 })
        .enabled(!this.disabled)
        .onChange((value: string) => {
          this.text = value;
        })
        .onSubmit(() => {
          if (this.onSubmit) {
            this.onSubmit();
          }
        })

      Button('猜测')
        .width('25%')
        .height(48)
        .fontSize(16)
        .fontColor('#FFFFFF')
        .backgroundColor('#3B82F6')
        .borderRadius(8)
        .enabled(!this.disabled && this.text.length > 0)
        .onClick(() => {
          if (this.onSubmit) {
            this.onSubmit();
          }
        })
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ left: 16, right: 16 })
  }
}
