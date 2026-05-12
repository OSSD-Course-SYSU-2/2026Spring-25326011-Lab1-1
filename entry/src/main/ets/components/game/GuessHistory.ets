import { GuessRecord } from '../../types/models';
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
        List({ space: 12 }) {
          ForEach(this.history, (record: GuessRecord, index: number) => {
            ListItem() {
              Row() {
                ForEach(record.feedback, (item, i: number) => {
                  FeedbackChar({
                    char: item.char,
                    status: item.status
                  });
                })
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .padding({ left: 16, right: 16 })
            }
          }, (record: GuessRecord) => record.timestamp.toString())
        }
        .width('100%')
        .layoutWeight(1)
        .padding({ top: 16, bottom: 16 })
      }
    }
    .width('100%')
    .layoutWeight(1)
  }
}
