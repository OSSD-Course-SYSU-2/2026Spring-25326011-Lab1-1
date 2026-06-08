import { GameState } from "@bundle:com.example.guesspoetrygame/entry/ets/types/states";
import type { GamePageState } from "@bundle:com.example.guesspoetrygame/entry/ets/types/states";
import type { GameService } from '../services/GameService';
/**
 * 游戏视图模型
 */
export class GameViewModel {
    private gameService: GameService;
    private state: GamePageState;
    constructor(gameService: GameService) {
        this.gameService = gameService;
        this.state = {
            session: null,
            inputText: '',
            isLoading: false,
            showRules: false
        };
    }
    /**
     * 获取当前状态
     */
    getState(): GamePageState {
        return this.state;
    }
    /**
     * 开始新游戏
     */
    async startNewGame(): Promise<void> {
        this.state.isLoading = true;
        const result = await this.gameService.startNewGame();
        this.state.isLoading = false;
        if (result.success && result.data) {
            this.state.session = result.data;
            this.state.inputText = '';
        }
        else {
            console.error(`开始游戏失败: ${result.error}`);
        }
    }
    /**
     * 提交猜测
     */
    async submitGuess(): Promise<string | null> {
        if (!this.state.session) {
            return '游戏未开始';
        }
        if (this.state.session.state !== GameState.PLAYING) {
            return '游戏已结束';
        }
        this.state.isLoading = true;
        const result = await this.gameService.submitGuess(this.state.inputText, this.state.session);
        this.state.isLoading = false;
        if (result.success && result.data) {
            this.state.session = result.data;
            this.state.inputText = '';
            return null;
        }
        else {
            return result.error || '提交失败';
        }
    }
    /**
     * 重置游戏
     */
    async resetGame(): Promise<void> {
        await this.startNewGame();
    }
    /**
     * 设置输入文本
     */
    setInputText(text: string): void {
        this.state.inputText = text;
    }
    /**
     * 切换规则显示
     */
    toggleRules(): void {
        this.state.showRules = !this.state.showRules;
    }
    /**
     * 显示规则
     */
    showRulesDialog(): void {
        this.state.showRules = true;
    }
    /**
     * 隐藏规则
     */
    hideRulesDialog(): void {
        this.state.showRules = false;
    }
}
