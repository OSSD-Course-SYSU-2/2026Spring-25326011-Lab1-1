import { GuessRecord, FeedbackItem } from '../../types/models';
import { FeedbackChar } from './FeedbackChar';

@Component
export struct GuessHistory {
  @Prop history: GuessRecord[] = [];

  build() {
    Column() {
      if (this.history.length === 0) {
        Column() {
          Text('暂无猜测记录')
            .fontSize(16)
            .fontColor('#999999')
            .margin({ top: 40 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 6 }) {
          ForEach(this.history, (record: GuessRecord, index: number) => {
            ListItem() {
              Scroll() {
                Row() {
                  ForEach(record.feedback, (item: FeedbackItem, i: number) => {
                    FeedbackChar({
                      char: item.char,
                      status: item.status
                    });
                  }, (item: FeedbackItem, i: number) => i.toString())
                }
                .justifyContent(FlexAlign.Center)
                .padding({ left: 4, right: 4 })
              }
              .width('100%')
              .scrollable(ScrollDirection.Horizontal)
              .scrollBar(BarState.Off)
            }
          }, (record: GuessRecord, index: number) => index.toString())
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ top: 8, bottom: 8 })
      }
    }
    .width('100%')
    .layoutWeight(1)
  }
}
