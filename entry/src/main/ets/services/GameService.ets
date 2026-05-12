import { Poem, Question, FeedbackItem, FeedbackStatus, GuessRecord } from '../types/models';
import { GameSession, GameState, HintInfo } from '../types/states';
import { MatchResult, Result } from '../types/results';
import { PoemService } from './PoemService';
import { QuestionService } from './QuestionService';
import { StringUtils } from '../utils/StringUtils';
import { GameConstants } from '../constants/GameConstants';

/**
 * 游戏服务类
 */
export class GameService {
  private poemService: PoemService;
  private questionService: QuestionService;

  constructor(poemService: PoemService, questionService: QuestionService) {
    this.poemService = poemService;
    this.questionService = questionService;
  }

  /**
   * 开始新游戏
   */
  async startNewGame(): Promise<Result<GameSession>> {
    try {
      // 获取随机题目
      const questionResult = await this.questionService.getRandomQuestion();
      if (!questionResult.success || !questionResult.data) {
        return { success: false, error: questionResult.error || '获取题目失败' };
      }

      const question = questionResult.data;

      // 获取对应诗词
      const poemResult = await this.poemService.getPoemById(question.poemId);
      if (!poemResult.success || !poemResult.data) {
        return { success: false, error: poemResult.error || '获取诗词失败' };
      }

      const poem = poemResult.data;

      // 生成提示信息
      const hint = this.generateHint(poem, question.content);

      // 初始化游戏会话
      const session: GameSession = {
        state: GameState.PLAYING,
        currentQuestion: question,
        currentPoem: poem,
        remainingGuesses: GameConstants.MAX_GUESSES,
        guessHistory: [],
        hint: hint
      };

      return { success: true, data: session };
    } catch (error) {
      return { success: false, error: `开始游戏失败: ${error}` };
    }
  }

  /**
   * 提交猜测
   */
  async submitGuess(input: string, session: GameSession): Promise<Result<GameSession>> {
    try {
      if (!session.currentQuestion || !session.currentPoem) {
        return { success: false, error: '游戏会话无效' };
      }

      // 验证输入非空
      if (StringUtils.isEmpty(input)) {
        return { success: false, error: '请输入诗句' };
      }

      // 过滤标点符号
      const filteredInput = StringUtils.filterPunctuation(input);
      const filteredAnswer = StringUtils.filterPunctuation(session.currentQuestion.content);

      // 检查字数是否正确
      if (filteredInput.length !== filteredAnswer.length) {
        return {
          success: false,
          error: `字数不正确，应为${filteredAnswer.length}字`
        };
      }

      // 检查是否在诗词库中
      const isValid = await this.poemService.containsVerse(filteredInput);

      if (!isValid) {
        return {
          success: false,
          error: '请输入一句字数正确的古诗词'
        };
      }

      // 计算反馈
      const matchResult = this.calculateFeedback(filteredInput, filteredAnswer);

      // 创建猜测记录
      const record: GuessRecord = {
        content: filteredInput,
        feedback: matchResult.feedback,
        timestamp: Date.now()
      };

      // 更新游戏会话
      const newHistory = [...session.guessHistory, record];
      const newRemainingGuesses = session.remainingGuesses - 1;

      let newState = session.state;
      if (matchResult.isCorrect) {
        newState = GameState.SUCCESS;
      } else if (newRemainingGuesses <= 0) {
        newState = GameState.FAILED;
      }

      const newSession: GameSession = {
        ...session,
        state: newState,
        remainingGuesses: newRemainingGuesses,
        guessHistory: newHistory
      };

      return { success: true, data: newSession };
    } catch (error) {
      return { success: false, error: `提交猜测失败: ${error}` };
    }
  }

  /**
   * 计算反馈（核心算法）
   */
  calculateFeedback(guess: string, answer: string): MatchResult {
    const guessChars = StringUtils.toCharArray(guess);
    const answerChars = StringUtils.toCharArray(answer);
    const feedback: FeedbackItem[] = [];

    // 初始化反馈数组
    for (let i = 0; i < guessChars.length; i++) {
      feedback.push({
        char: guessChars[i],
        status: FeedbackStatus.ABSENT
      });
    }

    // 第一遍遍历：标记正确位置（绿色）
    const answerCharCount: Map<string, number> = new Map();
    for (const char of answerChars) {
      answerCharCount.set(char, (answerCharCount.get(char) || 0) + 1);
    }

    for (let i = 0; i < guessChars.length; i++) {
      if (guessChars[i] === answerChars[i]) {
        feedback[i].status = FeedbackStatus.CORRECT;
        const count = answerCharCount.get(guessChars[i]) || 0;
        answerCharCount.set(guessChars[i], count - 1);
      }
    }

    // 第二遍遍历：标记错误位置（黄色）或不存在（灰色）
    for (let i = 0; i < guessChars.length; i++) {
      if (feedback[i].status !== FeedbackStatus.CORRECT) {
        const count = answerCharCount.get(guessChars[i]) || 0;
        if (count > 0) {
          feedback[i].status = FeedbackStatus.MISPLACED;
          answerCharCount.set(guessChars[i], count - 1);
        }
      }
    }

    // 检查是否完全正确
    const isCorrect = feedback.every(f => f.status === FeedbackStatus.CORRECT);

    return {
      isCorrect,
      isValidInput: true,
      feedback
    };
  }

  /**
   * 生成提示信息
   */
  generateHint(poem: Poem, verse: string): HintInfo {
    const filteredVerse = StringUtils.filterPunctuation(verse);
    const verseIndex = poem.verses.findIndex((v: string) => {
      return StringUtils.filterPunctuation(v) === filteredVerse;
    });

    let prevVerseCharCount = 0;
    let nextVerseCharCount = 0;
    const currentVerseCharCount = filteredVerse.length;

    if (verseIndex > 0) {
      prevVerseCharCount = StringUtils.countChars(poem.verses[verseIndex - 1]);
    }

    if (verseIndex < poem.verses.length - 1) {
      nextVerseCharCount = StringUtils.countChars(poem.verses[verseIndex + 1]);
    }

    return {
      prevVerseCharCount,
      nextVerseCharCount,
      currentVerseCharCount
    };
  }
}
