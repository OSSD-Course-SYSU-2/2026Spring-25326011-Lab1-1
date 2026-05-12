import { GameConstants } from '../../constants/GameConstants';

@Component
export struct GameStatus {
  @Prop remainingGuesses: number = GameConstants.MAX_GUESSES;
  @Prop totalGuesses: number = GameConstants.MAX_GUESSES;

  build() {
    Column() {
      Row() {
        Text('剩余次数')
          .fontSize(14)
          .fontColor('#666666')

        Text(`${this.remainingGuesses}/${this.totalGuesses}`)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor('#3B82F6')
          .margin({ left: 8 })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ bottom: 8 })

      // 进度条
      Row() {
        Row()
          .width(`${(this.remainingGuesses / this.totalGuesses) * 100}%`)
          .height('100%')
          .backgroundColor('#3B82F6')
          .borderRadius(4)
      }
      .width('80%')
      .height(8)
      .backgroundColor('#E5E7EB')
      .borderRadius(4)
    }
    .width('100%')
    .padding({ top: 16, bottom: 16 })
  }
}
