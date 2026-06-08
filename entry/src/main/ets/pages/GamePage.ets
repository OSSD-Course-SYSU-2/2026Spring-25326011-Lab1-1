import router from '@ohos.router';
import { GameSession, GameState } from '../types/states';
import { PoemRepository } from '../repositories/PoemRepository';
import { QuestionRepository } from '../repositories/QuestionRepository';
import { GameService } from '../services/GameService';
import { GameViewModel } from '../viewmodels/GameViewModel';
import { AppTitleBar } from '../components/common/AppTitleBar';
import { LoadingDialog } from '../components/common/LoadingDialog';
import { GameStatus } from '../components/game/GameStatus';
import { HintDisplay } from '../components/game/HintDisplay';
import { GuessHistory } from '../components/game/GuessHistory';
import { GuessInput } from '../components/game/GuessInput';
import { GameResult } from '../components/game/GameResult';
import { GameRules } from '../components/rules/GameRules';
import { GameConstants } from '../constants/GameConstants';

@Entry
@Component
struct GamePage {
  @State private session: GameSession | null = null;
  @State private inputText: string = '';
  @State private isLoading: boolean = false;
  @State private showRules: boolean = false;
  @State private errorMessage: string = '';
  private viewModel: GameViewModel | null = null;

  async aboutToAppear() {
    // 初始化服务和ViewModel
    const context = getContext(this) as Context;

    const poemRepo = new PoemRepository(context);
    const questionRepo = new QuestionRepository(context);

    await poemRepo.init();
    await questionRepo.init();

    const gameService = new GameService(questionRepo, poemRepo);

    this.viewModel = new GameViewModel(gameService);

    // 开始新游戏
    await this.startNewGame();
  }

  async startNewGame() {
    if (!this.viewModel) return;

    this.isLoading = true;
    await this.viewModel.startNewGame();
    const state = this.viewModel.getState();
    this.session = state.session;
    this.inputText = state.inputText;
    this.isLoading = state.isLoading;
  }

  async submitGuess() {
    if (!this.viewModel || !this.session) return;

    this.isLoading = true;
    this.errorMessage = '';

    this.viewModel.setInputText(this.inputText);
    const error = await this.viewModel.submitGuess();

    if (error) {
      this.errorMessage = error;
    } else {
      const state = this.viewModel.getState();
      this.session = state.session;
      this.inputText = state.inputText;
    }

    this.isLoading = false;
  }

  build() {
    Column() {
      // 标题栏
      AppTitleBar({
        title: '猜诗词游戏',
        showBack: true,
        onBackClick: () => {
          router.back();
        }
      })

      // 主内容区
      Column() {
        if (this.session) {
          // 游戏状态
          GameStatus({
            remainingGuesses: this.session.remainingGuesses,
            totalGuesses: GameConstants.MAX_GUESSES
          })

          // 提示信息
          HintDisplay({
            hint: this.session.hint
          })
            .margin({ top: 16 })

          // 猜测历史（限制高度）
          Column() {
            GuessHistory({
              history: this.session.guessHistory
            })
          }
          .height(280)
          .margin({ top: 16 })

          // 游戏结果或输入区
          if (this.session.state === GameState.PLAYING) {
            Column() {
              GuessInput({
                text: $inputText,
                disabled: this.isLoading,
                onSubmit: () => {
                  this.submitGuess();
                }
              })

              // 错误提示
              if (this.errorMessage) {
                Text(this.errorMessage)
                  .fontSize(14)
                  .fontColor('#EF4444')
                  .margin({ top: 8 })
              }
            }
            .margin({ top: 16 })
          } else {
            GameResult({
              state: this.session.state,
              guessCount: this.session.guessHistory.length,
              answer: this.session.currentQuestion?.content || '',
              onNewGame: () => {
                this.startNewGame();
              }
            })
            .margin({ top: 16 })
          }

          // 规则按钮
          Button('游戏规则')
            .width('60%')
            .height(40)
            .fontSize(14)
            .fontColor('#666666')
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .onClick(() => {
              this.showRules = true;
            })
            .margin({ top: 16 })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .padding({ bottom: 16 })

      // 加载对话框
      LoadingDialog({
        visible: this.isLoading,
        message: '加载中...'
      })

      // 游戏规则
      GameRules({
        visible: this.showRules,
        onClose: () => {
          this.showRules = false;
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}
