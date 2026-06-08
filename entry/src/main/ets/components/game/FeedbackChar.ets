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
      .width(24)
      .height(24)
      .fontSize(14)
      .fontWeight(FontWeight.Bold)
      .fontColor('#FFFFFF')
      .backgroundColor(this.getBackgroundColor())
      .borderRadius(3)
      .textAlign(TextAlign.Center)
      .margin({ right: 2 })
  }
}
