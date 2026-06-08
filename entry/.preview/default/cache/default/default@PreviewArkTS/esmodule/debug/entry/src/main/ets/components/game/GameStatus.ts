if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface GameStatus_Params {
    remainingGuesses?: number;
    totalGuesses?: number;
}
import { GameConstants } from "@bundle:com.example.guesspoetrygame/entry/ets/constants/GameConstants";
export class GameStatus extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__remainingGuesses = new SynchedPropertySimpleOneWayPU(params.remainingGuesses, this, "remainingGuesses");
        this.__totalGuesses = new SynchedPropertySimpleOneWayPU(params.totalGuesses, this, "totalGuesses");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: GameStatus_Params) {
        if (params.remainingGuesses === undefined) {
            this.__remainingGuesses.set(GameConstants.MAX_GUESSES);
        }
        if (params.totalGuesses === undefined) {
            this.__totalGuesses.set(GameConstants.MAX_GUESSES);
        }
    }
    updateStateVars(params: GameStatus_Params) {
        this.__remainingGuesses.reset(params.remainingGuesses);
        this.__totalGuesses.reset(params.totalGuesses);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__remainingGuesses.purgeDependencyOnElmtId(rmElmtId);
        this.__totalGuesses.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__remainingGuesses.aboutToBeDeleted();
        this.__totalGuesses.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __remainingGuesses: SynchedPropertySimpleOneWayPU<number>;
    get remainingGuesses() {
        return this.__remainingGuesses.get();
    }
    set remainingGuesses(newValue: number) {
        this.__remainingGuesses.set(newValue);
    }
    private __totalGuesses: SynchedPropertySimpleOneWayPU<number>;
    get totalGuesses() {
        return this.__totalGuesses.get();
    }
    set totalGuesses(newValue: number) {
        this.__totalGuesses.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/components/game/GameStatus.ets(9:5)", "entry");
            Column.width('100%');
            Column.padding({ top: 16, bottom: 16 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/components/game/GameStatus.ets(10:7)", "entry");
            Row.width('100%');
            Row.justifyContent(FlexAlign.Center);
            Row.margin({ bottom: 8 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('剩余次数');
            Text.debugLine("entry/src/main/ets/components/game/GameStatus.ets(11:9)", "entry");
            Text.fontSize(14);
            Text.fontColor('#666666');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.remainingGuesses}/${this.totalGuesses}`);
            Text.debugLine("entry/src/main/ets/components/game/GameStatus.ets(15:9)", "entry");
            Text.fontSize(20);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#3B82F6');
            Text.margin({ left: 8 });
        }, Text);
        Text.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 进度条
            Row.create();
            Row.debugLine("entry/src/main/ets/components/game/GameStatus.ets(26:7)", "entry");
            // 进度条
            Row.width('80%');
            // 进度条
            Row.height(8);
            // 进度条
            Row.backgroundColor('#E5E7EB');
            // 进度条
            Row.borderRadius(4);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/components/game/GameStatus.ets(27:9)", "entry");
            Row.width(`${(this.remainingGuesses / this.totalGuesses) * 100}%`);
            Row.height('100%');
            Row.backgroundColor('#3B82F6');
            Row.borderRadius(4);
        }, Row);
        Row.pop();
        // 进度条
        Row.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
