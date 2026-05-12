import { Poem } from '../../types/models';
import { IdGenerator } from '../../utils/IdGenerator';

@Component
export struct PoemEditor {
  @Prop poem: Poem | null = null;
  @State private title: string = '';
  @State private author: string = '';
  @State private dynasty: string = '';
  @State private verses: string = '';
  private onSave?: (poem: Poem) => void;
  private onCancel?: () => void;

  aboutToAppear() {
    if (this.poem) {
      this.title = this.poem.title;
      this.author = this.poem.author;
      this.dynasty = this.poem.dynasty;
      this.verses = this.poem.verses.join('\n');
    }
  }

  build() {
    Column() {
      // 标题
      Text(this.poem ? '编辑诗词' : '添加诗词')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .margin({ bottom: 24 })

      // 标题输入
      Column() {
        Text('标题')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入标题', text: this.title })
          .width('100%')
          .height(48)
          .fontSize(16)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .onChange((value: string) => {
            this.title = value;
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 16 })

      // 作者输入
      Column() {
        Text('作者')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入作者', text: this.author })
          .width('100%')
          .height(48)
          .fontSize(16)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .onChange((value: string) => {
            this.author = value;
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 16 })

      // 朝代输入
      Column() {
        Text('朝代')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入朝代', text: this.dynasty })
          .width('100%')
          .height(48)
          .fontSize(16)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .onChange((value: string) => {
            this.dynasty = value;
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 16 })

      // 诗句输入
      Column() {
        Text('诗句（每行一句）')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        TextArea({ placeholder: '请输入诗句', text: this.verses })
          .width('100%')
          .height(120)
          .fontSize(16)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .onChange((value: string) => {
            this.verses = value;
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 24 })

      // 按钮
      Row() {
        Button('取消')
          .width('45%')
          .height(48)
          .fontSize(16)
          .fontColor('#666666')
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .onClick(() => {
            if (this.onCancel) {
              this.onCancel();
            }
          })

        Button('保存')
          .width('45%')
          .height(48)
          .fontSize(16)
          .fontColor('#FFFFFF')
          .backgroundColor('#3B82F6')
          .borderRadius(8)
          .onClick(() => {
            const poemData: Poem = {
              id: this.poem ? this.poem.id : IdGenerator.generate(),
              title: this.title,
              author: this.author,
              dynasty: this.dynasty,
              verses: this.verses.split('\n').filter(v => v.trim())
            };

            if (this.onSave) {
              this.onSave(poemData);
            }
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(24)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
  }
}
