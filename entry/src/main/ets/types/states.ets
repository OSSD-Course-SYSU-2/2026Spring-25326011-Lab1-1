/**
 * 游戏状态枚举
 */
export enum GameState {
  IDLE = 'IDLE',
  PLAYING = 'PLAYING',
  SUCCESS = 'SUCCESS',
  FAILED = 'FAILED'
}

/**
 * 提示信息接口
 */
export interface HintInfo {
  prevVerseCharCount: number;
  nextVerseCharCount: number;
  currentVerseCharCount: number;
}

/**
 * 游戏会话接口
 */
export interface GameSession {
  state: GameState;
  currentQuestion: Question | null;
  currentPoem: Poem | null;
  remainingGuesses: number;
  guessHistory: GuessRecord[];
  hint: HintInfo | null;
}

/**
 * 游戏页面状态接口
 */
export interface GamePageState {
  session: GameSession | null;
  inputText: string;
  isLoading: boolean;
  showRules: boolean;
}

/**
 * 管理页面状态接口
 */
export interface ManagePageState {
  activeTab: 'poems' | 'questions' | 'categories';
  poems: Poem[];
  questions: Question[];
  categories: Category[];
  searchKeyword: string;
  isLoading: boolean;
}

// 导入类型依赖
import { Poem, Question, Category, GuessRecord } from './models';
