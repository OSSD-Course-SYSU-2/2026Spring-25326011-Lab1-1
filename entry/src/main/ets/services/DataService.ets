import { Poem, Question } from '../types/models';
import { Result, ImportStats } from '../types/results';
import { PoemService } from './PoemService';
import { QuestionService } from './QuestionService';
import { Validator } from '../utils/Validator';

/**
 * 数据服务类
 */
export class DataService {
  private poemService: PoemService;
  private questionService: QuestionService;

  constructor(poemService: PoemService, questionService: QuestionService) {
    this.poemService = poemService;
    this.questionService = questionService;
  }

  /**
   * 导出数据
   */
  async exportData(): Promise<Result<{ poems: Poem[], questions: Question[] }>> {
    try {
      const poemsResult = await this.poemService.getAllPoems();
      if (!poemsResult.success) {
        return { success: false, error: poemsResult.error };
      }

      const questionsResult = await this.questionService.getAllQuestions();
      if (!questionsResult.success) {
        return { success: false, error: questionsResult.error };
      }

      return {
        success: true,
        data: {
          poems: poemsResult.data || [],
          questions: questionsResult.data || []
        }
      };
    } catch (error) {
      return { success: false, error: `导出数据失败: ${error}` };
    }
  }

  /**
   * 导入数据
   */
  async importData(data: { poems?: Poem[], questions?: Question[] }): Promise<Result<ImportStats>> {
    try {
      const stats: ImportStats = {
        poemsImported: 0,
        questionsImported: 0,
        poemsSkipped: 0,
        questionsSkipped: 0
      };

      // 导入诗词
      if (data.poems && Array.isArray(data.poems)) {
        for (const poem of data.poems) {
          const validationResult = Validator.validatePoem(poem);
          if (validationResult.success) {
            const addResult = await this.poemService.addPoem(poem);
            if (addResult.success) {
              stats.poemsImported++;
            } else {
              stats.poemsSkipped++;
            }
          } else {
            stats.poemsSkipped++;
          }
        }
      }

      // 导入题目
      if (data.questions && Array.isArray(data.questions)) {
        for (const question of data.questions) {
          const validationResult = Validator.validateQuestion(question);
          if (validationResult.success) {
            const addResult = await this.questionService.addQuestion(question);
            if (addResult.success) {
              stats.questionsImported++;
            } else {
              stats.questionsSkipped++;
            }
          } else {
            stats.questionsSkipped++;
          }
        }
      }

      return { success: true, data: stats };
    } catch (error) {
      return { success: false, error: `导入数据失败: ${error}` };
    }
  }

  /**
   * 验证数据格式
   */
  validateData(data: unknown): Result<{ poems?: Poem[], questions?: Question[] }> {
    try {
      if (!data || typeof data !== 'object') {
        return { success: false, error: '数据格式无效' };
      }

      const obj = data as Record<string, unknown>;
      const result: { poems?: Poem[], questions?: Question[] } = {};

      if (obj.poems) {
        const poemsResult = Validator.validatePoems(obj.poems);
        if (!poemsResult.success) {
          return { success: false, error: `诗词数据验证失败: ${poemsResult.error}` };
        }
        result.poems = poemsResult.data;
      }

      if (obj.questions) {
        const questionsResult = Validator.validateQuestions(obj.questions);
        if (!questionsResult.success) {
          return { success: false, error: `题目数据验证失败: ${questionsResult.error}` };
        }
        result.questions = questionsResult.data;
      }

      return { success: true, data: result };
    } catch (error) {
      return { success: false, error: `验证数据失败: ${error}` };
    }
  }
}
