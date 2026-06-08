if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface GamePage_Params {
    session?: GameSession | null;
    inputText?: string;
    isLoading?: boolean;
    showRules?: boolean;
    errorMessage?: string;
    viewModel?: GameViewModel | null;
}
import router from "@ohos:router";
import { GameState } from "@bundle:com.example.guesspoetrygame/entry/ets/types/states";
import type { GameSession } from "@bundle:com.example.guesspoetrygame/entry/ets/types/states";
import { PoemRepository } from "@bundle:com.example.guesspoetrygame/entry/ets/repositories/PoemRepository";
import { QuestionRepository } from "@bundle:com.example.guesspoetrygame/entry/ets/repositories/QuestionRepository";
import { GameService } from "@bundle:com.example.guesspoetrygame/entry/ets/services/GameService";
import { GameViewModel } from "@bundle:com.example.guesspoetrygame/entry/ets/viewmodels/GameViewModel";
import { AppTitleBar } from "@bundle:com.example.guesspoetrygame/entry/ets/components/common/AppTitleBar";
import { LoadingDialog } from "@bundle:com.example.guesspoetrygame/entry/ets/components/common/LoadingDialog";
import { GameStatus } from "@bundle:com.example.guesspoetrygame/entry/ets/components/game/GameStatus";
import { HintDisplay } from "@bundle:com.example.guesspoetrygame/entry/ets/components/game/HintDisplay";
import { GuessHistory } from "@bundle:com.example.guesspoetrygame/entry/ets/components/game/GuessHistory";
import { GuessInput } from "@bundle:com.example.guesspoetrygame/entry/ets/components/game/GuessInput";
import { GameResult } from "@bundle:com.example.guesspoetrygame/entry/ets/components/game/GameResult";
import { GameRules } from "@bundle:com.example.guesspoetrygame/entry/ets/components/rules/GameRules";
import { GameConstants } from "@bundle:com.example.guesspoetrygame/entry/ets/constants/GameConstants";
class GamePage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__session = new ObservedPropertyObjectPU(null, this, "session");
        this.__inputText = new ObservedPropertySimplePU('', this, "inputText");
        this.__isLoading = new ObservedPropertySimplePU(false, this, "isLoading");
        this.__showRules = new ObservedPropertySimplePU(false, this, "showRules");
        this.__errorMessage = new ObservedPropertySimplePU('', this, "errorMessage");
        this.viewModel = null;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: GamePage_Params) {
        if (params.session !== undefined) {
            this.session = params.session;
        }
        if (params.inputText !== undefined) {
            this.inputText = params.inputText;
        }
        if (params.isLoading !== undefined) {
            this.isLoading = params.isLoading;
        }
        if (params.showRules !== undefined) {
            this.showRules = params.showRules;
        }
        if (params.errorMessage !== undefined) {
            this.errorMessage = params.errorMessage;
        }
        if (params.viewModel !== undefined) {
            this.viewModel = params.viewModel;
        }
    }
    updateStateVars(params: GamePage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__session.purgeDependencyOnElmtId(rmElmtId);
        this.__inputText.purgeDependencyOnElmtId(rmElmtId);
        this.__isLoading.purgeDependencyOnElmtId(rmElmtId);
        this.__showRules.purgeDependencyOnElmtId(rmElmtId);
        this.__errorMessage.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__session.aboutToBeDeleted();
        this.__inputText.aboutToBeDeleted();
        this.__isLoading.aboutToBeDeleted();
        this.__showRules.aboutToBeDeleted();
        this.__errorMessage.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __session: ObservedPropertyObjectPU<GameSession | null>;
    get session() {
        return this.__session.get();
    }
    set session(newValue: GameSession | null) {
        this.__session.set(newValue);
    }
    private __inputText: ObservedPropertySimplePU<string>;
    get inputText() {
        return this.__inputText.get();
    }
    set inputText(newValue: string) {
        this.__inputText.set(newValue);
    }
    private __isLoading: ObservedPropertySimplePU<boolean>;
    get isLoading() {
        return this.__isLoading.get();
    }
    set isLoading(newValue: boolean) {
        this.__isLoading.set(newValue);
    }
    private __showRules: ObservedPropertySimplePU<boolean>;
    get showRules() {
        return this.__showRules.get();
    }
    set showRules(newValue: boolean) {
        this.__showRules.set(newValue);
    }
    private __errorMessage: ObservedPropertySimplePU<string>;
    get errorMessage() {
        return this.__errorMessage.get();
    }
    set errorMessage(newValue: string) {
        this.__errorMessage.set(newValue);
    }
    private viewModel: GameViewModel | null;
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
        if (!this.viewModel)
            return;
        this.isLoading = true;
        await this.viewModel.startNewGame();
        const state = this.viewModel.getState();
        this.session = state.session;
        this.inputText = state.inputText;
        this.isLoading = state.isLoading;
    }
    async submitGuess() {
        if (!this.viewModel || !this.session)
            return;
        this.isLoading = true;
        this.errorMessage = '';
        this.viewModel.setInputText(this.inputText);
        const error = await this.viewModel.submitGuess();
        if (error) {
            this.errorMessage = error;
        }
        else {
            const state = this.viewModel.getState();
            this.session = state.session;
            this.inputText = state.inputText;
        }
        this.isLoading = false;
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/GamePage.ets(77:5)", "entry");
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F5F5F5');
        }, Column);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new 
                    // 标题栏
                    AppTitleBar(this, {
                        title: '猜诗词游戏',
                        showBack: true,
                        onBackClick: () => {
                            router.back();
                        }
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/GamePage.ets", line: 79, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            title: '猜诗词游戏',
                            showBack: true,
                            onBackClick: () => {
                                router.back();
                            }
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {
                        title: '猜诗词游戏',
                        showBack: true
                    });
                }
            }, { name: "AppTitleBar" });
        }
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 主内容区
            Column.create();
            Column.debugLine("entry/src/main/ets/pages/GamePage.ets(88:7)", "entry");
            // 主内容区
            Column.width('100%');
            // 主内容区
            Column.layoutWeight(1);
            // 主内容区
            Column.padding({ bottom: 16 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.session) {
                this.ifElseBranchUpdateFunction(0, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new 
                                // 游戏状态
                                GameStatus(this, {
                                    remainingGuesses: this.session.remainingGuesses,
                                    totalGuesses: GameConstants.MAX_GUESSES
                                }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/GamePage.ets", line: 91, col: 11 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {
                                        remainingGuesses: this.session.remainingGuesses,
                                        totalGuesses: GameConstants.MAX_GUESSES
                                    };
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {
                                    remainingGuesses: this.session.remainingGuesses,
                                    totalGuesses: GameConstants.MAX_GUESSES
                                });
                            }
                        }, { name: "GameStatus" });
                    }
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        __Common__.create();
                        __Common__.margin({ top: 16 });
                    }, __Common__);
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new 
                                // 提示信息
                                HintDisplay(this, {
                                    hint: this.session.hint
                                }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/GamePage.ets", line: 97, col: 11 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {
                                        hint: this.session.hint
                                    };
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {
                                    hint: this.session.hint
                                });
                            }
                        }, { name: "HintDisplay" });
                    }
                    __Common__.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 猜测历史（限制高度）
                        Column.create();
                        Column.debugLine("entry/src/main/ets/pages/GamePage.ets(103:11)", "entry");
                        // 猜测历史（限制高度）
                        Column.height(280);
                        // 猜测历史（限制高度）
                        Column.margin({ top: 16 });
                    }, Column);
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new GuessHistory(this, {
                                    history: this.session.guessHistory
                                }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/GamePage.ets", line: 104, col: 13 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {
                                        history: this.session.guessHistory
                                    };
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {
                                    history: this.session.guessHistory
                                });
                            }
                        }, { name: "GuessHistory" });
                    }
                    // 猜测历史（限制高度）
                    Column.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        // 游戏结果或输入区
                        if (this.session.state === GameState.PLAYING) {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    Column.create();
                                    Column.debugLine("entry/src/main/ets/pages/GamePage.ets(113:13)", "entry");
                                    Column.margin({ top: 16 });
                                }, Column);
                                {
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        if (isInitialRender) {
                                            let componentCall = new GuessInput(this, {
                                                text: this.__inputText,
                                                disabled: this.isLoading,
                                                onSubmit: () => {
                                                    this.submitGuess();
                                                }
                                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/GamePage.ets", line: 114, col: 15 });
                                            ViewPU.create(componentCall);
                                            let paramsLambda = () => {
                                                return {
                                                    text: this.inputText,
                                                    disabled: this.isLoading,
                                                    onSubmit: () => {
                                                        this.submitGuess();
                                                    }
                                                };
                                            };
                                            componentCall.paramsGenerator_ = paramsLambda;
                                        }
                                        else {
                                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                                disabled: this.isLoading
                                            });
                                        }
                                    }, { name: "GuessInput" });
                                }
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    If.create();
                                    // 错误提示
                                    if (this.errorMessage) {
                                        this.ifElseBranchUpdateFunction(0, () => {
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Text.create(this.errorMessage);
                                                Text.debugLine("entry/src/main/ets/pages/GamePage.ets(124:17)", "entry");
                                                Text.fontSize(14);
                                                Text.fontColor('#EF4444');
                                                Text.margin({ top: 8 });
                                            }, Text);
                                            Text.pop();
                                        });
                                    }
                                    else {
                                        this.ifElseBranchUpdateFunction(1, () => {
                                        });
                                    }
                                }, If);
                                If.pop();
                                Column.pop();
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    __Common__.create();
                                    __Common__.margin({ top: 16 });
                                }, __Common__);
                                {
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        if (isInitialRender) {
                                            let componentCall = new GameResult(this, {
                                                state: this.session.state,
                                                guessCount: this.session.guessHistory.length,
                                                answer: this.session.currentQuestion?.content || '',
                                                onNewGame: () => {
                                                    this.startNewGame();
                                                }
                                            }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/GamePage.ets", line: 132, col: 13 });
                                            ViewPU.create(componentCall);
                                            let paramsLambda = () => {
                                                return {
                                                    state: this.session.state,
                                                    guessCount: this.session.guessHistory.length,
                                                    answer: this.session.currentQuestion?.content || '',
                                                    onNewGame: () => {
                                                        this.startNewGame();
                                                    }
                                                };
                                            };
                                            componentCall.paramsGenerator_ = paramsLambda;
                                        }
                                        else {
                                            this.updateStateVarsOfChildByElmtId(elmtId, {
                                                state: this.session.state,
                                                guessCount: this.session.guessHistory.length,
                                                answer: this.session.currentQuestion?.content || ''
                                            });
                                        }
                                    }, { name: "GameResult" });
                                }
                                __Common__.pop();
                            });
                        }
                    }, If);
                    If.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 规则按钮
                        Button.createWithLabel('游戏规则');
                        Button.debugLine("entry/src/main/ets/pages/GamePage.ets(144:11)", "entry");
                        // 规则按钮
                        Button.width('60%');
                        // 规则按钮
                        Button.height(40);
                        // 规则按钮
                        Button.fontSize(14);
                        // 规则按钮
                        Button.fontColor('#666666');
                        // 规则按钮
                        Button.backgroundColor('#F5F5F5');
                        // 规则按钮
                        Button.borderRadius(8);
                        // 规则按钮
                        Button.onClick(() => {
                            this.showRules = true;
                        });
                        // 规则按钮
                        Button.margin({ top: 16 });
                    }, Button);
                    // 规则按钮
                    Button.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        // 主内容区
        Column.pop();
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new 
                    // 加载对话框
                    LoadingDialog(this, {
                        visible: this.isLoading,
                        message: '加载中...'
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/GamePage.ets", line: 162, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            visible: this.isLoading,
                            message: '加载中...'
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {
                        visible: this.isLoading,
                        message: '加载中...'
                    });
                }
            }, { name: "LoadingDialog" });
        }
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new 
                    // 游戏规则
                    GameRules(this, {
                        visible: this.showRules,
                        onClose: () => {
                            this.showRules = false;
                        }
                    }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/GamePage.ets", line: 168, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            visible: this.showRules,
                            onClose: () => {
                                this.showRules = false;
                            }
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {
                        visible: this.showRules
                    });
                }
            }, { name: "GameRules" });
        }
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "GamePage";
    }
}
registerNamedRoute(() => new GamePage(undefined, {}), "", { bundleName: "com.example.guesspoetrygame", moduleName: "entry", pagePath: "pages/GamePage", pageFullPath: "entry/src/main/ets/pages/GamePage", integratedHsp: "false", moduleType: "followWithHap" });
