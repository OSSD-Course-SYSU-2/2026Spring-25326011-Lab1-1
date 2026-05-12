/**
 * 反馈状态枚举
 * CORRECT: 正确位置（绿色）
 * MISPLACED: 错误位置（黄色）
 * ABSENT: 不存在（灰色）
 */
export enum FeedbackStatus {
  CORRECT = 'CORRECT',
  MISPLACED = 'MISPLACED',
  ABSENT = 'ABSENT'
}

/**
 * 难度等级枚举（1-5）
 */
export enum Difficulty {
  VERY_EASY = 1,
  EASY = 2,
  MEDIUM = 3,
  HARD = 4,
  VERY_HARD = 5
}

/**
 * 诗词接口
 */
export interface Poem {
  id: string;
  title: string;
  author: string;
  dynasty: string;
  verses: string[];
}

/**
 * 题目接口
 */
export interface Question {
  id: string;
  content: string;
  poemId: string;
  difficulty?: Difficulty;
  categoryIds?: string[];
}

/**
 * 分类接口
 */
export interface Category {
  id: string;
  name: string;
  description?: string;
}

/**
 * 反馈项接口
 */
export interface FeedbackItem {
  char: string;
  status: FeedbackStatus;
}

/**
 * 猜测记录接口
 */
export interface GuessRecord {
  content: string;
  feedback: FeedbackItem[];
  timestamp: number;
}
