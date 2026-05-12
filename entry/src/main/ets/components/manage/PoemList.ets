import { Poem } from '../../types/models';

@Component
export struct PoemList {
  @Prop poems: Poem[] = [];
  private onEdit?: (poem: Poem) => void;
  private onDelete?: (id: string) => void;

  build() {
    if (this.poems.length === 0) {
      Column() {
        Text('暂无诗词数据')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 40 })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    } else {
      List({ space: 12 }) {
        ForEach(this.poems, (poem: Poem) => {
          ListItem() {
            Row() {
              Column() {
                Text(poem.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#333333')
                  .margin({ bottom: 4 })

                Text(`${poem.author} (${poem.dynasty})`)
                  .fontSize(14)
                  .fontColor('#666666')
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
                      this.onEdit(poem);
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
                      this.onDelete(poem.id);
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
        }, (poem: Poem) => poem.id)
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })
    }
  }
}
