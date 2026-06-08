import { FeedbackStatus } from "@bundle:com.example.guesspoetrygame/entry/ets/types/models";
import type { Question, FeedbackItem, GuessRecord } from "@bundle:com.example.guesspoetrygame/entry/ets/types/models";
import { GameState } from "@bundle:com.example.guesspoetrygame/entry/ets/types/states";
import type { GameSession, HintInfo } from "@bundle:com.example.guesspoetrygame/entry/ets/types/states";
import type { MatchResult, Result } from '../types/results';
import type { QuestionRepository } from '../repositories/QuestionRepository';
import type { PoemRepository } from '../repositories/PoemRepository';
import { StringUtils } from "@bundle:com.example.guesspoetrygame/entry/ets/utils/StringUtils";
import { GameConstants } from "@bundle:com.example.guesspoetrygame/entry/ets/constants/GameConstants";
/**
 * 游戏服务类（简化版）
 */
export class GameService {
    private questionRepository: QuestionRepository;
    private poemRepository: PoemRepository;
    constructor(questionRepository: QuestionRepository, poemRepository: PoemRepository) {
        this.questionRepository = questionRepository;
        this.poemRepository = poemRepository;
    }
    /**
     * 开始新游戏
     */
    async startNewGame(): Promise<Result<GameSession>> {
        try {
            // 获取随机题目
            const question = await this.questionRepository.getRandom();
            if (!question) {
                return { success: false, error: '题库为空' };
            }
            // 生成提示信息
            const hint = this.generateHint(question);
            // 初始化游戏会话
            const session: GameSession = {
                state: GameState.PLAYING,
                currentQuestion: question,
                currentPoem: null,
                remainingGuesses: GameConstants.MAX_GUESSES,
                guessHistory: [],
                hint: hint
            };
            return { success: true, data: session };
        }
        catch (error) {
            return { success: false, error: `开始游戏失败: ${error}` };
        }
    }
    /**
     * 提交猜测
     */
    async submitGuess(input: string, session: GameSession): Promise<Result<GameSession>> {
        try {
            if (!session.currentQuestion) {
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
            // 检查是否在诗词库中（使用新的验证方法）
            const isValid = await this.poemRepository.isValidVerseCombination(filteredInput);
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
            const newHistory: GuessRecord[] = [];
            for (const item of session.guessHistory) {
                newHistory.push(item);
            }
            newHistory.push(record);
            const newRemainingGuesses = session.remainingGuesses - 1;
            let newState = session.state;
            if (matchResult.isCorrect) {
                newState = GameState.SUCCESS;
            }
            else if (newRemainingGuesses <= 0) {
                newState = GameState.FAILED;
            }
            const newSession: GameSession = {
                state: newState,
                currentQuestion: session.currentQuestion,
                currentPoem: session.currentPoem,
                remainingGuesses: newRemainingGuesses,
                guessHistory: newHistory,
                hint: session.hint
            };
            return { success: true, data: newSession };
        }
        catch (error) {
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
            const count = answerCharCount.get(char);
            if (count !== undefined) {
                answerCharCount.set(char, count + 1);
            }
            else {
                answerCharCount.set(char, 1);
            }
        }
        for (let i = 0; i < guessChars.length; i++) {
            if (guessChars[i] === answerChars[i]) {
                feedback[i].status = FeedbackStatus.CORRECT;
                const count = answerCharCount.get(guessChars[i]);
                if (count !== undefined) {
                    answerCharCount.set(guessChars[i], count - 1);
                }
            }
        }
        // 第二遍遍历：标记错误位置（黄色）或不存在（灰色）
        for (let i = 0; i < guessChars.length; i++) {
            if (feedback[i].status !== FeedbackStatus.CORRECT) {
                const count = answerCharCount.get(guessChars[i]);
                if (count !== undefined && count > 0) {
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
    generateHint(question: Question): HintInfo {
        console.info(`[GameService] 题目content: ${question.content}`);
        console.info(`[GameService] 题目id: ${question.id}`);
        const filteredContent = StringUtils.filterPunctuation(question.content);
        console.info(`[GameService] 过滤后内容: ${filteredContent}`);
        console.info(`[GameService] 过滤后字数: ${filteredContent.length}`);
        // 根据position字段确定提示
        let prevVerseCharCount = 0;
        let nextVerseCharCount = 0;
        const currentVerseCharCount = filteredContent.length;
        if (question.position === 'upper') {
            // 只有上句，提示下句字数
            if (question.lowerSentence) {
                nextVerseCharCount = StringUtils.countChars(question.lowerSentence);
            }
        }
        else if (question.position === 'lower') {
            // 只有下句，提示上句字数
            if (question.upperSentence) {
                prevVerseCharCount = StringUtils.countChars(question.upperSentence);
            }
        }
        else if (question.position === 'both') {
            // 上下句都有，不提示
        }
        return {
            prevVerseCharCount,
            nextVerseCharCount,
            currentVerseCharCount
        };
    }
}
