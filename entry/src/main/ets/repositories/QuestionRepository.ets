import { Question } from '../types/models';
import { Result } from '../types/results';
import { BaseRepository } from './BaseRepository';

/**
 * 题目仓储类
 */
export class QuestionRepository extends BaseRepository<Question> {
  constructor(context: Context) {
    super(context, 'poetry_game_prefs', 'questions', 'questions.json');
  }

  /**
   * 根据分类获取题目
   * @param categoryId 分类ID
   * @returns 该分类下的题目列表
   */
  async getByCategory(categoryId: string): Promise<Question[]> {
    return this.items.filter((q: Question) => {
      return q.categoryIds && q.categoryIds.includes(categoryId);
    });
  }

  /**
   * 随机获取一道题目（使用Fisher-Yates洗牌算法）
   * @returns 随机题目
   */
  async getRandom(): Promise<Question | null> {
    if (this.items.length === 0) {
      return null;
    }

    // Fisher-Yates洗牌算法
    const shuffled = [...this.items];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }

    return shuffled[0];
  }

  /**
   * 根据诗词ID获取题目
   * @param poemId 诗词ID
   * @returns 该诗词下的题目列表
   */
  async getByPoemId(poemId: string): Promise<Question[]> {
    return this.items.filter((q: Question) => q.poemId === poemId);
  }

  /**
   * 设置题目难度
   * @param id 题目ID
   * @param difficulty 难度等级
   * @returns 更新结果
   */
  async setDifficulty(id: string, difficulty: number): Promise<Result<Question>> {
    const question = await this.getById(id);
    if (!question) {
      return { success: false, error: '未找到题目' };
    }

    question.difficulty = difficulty;
    return await this.update(question);
  }

  /**
   * 分配题目到分类
   * @param questionId 题目ID
   * @param categoryId 分类ID
   * @returns 更新结果
   */
  async assignToCategory(questionId: string, categoryId: string): Promise<Result<Question>> {
    const question = await this.getById(questionId);
    if (!question) {
      return { success: false, error: '未找到题目' };
    }

    if (!question.categoryIds) {
      question.categoryIds = [];
    }

    if (!question.categoryIds.includes(categoryId)) {
      question.categoryIds.push(categoryId);
    }

    return await this.update(question);
  }

  /**
   * 从分类移除题目
   * @param questionId 题目ID
   * @param categoryId 分类ID
   * @returns 更新结果
   */
  async removeFromCategory(questionId: string, categoryId: string): Promise<Result<Question>> {
    const question = await this.getById(questionId);
    if (!question) {
      return { success: false, error: '未找到题目' };
    }

    if (question.categoryIds) {
      const index = question.categoryIds.indexOf(categoryId);
      if (index !== -1) {
        question.categoryIds.splice(index, 1);
      }
    }

    return await this.update(question);
  }
}
