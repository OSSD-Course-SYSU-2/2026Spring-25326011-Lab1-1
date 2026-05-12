import { GameState } from '../../types/states';

@Component
export struct GameResult {
  @Prop state: GameState = GameState.IDLE;
  @Prop guessCount: number = 0;
  @Prop answer: string = '';
  private onNewGame?: () => void;

  build() {
    if (this.state === GameState.SUCCESS) {
      Column() {
        Text('🎉 恭喜你猜对了！')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#22C55E')
          .margin({ bottom: 16 })

        Text(`共猜测 ${this.guessCount} 次`)
          .fontSize(16)
          .fontColor('#666666')
          .margin({ bottom: 24 })

        Button('开始新游戏')
          .width('60%')
          .height(48)
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#3B82F6')
          .borderRadius(8)
          .onClick(() => {
            if (this.onNewGame) {
              this.onNewGame();
            }
          })
      }
      .width('100%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ left: 16, right: 16 })
    } else if (this.state === GameState.FAILED) {
      Column() {
        Text('😢 很遗憾，次数用尽')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#EF4444')
          .margin({ bottom: 16 })

        Text('正确答案：')
          .fontSize(14)
          .fontColor('#999999')
          .margin({ bottom: 8 })

        Text(this.answer)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
          .margin({ bottom: 24 })

        Button('开始新游戏')
          .width('60%')
          .height(48)
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#3B82F6')
          .borderRadius(8)
          .onClick(() => {
            if (this.onNewGame) {
              this.onNewGame();
            }
          })
      }
      .width('100%')
      .padding(24)
      .backgroundColor('#FFFFFF')
      .borderRadius(12)
      .margin({ left: 16, right: 16 })
    }
  }
}
