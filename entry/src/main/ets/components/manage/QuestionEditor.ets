import { Question, Poem, Category } from '../../types/models';
import { IdGenerator } from '../../utils/IdGenerator';

@Component
export struct QuestionEditor {
  @Prop question: Question | null = null;
  @Prop poems: Poem[] = [];
  @Prop categories: Category[] = [];
  @State private content: string = '';
  @State private selectedPoemId: string = '';
  @State private difficulty: number = 1;
  private onSave?: (question: Question) => void;
  private onCancel?: () => void;

  aboutToAppear() {
    if (this.question) {
      this.content = this.question.content;
      this.selectedPoemId = this.question.poemId;
      this.difficulty = this.question.difficulty || 1;
    } else if (this.poems.length > 0) {
      this.selectedPoemId = this.poems[0].id;
    }
  }

  build() {
    Column() {
      // 标题
      Text(this.question ? '编辑题目' : '添加题目')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor('#333333')
        .margin({ bottom: 24 })

      // 诗句内容输入
      Column() {
        Text('诗句内容')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        TextInput({ placeholder: '请输入诗句', text: this.content })
          .width('100%')
          .height(48)
          .fontSize(16)
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .onChange((value: string) => {
            this.content = value;
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 16 })

      // 诗词选择
      Column() {
        Text('所属诗词')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        Select(this.poems.map(p => ({ value: p.title })))
          .width('100%')
          .height(48)
          .fontSize(16)
          .selected(this.poems.findIndex(p => p.id === this.selectedPoemId))
          .onSelect((index: number) => {
            this.selectedPoemId = this.poems[index].id;
          })
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .margin({ bottom: 16 })

      // 难度选择
      Column() {
        Text('难度')
          .fontSize(14)
          .fontColor('#666666')
          .margin({ bottom: 8 })

        Row() {
          ForEach([1, 2, 3, 4, 5], (level: number) => {
            Button(level.toString())
              .width(48)
              .height(48)
              .fontSize(16)
              .fontColor(this.difficulty === level ? '#FFFFFF' : '#333333')
              .backgroundColor(this.difficulty === level ? '#3B82F6' : '#F5F5F5')
              .borderRadius(8)
              .onClick(() => {
                this.difficulty = level;
              })
              .margin({ right: 8 })
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
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
            const questionData: Question = {
              id: this.question ? this.question.id : IdGenerator.generate(),
              content: this.content,
              poemId: this.selectedPoemId,
              difficulty: this.difficulty,
              categoryIds: this.question ? this.question.categoryIds : []
            };

            if (this.onSave) {
              this.onSave(questionData);
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
