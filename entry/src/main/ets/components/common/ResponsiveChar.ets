import { DeviceConfigManager } from '../config/DeviceConfig';

/**
 * 响应式字符组件（多端适配）
 */
@Component
export struct ResponsiveChar {
  @Prop char: string = '';
  @Prop status: string = 'ABSENT';
  
  private getBackgroundColor(): string {
    if (this.status === 'CORRECT') {
      return '#22C55E';
    } else if (this.status === 'MISPLACED') {
      return '#EAB308';
    } else {
      return '#6B7280';
    }
  }
  
  build() {
    const config = DeviceConfigManager.getInstance();
    const charSize = config.getCharSize();
    const fontSize = config.getFontSize();
    
    Text(this.char)
      .width(charSize)
      .height(charSize)
      .fontSize(fontSize)
      .fontWeight(FontWeight.Bold)
      .fontColor('#FFFFFF')
      .backgroundColor(this.getBackgroundColor())
      .borderRadius(4)
      .textAlign(TextAlign.Center)
      .margin({ right: 2 })
  }
}
