if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface HintDisplay_Params {
    hint?: HintInfo | null;
}
import type { HintInfo } from '../../types/states';
export class HintDisplay extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__hint = new SynchedPropertyObjectOneWayPU(params.hint, this, "hint");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: HintDisplay_Params) {
        if (params.hint === undefined) {
            this.__hint.set(null);
        }
    }
    updateStateVars(params: HintDisplay_Params) {
        this.__hint.reset(params.hint);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__hint.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__hint.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __hint: SynchedPropertySimpleOneWayPU<HintInfo | null>;
    get hint() {
        return this.__hint.get();
    }
    set hint(newValue: HintInfo | null) {
        this.__hint.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.hint) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/components/game/HintDisplay.ets(9:7)", "entry");
                        Column.width('100%');
                        Column.padding({ left: 16, right: 16, top: 12, bottom: 12 });
                        Column.backgroundColor('#F5F5F5');
                        Column.borderRadius(8);
                        Column.margin({ left: 16, right: 16 });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 显示答案格式提示
                        Row.create();
                        Row.debugLine("entry/src/main/ets/components/game/HintDisplay.ets(11:9)", "entry");
                        // 显示答案格式提示
                        Row.width('100%');
                        // 显示答案格式提示
                        Row.justifyContent(FlexAlign.Center);
                        // 显示答案格式提示
                        Row.padding({ top: 8, bottom: 8 });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('答案格式: ');
                        Text.debugLine("entry/src/main/ets/components/game/HintDisplay.ets(12:11)", "entry");
                        Text.fontSize(14);
                        Text.fontColor('#666666');
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        If.create();
                        if (this.hint.currentVerseCharCount > 0) {
                            this.ifElseBranchUpdateFunction(0, () => {
                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                    // 计算每句字数（总字数除以2）
                                    Text.create(`${Math.floor(this.hint.currentVerseCharCount / 2)}×2`);
                                    Text.debugLine("entry/src/main/ets/components/game/HintDisplay.ets(18:13)", "entry");
                                    // 计算每句字数（总字数除以2）
                                    Text.fontSize(16);
                                    // 计算每句字数（总字数除以2）
                                    Text.fontWeight(FontWeight.Bold);
                                    // 计算每句字数（总字数除以2）
                                    Text.fontColor('#3B82F6');
                                }, Text);
                                // 计算每句字数（总字数除以2）
                                Text.pop();
                            });
                        }
                        else {
                            this.ifElseBranchUpdateFunction(1, () => {
                            });
                        }
                    }, If);
                    If.pop();
                    // 显示答案格式提示
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 提示说明
                        Text.create('请输入完整的上下句，中间用逗号分隔');
                        Text.debugLine("entry/src/main/ets/components/game/HintDisplay.ets(29:9)", "entry");
                        // 提示说明
                        Text.fontSize(12);
                        // 提示说明
                        Text.fontColor('#999999');
                        // 提示说明
                        Text.margin({ top: 4 });
                    }, Text);
                    // 提示说明
                    Text.pop();
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
