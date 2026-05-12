import { FeedbackItem } from './models';

/**
 * 匹配结果接口
 */
export interface MatchResult {
  isCorrect: boolean;
  isValidInput: boolean;
  feedback: FeedbackItem[];
  errorMessage?: string;
}

/**
 * 泛型结果接口
 */
export interface Result<T> {
  success: boolean;
  data?: T;
  error?: string;
}

/**
 * 导入统计接口
 */
export interface ImportStats {
  poemsImported: number;
  questionsImported: number;
  poemsSkipped: number;
  questionsSkipped: number;
}
