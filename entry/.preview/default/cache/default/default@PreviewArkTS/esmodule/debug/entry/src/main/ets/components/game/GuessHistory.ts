if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface GuessHistory_Params {
    history?: GuessRecord[];
}
import type { GuessRecord, FeedbackItem } from '../../types/models';
import { FeedbackChar } from "@bundle:com.example.guesspoetrygame/entry/ets/components/game/FeedbackChar";
export class GuessHistory extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__history = new SynchedPropertyObjectOneWayPU(params.history, this, "history");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: GuessHistory_Params) {
        if (params.history === undefined) {
            this.__history.set([]);
        }
    }
    updateStateVars(params: GuessHistory_Params) {
        this.__history.reset(params.history);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__history.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__history.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __history: SynchedPropertySimpleOneWayPU<GuessRecord[]>;
    get history() {
        return this.__history.get();
    }
    set history(newValue: GuessRecord[]) {
        this.__history.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.debugLine("entry/src/main/ets/components/game/GuessHistory.ets(9:5)", "entry");
            Column.width('100%');
            Column.layoutWeight(1);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.history.length === 0) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/components/game/GuessHistory.ets(11:9)", "entry");
                        Column.width('100%');
                        Column.height('100%');
                        Column.justifyContent(FlexAlign.Center);
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('暂无猜测记录');
                        Text.debugLine("entry/src/main/ets/components/game/GuessHistory.ets(12:11)", "entry");
                        Text.fontSize(16);
                        Text.fontColor('#999999');
                        Text.margin({ top: 40 });
                    }, Text);
                    Text.pop();
                    Column.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        List.create({ space: 6 });
                        List.debugLine("entry/src/main/ets/components/game/GuessHistory.ets(21:9)", "entry");
                        List.width('100%');
                        List.layoutWeight(1);
                        List.padding({ top: 8, bottom: 8 });
                    }, List);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        ForEach.create();
                        const forEachItemGenFunction = (_item, index: number) => {
                            const record = _item;
                            {
                                const itemCreation = (elmtId, isInitialRender) => {
                                    ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                                    ListItem.create(deepRenderFunction, true);
                                    if (!isInitialRender) {
                                        ListItem.pop();
                                    }
                                    ViewStackProcessor.StopGetAccessRecording();
                                };
                                const itemCreation2 = (elmtId, isInitialRender) => {
                                    ListItem.create(deepRenderFunction, true);
                                    ListItem.debugLine("entry/src/main/ets/components/game/GuessHistory.ets(23:13)", "entry");
                                };
                                const deepRenderFunction = (elmtId, isInitialRender) => {
                                    itemCreation(elmtId, isInitialRender);
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        Scroll.create();
                                        Scroll.debugLine("entry/src/main/ets/components/game/GuessHistory.ets(24:15)", "entry");
                                        Scroll.width('100%');
                                        Scroll.scrollable(ScrollDirection.Horizontal);
                                        Scroll.scrollBar(BarState.Off);
                                    }, Scroll);
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        Row.create();
                                        Row.debugLine("entry/src/main/ets/components/game/GuessHistory.ets(25:17)", "entry");
                                        Row.justifyContent(FlexAlign.Center);
                                        Row.padding({ left: 4, right: 4 });
                                    }, Row);
                                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                                        ForEach.create();
                                        const forEachItemGenFunction = (_item, i: number) => {
                                            const item = _item;
                                            {
                                                this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                    if (isInitialRender) {
                                                        let componentCall = new FeedbackChar(this, {
                                                            char: item.char,
                                                            status: item.status
                                                        }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/components/game/GuessHistory.ets", line: 27, col: 21 });
                                                        ViewPU.create(componentCall);
                                                        let paramsLambda = () => {
                                                            return {
                                                                char: item.char,
                                                                status: item.status
                                                            };
                                                        };
                                                        componentCall.paramsGenerator_ = paramsLambda;
                                                    }
                                                    else {
                                                        this.updateStateVarsOfChildByElmtId(elmtId, {
                                                            char: item.char,
                                                            status: item.status
                                                        });
                                                    }
                                                }, { name: "FeedbackChar" });
                                            }
                                        };
                                        this.forEachUpdateFunction(elmtId, record.feedback, forEachItemGenFunction, (item: FeedbackItem, i: number) => i.toString(), true, true);
                                    }, ForEach);
                                    ForEach.pop();
                                    Row.pop();
                                    Scroll.pop();
                                    ListItem.pop();
                                };
                                this.observeComponentCreation2(itemCreation2, ListItem);
                                ListItem.pop();
                            }
                        };
                        this.forEachUpdateFunction(elmtId, this.history, forEachItemGenFunction, (record: GuessRecord, index: number) => index.toString(), true, true);
                    }, ForEach);
                    ForEach.pop();
                    List.pop();
                });
            }
        }, If);
        If.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
