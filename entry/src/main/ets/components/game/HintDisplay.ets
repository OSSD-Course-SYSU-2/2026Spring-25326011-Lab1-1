import { HintInfo } from '../../types/states';

@Component
export struct HintDisplay {
  @Prop hint: HintInfo | null = null;

  build() {
    if (this.hint) {
      Row() {
        // 上一句字数
        if (this.hint.prevVerseCharCount > 0) {
          Column() {
            Text('上句')
              .fontSize(12)
              .fontColor('#999999')
            Text(`${this.hint.prevVerseCharCount}字`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)

          Text('|')
            .fontSize(16)
            .fontColor('#E5E7EB')
        }

        // 当前句字数
        Column() {
          Text('本句')
            .fontSize(12)
            .fontColor('#999999')
          Text(`${this.hint.currentVerseCharCount}字`)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)
            .fontColor('#3B82F6')
            .margin({ top: 4 })
        }
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Center)

        // 下一句字数
        if (this.hint.nextVerseCharCount > 0) {
          Text('|')
            .fontSize(16)
            .fontColor('#E5E7EB')

          Column() {
            Text('下句')
              .fontSize(12)
              .fontColor('#999999')
            Text(`${this.hint.nextVerseCharCount}字`)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .margin({ top: 4 })
          }
          .layoutWeight(1)
          .alignItems(HorizontalAlign.Center)
        }
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 12, bottom: 12 })
      .backgroundColor('#F5F5F5')
      .borderRadius(8)
      .margin({ left: 16, right: 16 })
    }
  }
}
