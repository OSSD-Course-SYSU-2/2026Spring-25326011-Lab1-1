import { HintInfo } from '../../types/states';

@Component
export struct HintDisplay {
  @Prop hint: HintInfo | null = null;

  build() {
    if (this.hint) {
      Column() {
        // 显示答案格式提示
        Row() {
          Text('答案格式: ')
            .fontSize(14)
            .fontColor('#666666')
          
          if (this.hint.currentVerseCharCount > 0) {
            // 计算每句字数（总字数除以2）
            Text(`${Math.floor(this.hint.currentVerseCharCount / 2)}×2`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#3B82F6')
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .padding({ top: 8, bottom: 8 })
        
        // 提示说明
        Text('请输入完整的上下句，中间用逗号分隔')
          .fontSize(12)
          .fontColor('#999999')
          .margin({ top: 4 })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .margin({ left: 16, right: 16 })
    }
  }
}
