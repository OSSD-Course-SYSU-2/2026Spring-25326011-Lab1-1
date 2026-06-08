import { Colors } from '../../constants/Colors';

@Component
export struct GameRules {
  @Prop visible: boolean = false;
  private onClose?: () => void;

  build() {
    if (this.visible) {
      Column() {
        Column() {
          // 标题
          Row() {
            Text('游戏规则')
              .fontSize(20)
              .fontWeight(FontWeight.Bold)
              .fontColor('#333333')
              .layoutWeight(1)

            Button({ type: ButtonType.Circle }) {
              Text('×')
                .fontSize(24)
                .fontColor('#666666')
            }
            .width(32)
            .height(32)
            .backgroundColor('#F5F5F5')
            .onClick(() => {
              if (this.onClose) {
                this.onClose();
              }
            })
          }
          .width('100%')
          .margin({ bottom: 24 })

          // 规则内容
          Column() {
            // 规则1
            Row() {
              Text('1.')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ right: 8 })

              Text('系统从题库中随机挑选一句诗，并提示上下句字数')
                .fontSize(16)
                .fontColor('#666666')
                .layoutWeight(1)
            }
            .width('100%')
            .margin({ bottom: 16 })

            // 规则2
            Row() {
              Text('2.')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ right: 8 })

              Text('输入猜测的诗句并点击"猜测"（无需输入标点）')
                .fontSize(16)
                .fontColor('#666666')
                .layoutWeight(1)
            }
            .width('100%')
            .margin({ bottom: 16 })

            // 规则3
            Row() {
              Text('3.')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ right: 8 })

              Text('若诗句与答案完全匹配，则游戏成功')
                .fontSize(16)
                .fontColor('#666666')
                .layoutWeight(1)
            }
            .width('100%')
            .margin({ bottom: 16 })

            // 规则4
            Column() {
              Row() {
                Text('4.')
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333333')
                  .margin({ right: 8 })

                Text('否则，系统会用颜色标记反馈：')
                  .fontSize(16)
                  .fontColor('#666666')
                  .layoutWeight(1)
              }
              .width('100%')
              .margin({ bottom: 12 })

              // 颜色图例
              Column() {
                Row() {
                  Text()
                    .width(32)
                    .height(32)
                    .backgroundColor(Colors.COLOR_CORRECT)
                    .borderRadius(4)
                    .margin({ right: 12 })

                  Text('绿色：答案中含有且位置正确的字')
                    .fontSize(14)
                    .fontColor('#666666')
                    .layoutWeight(1)
                }
                .width('100%')
                .margin({ bottom: 8 })

                Row() {
                  Text()
                    .width(32)
                    .height(32)
                    .backgroundColor(Colors.COLOR_MISPLACED)
                    .borderRadius(4)
                    .margin({ right: 12 })

                  Text('黄色：答案中含有但位置不正确的字')
                    .fontSize(14)
                    .fontColor('#666666')
                    .layoutWeight(1)
                }
                .width('100%')
                .margin({ bottom: 8 })

                Row() {
                  Text()
                    .width(32)
                    .height(32)
                    .backgroundColor(Colors.COLOR_ABSENT)
                    .borderRadius(4)
                    .margin({ right: 12 })

                  Text('灰色：答案中不存在的字')
                    .fontSize(14)
                    .fontColor('#666666')
                    .layoutWeight(1)
                }
                .width('100%')
              }
              .width('100%')
              .padding({ left: 24 })
            }
            .width('100%')
            .margin({ bottom: 16 })

            // 规则5
            Row() {
              Text('5.')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor('#333333')
                .margin({ right: 8 })

              Text('每轮有20次猜测机会')
                .fontSize(16)
                .fontColor('#666666')
                .layoutWeight(1)
            }
            .width('100%')
          }
          .width('100%')
          .layoutWeight(1)
        }
        .width('90%')
        .height('80%')
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
