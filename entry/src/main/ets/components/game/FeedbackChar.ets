import { FeedbackStatus } from '../../types/models';
import { Colors } from '../../constants/Colors';

@Component
export struct FeedbackChar {
  @Prop char: string = '';
  @Prop status: FeedbackStatus = FeedbackStatus.ABSENT;

  private getBackgroundColor(): string {
    switch (this.status) {
      case FeedbackStatus.CORRECT:
        return Colors.COLOR_CORRECT;
      case FeedbackStatus.MISPLACED:
        return Colors.COLOR_MISPLACED;
      case FeedbackStatus.ABSENT:
      default:
        return Colors.COLOR_ABSENT;
    }
  }

  build() {
    Text(this.char)
      .width(40)
      .height(40)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .fontColor('#FFFFFF')
      .backgroundColor(this.getBackgroundColor())
      .borderRadius(4)
      .textAlign(TextAlign.Center)
      .margin({ right: 4 })
  }
}
