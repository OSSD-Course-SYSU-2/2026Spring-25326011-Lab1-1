import { Question } from '../types/models';
import { Result } from '../types/results';
import { QuestionRepository } from '../repositories/QuestionRepository';

/**
 * 题目服务类
 */
export class QuestionService {
  private questionRepository: QuestionRepository;

  constructor(questionRepository: QuestionRepository) {
    this.questionRepository = questionRepository;
  }

  /**
   * 获取所有题目
   */
  async getAllQuestions(): Promise<Result<Question[]>> {
    try {
      const questions = await this.questionRepository.getAll();
      return { success: true, data: questions };
    } catch (error) {
      return { success: false, error: `获取题目列表失败: ${error}` };
    }
  }

  /**
   * 根据ID获取题目
   */
  async getQuestionById(id: string): Promise<Result<Question>> {
    try {
      const question = await this.questionRepository.getById(id);
      if (!question) {
        return { success: false, error: '未找到题目' };
      }
      return { success: true, data: question };
    } catch (error) {
      return { success: false, error: `获取题目失败: ${error}` };
    }
  }

  /**
   * 随机获取一道题目
   */
  async getRandomQuestion(): Promise<Result<Question>> {
    try {
      const question = await this.questionRepository.getRandom();
      if (!question) {
        return { success: false, error: '题库为空' };
      }
      return { success: true, data: question };
    } catch (error) {
      return { success: false, error: `获取随机题目失败: ${error}` };
    }
  }

  /**
   * 添加题目
   */
  async addQuestion(question: Question): Promise<Result<Question>> {
    try {
      // 检查是否已存在相同ID的题目
      const existing = await this.questionRepository.getById(question.id);
      if (existing) {
        return { success: false, error: '题目ID已存在' };
      }

      return await this.questionRepository.add(question);
    } catch (error) {
      return { success: false, error: `添加题目失败: ${error}` };
    }
  }

  /**
   * 更新题目
   */
  async updateQuestion(question: Question): Promise<Result<Question>> {
    try {
      return await this.questionRepository.update(question);
    } catch (error) {
      return { success: false, error: `更新题目失败: ${error}` };
    }
  }

  /**
   * 删除题目
   */
  async deleteQuestion(id: string): Promise<Result<void>> {
    try {
      return await this.questionRepository.delete(id);
    } catch (error) {
      return { success: false, error: `删除题目失败: ${error}` };
    }
  }

  /**
   * 设置题目难度
   */
  async setDifficulty(id: string, difficulty: number): Promise<Result<Question>> {
    try {
      return await this.questionRepository.setDifficulty(id, difficulty);
    } catch (error) {
      return { success: false, error: `设置难度失败: ${error}` };
    }
  }

  /**
   * 分配题目到分类
   */
  async assignToCategory(questionId: string, categoryId: string): Promise<Result<Question>> {
    try {
      return await this.questionRepository.assignToCategory(questionId, categoryId);
    } catch (error) {
      return { success: false, error: `分配到分类失败: ${error}` };
    }
  }

  /**
   * 从分类移除题目
   */
  async removeFromCategory(questionId: string, categoryId: string): Promise<Result<Question>> {
    try {
      return await this.questionRepository.removeFromCategory(questionId, categoryId);
    } catch (error) {
      return { success: false, error: `从分类移除失败: ${error}` };
    }
  }

  /**
   * 根据分类获取题目
   */
  async getQuestionsByCategory(categoryId: string): Promise<Result<Question[]>> {
    try {
      const questions = await this.questionRepository.getByCategory(categoryId);
      return { success: true, data: questions };
    } catch (error) {
      return { success: false, error: `获取分类题目失败: ${error}` };
    }
  }

  /**
   * 根据诗词ID获取题目
   */
  async getQuestionsByPoemId(poemId: string): Promise<Result<Question[]>> {
    try {
      const questions = await this.questionRepository.getByPoemId(poemId);
      return { success: true, data: questions };
    } catch (error) {
      return { success: false, error: `获取诗词题目失败: ${error}` };
    }
  }
}
