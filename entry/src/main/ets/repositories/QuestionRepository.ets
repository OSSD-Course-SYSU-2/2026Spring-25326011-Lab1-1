import { Question } from '../types/models';
import { Result } from '../types/results';
import { BaseRepository } from './BaseRepository';

/**
 * 题目仓储类（简化版）
 */
export class QuestionRepository extends BaseRepository<Question> {
  constructor(context: Context) {
    super(context, 'poetry_game_prefs', 'questions', 'questions.json');
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
    const shuffled: Question[] = [];
    for (const item of this.items) {
      shuffled.push(item);
    }
    
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      const temp = shuffled[i];
      shuffled[i] = shuffled[j];
      shuffled[j] = temp;
    }

    return shuffled[0];
  }

  /**
   * 根据难度获取题目
   * @param difficulty 难度等级
   * @returns 该难度的题目列表
   */
  async getByDifficulty(difficulty: number): Promise<Question[]> {
    return this.items.filter((q: Question) => q.difficulty === difficulty);
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
}
