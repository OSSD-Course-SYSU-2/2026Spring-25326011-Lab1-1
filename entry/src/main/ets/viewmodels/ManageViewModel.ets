import { Poem, Question, Category } from '../types/models';
import { ManagePageState } from '../types/states';
import { Result, ImportStats } from '../types/results';
import { PoemService } from '../services/PoemService';
import { QuestionService } from '../services/QuestionService';
import { CategoryService } from '../services/CategoryService';
import { DataService } from '../services/DataService';

/**
 * 管理视图模型
 */
export class ManageViewModel {
  private poemService: PoemService;
  private questionService: QuestionService;
  private categoryService: CategoryService;
  private dataService: DataService;
  private state: ManagePageState;

  constructor(
    poemService: PoemService,
    questionService: QuestionService,
    categoryService: CategoryService,
    dataService: DataService
  ) {
    this.poemService = poemService;
    this.questionService = questionService;
    this.categoryService = categoryService;
    this.dataService = dataService;
    this.state = {
      activeTab: 'poems',
      poems: [],
      questions: [],
      categories: [],
      searchKeyword: '',
      isLoading: false
    };
  }

  /**
   * 获取当前状态
   */
  getState(): ManagePageState {
    return this.state;
  }

  /**
   * 切换标签页
   */
  async setActiveTab(tab: 'poems' | 'questions' | 'categories'): Promise<void> {
    this.state.activeTab = tab;
    await this.loadData();
  }

  /**
   * 加载数据
   */
  private async loadData(): Promise<void> {
    this.state.isLoading = true;

    switch (this.state.activeTab) {
      case 'poems':
        await this.loadPoems();
        break;
      case 'questions':
        await this.loadQuestions();
        break;
      case 'categories':
        await this.loadCategories();
        break;
    }

    this.state.isLoading = false;
  }

  /**
   * 加载诗词列表
   */
  async loadPoems(): Promise<void> {
    const result = await this.poemService.getAllPoems();
    if (result.success && result.data) {
      this.state.poems = result.data;
    }
  }

  /**
   * 加载题目列表
   */
  async loadQuestions(): Promise<void> {
    const result = await this.questionService.getAllQuestions();
    if (result.success && result.data) {
      this.state.questions = result.data;
    }
  }

  /**
   * 加载分类列表
   */
  async loadCategories(): Promise<void> {
    const result = await this.categoryService.getAllCategories();
    if (result.success && result.data) {
      this.state.categories = result.data;
    }
  }

  /**
   * 搜索
   */
  async search(keyword: string): Promise<void> {
    this.state.searchKeyword = keyword;

    if (!keyword) {
      await this.loadData();
      return;
    }

    this.state.isLoading = true;

    switch (this.state.activeTab) {
      case 'poems':
        const poemsResult = await this.poemService.searchPoems(keyword);
        if (poemsResult.success && poemsResult.data) {
          this.state.poems = poemsResult.data;
        }
        break;
      case 'questions':
        // 题目搜索逻辑
        await this.loadQuestions();
        this.state.questions = this.state.questions.filter(q =>
          q.content.includes(keyword)
        );
        break;
      case 'categories':
        // 分类搜索逻辑
        await this.loadCategories();
        this.state.categories = this.state.categories.filter(c =>
          c.name.includes(keyword)
        );
        break;
    }

    this.state.isLoading = false;
  }

  /**
   * 添加诗词
   */
  async addPoem(poem: Poem): Promise<Result<Poem>> {
    const result = await this.poemService.addPoem(poem);
    if (result.success) {
      await this.loadPoems();
    }
    return result;
  }

  /**
   * 更新诗词
   */
  async updatePoem(poem: Poem): Promise<Result<Poem>> {
    const result = await this.poemService.updatePoem(poem);
    if (result.success) {
      await this.loadPoems();
    }
    return result;
  }

  /**
   * 删除诗词
   */
  async deletePoem(id: string): Promise<Result<void>> {
    const result = await this.poemService.deletePoem(id);
    if (result.success) {
      await this.loadPoems();
    }
    return result;
  }

  /**
   * 添加题目
   */
  async addQuestion(question: Question): Promise<Result<Question>> {
    const result = await this.questionService.addQuestion(question);
    if (result.success) {
      await this.loadQuestions();
    }
    return result;
  }

  /**
   * 更新题目
   */
  async updateQuestion(question: Question): Promise<Result<Question>> {
    const result = await this.questionService.updateQuestion(question);
    if (result.success) {
      await this.loadQuestions();
    }
    return result;
  }

  /**
   * 删除题目
   */
  async deleteQuestion(id: string): Promise<Result<void>> {
    const result = await this.questionService.deleteQuestion(id);
    if (result.success) {
      await this.loadQuestions();
    }
    return result;
  }

  /**
   * 添加分类
   */
  async addCategory(category: Category): Promise<Result<Category>> {
    const result = await this.categoryService.addCategory(category);
    if (result.success) {
      await this.loadCategories();
    }
    return result;
  }

  /**
   * 更新分类
   */
  async updateCategory(category: Category): Promise<Result<Category>> {
    const result = await this.categoryService.updateCategory(category);
    if (result.success) {
      await this.loadCategories();
    }
    return result;
  }

  /**
   * 删除分类
   */
  async deleteCategory(id: string): Promise<Result<void>> {
    const result = await this.categoryService.deleteCategory(id);
    if (result.success) {
      await this.loadCategories();
    }
    return result;
  }

  /**
   * 导出数据
   */
  async exportData(): Promise<Result<{ poems: Poem[], questions: Question[] }>> {
    return await this.dataService.exportData();
  }

  /**
   * 导入数据
   */
  async importData(data: { poems?: Poem[], questions?: Question[] }): Promise<Result<ImportStats>> {
    const result = await this.dataService.importData(data);
    if (result.success) {
      await this.loadPoems();
      await this.loadQuestions();
    }
    return result;
  }
}
