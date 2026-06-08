if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface GameResult_Params {
    state?: GameState;
    guessCount?: number;
    answer?: string;
    onNewGame?: () => void;
}
import { GameState } from "@bundle:com.example.guesspoetrygame/entry/ets/types/states";
export class GameResult extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__state = new SynchedPropertySimpleOneWayPU(params.state, this, "state");
        this.__guessCount = new SynchedPropertySimpleOneWayPU(params.guessCount, this, "guessCount");
        this.__answer = new SynchedPropertySimpleOneWayPU(params.answer, this, "answer");
        this.onNewGame = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: GameResult_Params) {
        if (params.state === undefined) {
            this.__state.set(GameState.IDLE);
        }
        if (params.guessCount === undefined) {
            this.__guessCount.set(0);
        }
        if (params.answer === undefined) {
            this.__answer.set('');
        }
        if (params.onNewGame !== undefined) {
            this.onNewGame = params.onNewGame;
        }
    }
    updateStateVars(params: GameResult_Params) {
        this.__state.reset(params.state);
        this.__guessCount.reset(params.guessCount);
        this.__answer.reset(params.answer);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__state.purgeDependencyOnElmtId(rmElmtId);
        this.__guessCount.purgeDependencyOnElmtId(rmElmtId);
        this.__answer.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__state.aboutToBeDeleted();
        this.__guessCount.aboutToBeDeleted();
        this.__answer.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __state: SynchedPropertySimpleOneWayPU<GameState>;
    get state() {
        return this.__state.get();
    }
    set state(newValue: GameState) {
        this.__state.set(newValue);
    }
    private __guessCount: SynchedPropertySimpleOneWayPU<number>;
    get guessCount() {
        return this.__guessCount.get();
    }
    set guessCount(newValue: number) {
        this.__guessCount.set(newValue);
    }
    private __answer: SynchedPropertySimpleOneWayPU<string>;
    get answer() {
        return this.__answer.get();
    }
    set answer(newValue: string) {
        this.__answer.set(newValue);
    }
    private onNewGame?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.state === GameState.SUCCESS) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/components/game/GameResult.ets(12:7)", "entry");
                        Column.width('100%');
                        Column.padding(24);
                        Column.backgroundColor('#FFFFFF');
                        Column.borderRadius(12);
                        Column.margin({ left: 16, right: 16 });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('🎉 恭喜你猜对了！');
                        Text.debugLine("entry/src/main/ets/components/game/GameResult.ets(13:9)", "entry");
                        Text.fontSize(24);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#22C55E');
                        Text.margin({ bottom: 16 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(`共猜测 ${this.guessCount} 次`);
                        Text.debugLine("entry/src/main/ets/components/game/GameResult.ets(19:9)", "entry");
                        Text.fontSize(16);
                        Text.fontColor('#666666');
                        Text.margin({ bottom: 24 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Button.createWithLabel('开始新游戏');
                        Button.debugLine("entry/src/main/ets/components/game/GameResult.ets(24:9)", "entry");
                        Button.width('60%');
                        Button.height(48);
                        Button.fontSize(16);
                        Button.fontColor('#FFFFFF');
                        Button.backgroundColor('#3B82F6');
                        Button.borderRadius(8);
                        Button.onClick(() => {
                            if (this.onNewGame) {
                                this.onNewGame();
                            }
                        });
                    }, Button);
                    Button.pop();
                    Column.pop();
                });
            }
            else if (this.state === GameState.FAILED) {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/components/game/GameResult.ets(43:7)", "entry");
                        Column.width('100%');
                        Column.padding(24);
                        Column.backgroundColor('#FFFFFF');
                        Column.borderRadius(12);
                        Column.margin({ left: 16, right: 16 });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('😢 很遗憾，次数用尽');
                        Text.debugLine("entry/src/main/ets/components/game/GameResult.ets(44:9)", "entry");
                        Text.fontSize(24);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#EF4444');
                        Text.margin({ bottom: 16 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('正确答案：');
                        Text.debugLine("entry/src/main/ets/components/game/GameResult.ets(50:9)", "entry");
                        Text.fontSize(14);
                        Text.fontColor('#999999');
                        Text.margin({ bottom: 8 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.answer);
                        Text.debugLine("entry/src/main/ets/components/game/GameResult.ets(55:9)", "entry");
                        Text.fontSize(18);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#333333');
                        Text.margin({ bottom: 24 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Button.createWithLabel('开始新游戏');
                        Button.debugLine("entry/src/main/ets/components/game/GameResult.ets(61:9)", "entry");
                        Button.width('60%');
                        Button.height(48);
                        Button.fontSize(16);
                        Button.fontColor('#FFFFFF');
                        Button.backgroundColor('#3B82F6');
                        Button.borderRadius(8);
                        Button.onClick(() => {
                            if (this.onNewGame) {
                                this.onNewGame();
                            }
                        });
                    }, Button);
                    Button.pop();
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(2, () => {
                });
            }
        }, If);
        If.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
