import { Question, Poem } from '../../types/models';

@Component
export struct QuestionList {
  @Prop questions: Question[] = [];
  @Prop poems: Poem[] = [];
  private onEdit?: (question: Question) => void;
  private onDelete?: (id: string) => void;

  private getPoemTitle(poemId: string): string {
    const poem = this.poems.find(p => p.id === poemId);
    return poem ? poem.title : '未知';
  }

  build() {
    if (this.questions.length === 0) {
      Column() {
        Text('暂无题目数据')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 40 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 12 }) {
        ForEach(this.questions, (question: Question) => {
          ListItem() {
            Row() {
              Column() {
                Text(question.content)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333333')
                  .margin({ bottom: 4 })

                Row() {
                  Text(`难度: ${question.difficulty || 1}`)
                    .fontSize(14)
                    .fontColor('#666666')
                    .margin({ right: 16 })

                  Text(`诗词: ${this.getPoemTitle(question.poemId)}`)
                    .fontSize(14)
                    .fontColor('#666666')
                }
              }
              .layoutWeight(1)
              .alignItems(HorizontalAlign.Start)

              Row() {
                Button('编辑')
                  .height(32)
                  .fontSize(14)
                  .fontColor('#3B82F6')
                  .backgroundColor('#EBF5FF')
                  .onClick(() => {
                    if (this.onEdit) {
                      this.onEdit(question);
                    }
                  })
                  .margin({ right: 8 })

                Button('删除')
                  .height(32)
                  .fontSize(14)
                  .fontColor('#EF4444')
                  .backgroundColor('#FEE2E2')
                  .onClick(() => {
                    if (this.onDelete) {
                      this.onDelete(question.id);
                    }
                  })
              }
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .shadow({
              radius: 2,
              color: '#1A000000',
              offsetY: 2
            })
          }
        }, (question: Question) => question.id)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    }
  }
}
