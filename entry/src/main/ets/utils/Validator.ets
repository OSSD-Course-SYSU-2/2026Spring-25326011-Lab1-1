import { Poem, Question, Category } from '../types/models';
import { Result } from '../types/results';

/**
 * 数据验证工具类
 */
export class Validator {
  /**
   * 判断是否为对象
   * @param value 待判断的值
   * @returns 是否为对象
   */
  private static isObject(value: Object | null | undefined): boolean {
    return value !== null && value !== undefined && typeof value === 'object';
  }

  /**
   * 验证诗词数据
   * @param data 待验证的数据
   * @returns 验证结果
   */
  static validatePoem(data: Object | null | undefined): Result<Poem> {
    if (!Validator.isObject(data)) {
      return { success: false, error: '数据不是有效的对象' };
    }

    const obj = data as Record<string, Object | null | undefined>;

    if (!obj.id || typeof obj.id !== 'string') {
      return { success: false, error: '缺少有效的id字段' };
    }

    if (!obj.title || typeof obj.title !== 'string') {
      return { success: false, error: '缺少有效的title字段' };
    }

    if (!obj.author || typeof obj.author !== 'string') {
      return { success: false, error: '缺少有效的author字段' };
    }

    if (!obj.dynasty || typeof obj.dynasty !== 'string') {
      return { success: false, error: '缺少有效的dynasty字段' };
    }

    if (!Array.isArray(obj.verses)) {
      return { success: false, error: '缺少有效的verses数组' };
    }

    for (const verse of obj.verses) {
      if (typeof verse !== 'string') {
        return { success: false, error: 'verses数组包含非字符串元素' };
      }
    }

    return { success: true, data: obj as Poem };
  }

  /**
   * 验证题目数据
   * @param data 待验证的数据
   * @returns 验证结果
   */
  static validateQuestion(data: Object | null | undefined): Result<Question> {
    if (!Validator.isObject(data)) {
      return { success: false, error: '数据不是有效的对象' };
    }

    const obj = data as Record<string, Object | null | undefined>;

    if (!obj.id || typeof obj.id !== 'string') {
      return { success: false, error: '缺少有效的id字段' };
    }

    if (!obj.content || typeof obj.content !== 'string') {
      return { success: false, error: '缺少有效的content字段' };
    }

    if (!obj.poemId || typeof obj.poemId !== 'string') {
      return { success: false, error: '缺少有效的poemId字段' };
    }

    return { success: true, data: obj as Question };
  }

  /**
   * 验证分类数据
   * @param data 待验证的数据
   * @returns 验证结果
   */
  static validateCategory(data: Object | null | undefined): Result<Category> {
    if (!Validator.isObject(data)) {
      return { success: false, error: '数据不是有效的对象' };
    }

    const obj = data as Record<string, Object | null | undefined>;

    if (!obj.id || typeof obj.id !== 'string') {
      return { success: false, error: '缺少有效的id字段' };
    }

    if (!obj.name || typeof obj.name !== 'string') {
      return { success: false, error: '缺少有效的name字段' };
    }

    return { success: true, data: obj as Category };
  }

  /**
   * 验证诗词数组
   * @param data 待验证的数据
   * @returns 验证结果
   */
  static validatePoems(data: Object[] | null | undefined): Result<Poem[]> {
    if (!Array.isArray(data)) {
      return { success: false, error: '数据不是有效的数组' };
    }

    const poems: Poem[] = [];
    for (const item of data) {
      const result = Validator.validatePoem(item);
      if (!result.success) {
        return { success: false, error: result.error };
      }
      if (result.data) {
        poems.push(result.data);
      }
    }

    return { success: true, data: poems };
  }

  /**
   * 验证题目数组
   * @param data 待验证的数据
   * @returns 验证结果
   */
  static validateQuestions(data: Object[] | null | undefined): Result<Question[]> {
    if (!Array.isArray(data)) {
      return { success: false, error: '数据不是有效的数组' };
    }

    const questions: Question[] = [];
    for (const item of data) {
      const result = Validator.validateQuestion(item);
      if (!result.success) {
        return { success: false, error: result.error };
      }
      if (result.data) {
        questions.push(result.data);
      }
    }

    return { success: true, data: questions };
  }
}
