import router from '@ohos.router';
import { Poem, Question, Category } from '../types/models';
import { PoemRepository } from '../repositories/PoemRepository';
import { QuestionRepository } from '../repositories/QuestionRepository';
import { CategoryRepository } from '../repositories/CategoryRepository';
import { PoemService } from '../services/PoemService';
import { QuestionService } from '../services/QuestionService';
import { CategoryService } from '../services/CategoryService';
import { GameService } from '../services/GameService';
import { DataService } from '../services/DataService';
import { ManageViewModel } from '../viewmodels/ManageViewModel';
import { AppTitleBar } from '../components/common/AppTitleBar';
import { LoadingDialog } from '../components/common/LoadingDialog';
import { ConfirmDialog } from '../components/common/ConfirmDialog';
import { PoemList } from '../components/manage/PoemList';
import { PoemEditor } from '../components/manage/PoemEditor';
import { QuestionList } from '../components/manage/QuestionList';
import { QuestionEditor } from '../components/manage/QuestionEditor';
import { CategoryList } from '../components/manage/CategoryList';

@Entry
@Component
struct ManagePage {
  @State private activeTab: 'poems' | 'questions' | 'categories' = 'poems';
  @State private poems: Poem[] = [];
  @State private questions: Question[] = [];
  @State private categories: Category[] = [];
  @State private searchKeyword: string = '';
  @State private isLoading: boolean = false;
  @State private showEditor: boolean = false;
  @State private editingItem: any = null;
  @State private showConfirm: boolean = false;
  @State private deleteId: string = '';
  private viewModel: ManageViewModel | null = null;

  async aboutToAppear() {
    // 初始化服务和ViewModel
    const context = getContext(this) as Context;

    const poemRepo = new PoemRepository(context);
    const questionRepo = new QuestionRepository(context);
    const categoryRepo = new CategoryRepository(context);

    await poemRepo.init();
    await questionRepo.init();
    await categoryRepo.init();

    const poemService = new PoemService(poemRepo);
    const questionService = new QuestionService(questionRepo);
    const categoryService = new CategoryService(categoryRepo, questionRepo);
    const gameService = new GameService(poemService, questionService);
    const dataService = new DataService(poemService, questionService);

    this.viewModel = new ManageViewModel(
      poemService,
      questionService,
      categoryService,
      dataService
    );

    // 加载数据
    await this.loadData();
  }

  async loadData() {
    if (!this.viewModel) return;

    this.isLoading = true;

    switch (this.activeTab) {
      case 'poems':
        await this.viewModel.loadPoems();
        this.poems = this.viewModel.getState().poems;
        break;
      case 'questions':
        await this.viewModel.loadQuestions();
        this.questions = this.viewModel.getState().questions;
        break;
      case 'categories':
        await this.viewModel.loadCategories();
        this.categories = this.viewModel.getState().categories;
        break;
    }

    this.isLoading = false;
  }

  async changeTab(tab: 'poems' | 'questions' | 'categories') {
    this.activeTab = tab;
    await this.loadData();
  }

  build() {
    Column() {
      // 标题栏
      AppTitleBar({
        title: '管理界面',
        showBack: true,
        onBackClick: () => {
          router.back();
        }
      })

      // 标签页
      Tabs() {
        TabContent() {
          this.buildPoemsTab()
        }
        .tabBar('诗词库')

        TabContent() {
          this.buildQuestionsTab()
        }
        .tabBar('题库')

        TabContent() {
          this.buildCategoriesTab()
        }
        .tabBar('分类')
      }
      .width('100%')
      .layoutWeight(1)
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        const tabs: Array<'poems' | 'questions' | 'categories'> = ['poems', 'questions', 'categories'];
        this.changeTab(tabs[index]);
      })

      // 加载对话框
      LoadingDialog({
        visible: this.isLoading,
        message: '加载中...'
      })

      // 确认对话框
      ConfirmDialog({
        visible: this.showConfirm,
        title: '确认删除',
        message: '确定要删除此项吗？',
        onConfirm: async () => {
          this.showConfirm = false;
          if (!this.viewModel) return;

          this.isLoading = true;
          if (this.activeTab === 'poems') {
            await this.viewModel.deletePoem(this.deleteId);
            this.poems = this.viewModel.getState().poems;
          } else if (this.activeTab === 'questions') {
            await this.viewModel.deleteQuestion(this.deleteId);
            this.questions = this.viewModel.getState().questions;
          } else {
            await this.viewModel.deleteCategory(this.deleteId);
            this.categories = this.viewModel.getState().categories;
          }
          this.isLoading = false;
        },
        onCancel: () => {
          this.showConfirm = false;
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  buildPoemsTab() {
    Column() {
      // 搜索和添加
      Row() {
        TextInput({ placeholder: '搜索诗词', text: this.searchKeyword })
          .width('70%')
          .height(40)
          .fontSize(14)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .onChange(async (value: string) => {
            this.searchKeyword = value;
            if (this.viewModel) {
              await this.viewModel.search(value);
              this.poems = this.viewModel.getState().poems;
            }
          })

        Button('添加')
          .width('25%')
          .height(40)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .backgroundColor('#3B82F6')
          .borderRadius(8)
          .onClick(() => {
            this.editingItem = null;
            this.showEditor = true;
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })

      // 诗词列表
      PoemList({
        poems: this.poems,
        onEdit: (poem: Poem) => {
          this.editingItem = poem;
          this.showEditor = true;
        },
        onDelete: (id: string) => {
          this.deleteId = id;
          this.showConfirm = true;
        }
      })

      // 编辑器
      if (this.showEditor) {
        Column() {
          PoemEditor({
            poem: this.editingItem,
            onSave: async (poem: Poem) => {
              this.showEditor = false;
              if (!this.viewModel) return;

              this.isLoading = true;
              if (this.editingItem) {
                await this.viewModel.updatePoem(poem);
              } else {
                await this.viewModel.addPoem(poem);
              }
              this.poems = this.viewModel.getState().poems;
              this.isLoading = false;
            },
            onCancel: () => {
              this.showEditor = false;
            }
          })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#80000000')
        .justifyContent(FlexAlign.Center)
        .padding({ left: 16, right: 16 })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildQuestionsTab() {
    Column() {
      // 搜索和添加
      Row() {
        TextInput({ placeholder: '搜索题目', text: this.searchKeyword })
          .width('70%')
          .height(40)
          .fontSize(14)
          .backgroundColor('#FFFFFF')
          .borderRadius(8)
          .onChange(async (value: string) => {
            this.searchKeyword = value;
            if (this.viewModel) {
              await this.viewModel.search(value);
              this.questions = this.viewModel.getState().questions;
            }
          })

        Button('添加')
          .width('25%')
          .height(40)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .backgroundColor('#3B82F6')
          .borderRadius(8)
          .onClick(() => {
            this.editingItem = null;
            this.showEditor = true;
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })

      // 题目列表
      QuestionList({
        questions: this.questions,
        poems: this.poems,
        onEdit: (question: Question) => {
          this.editingItem = question;
          this.showEditor = true;
        },
        onDelete: (id: string) => {
          this.deleteId = id;
          this.showConfirm = true;
        }
      })

      // 编辑器
      if (this.showEditor) {
        Column() {
          QuestionEditor({
            question: this.editingItem,
            poems: this.poems,
            categories: this.categories,
            onSave: async (question: Question) => {
              this.showEditor = false;
              if (!this.viewModel) return;

              this.isLoading = true;
              if (this.editingItem) {
                await this.viewModel.updateQuestion(question);
              } else {
                await this.viewModel.addQuestion(question);
              }
              this.questions = this.viewModel.getState().questions;
              this.isLoading = false;
            },
            onCancel: () => {
              this.showEditor = false;
            }
          })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#80000000')
        .justifyContent(FlexAlign.Center)
        .padding({ left: 16, right: 16 })
      }
    }
    .width('100%')
    .height('100%')
  }

  @Builder
  buildCategoriesTab() {
    Column() {
      // 添加按钮
      Row() {
        Button('添加分类')
          .width('100%')
          .height(40)
          .fontSize(14)
          .fontColor('#FFFFFF')
          .backgroundColor('#3B82F6')
          .borderRadius(8)
          .onClick(() => {
            this.editingItem = null;
            this.showEditor = true;
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16, top: 16, bottom: 16 })

      // 分类列表
      CategoryList({
        categories: this.categories,
        onEdit: (category: Category) => {
          this.editingItem = category;
          this.showEditor = true;
        },
        onDelete: (id: string) => {
          this.deleteId = id;
          this.showConfirm = true;
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}
