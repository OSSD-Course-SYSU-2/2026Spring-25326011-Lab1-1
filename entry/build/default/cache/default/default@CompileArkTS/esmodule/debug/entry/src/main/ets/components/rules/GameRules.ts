if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface GameRules_Params {
    visible?: boolean;
    onClose?: () => void;
}
import { Colors } from "@bundle:com.example.guesspoetrygame/entry/ets/constants/Colors";
export class GameRules extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__visible = new SynchedPropertySimpleOneWayPU(params.visible, this, "visible");
        this.onClose = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: GameRules_Params) {
        if (params.visible === undefined) {
            this.__visible.set(false);
        }
        if (params.onClose !== undefined) {
            this.onClose = params.onClose;
        }
    }
    updateStateVars(params: GameRules_Params) {
        this.__visible.reset(params.visible);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__visible.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__visible.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __visible: SynchedPropertySimpleOneWayPU<boolean>;
    get visible() {
        return this.__visible.get();
    }
    set visible(newValue: boolean) {
        this.__visible.set(newValue);
    }
    private onClose?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.visible) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.width('100%');
                        Column.height('100%');
                        Column.backgroundColor('#80000000');
                        Column.justifyContent(FlexAlign.Center);
                        Column.alignItems(HorizontalAlign.Center);
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.width('90%');
                        Column.height('80%');
                        Column.padding(24);
                        Column.backgroundColor('#FFFFFF');
                        Column.borderRadius(12);
                        Column.shadow({
                            radius: 8,
                            color: '#1A000000',
                            offsetY: 4
                        });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 标题
                        Row.create();
                        // 标题
                        Row.width('100%');
                        // 标题
                        Row.margin({ bottom: 24 });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('游戏规则');
                        Text.fontSize(20);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#333333');
                        Text.layoutWeight(1);
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Button.createWithChild({ type: ButtonType.Circle });
                        Button.width(32);
                        Button.height(32);
                        Button.backgroundColor('#F5F5F5');
                        Button.onClick(() => {
                            if (this.onClose) {
                                this.onClose();
                            }
                        });
                    }, Button);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('×');
                        Text.fontSize(24);
                        Text.fontColor('#666666');
                    }, Text);
                    Text.pop();
                    Button.pop();
                    // 标题
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 规则内容
                        Column.create();
                        // 规则内容
                        Column.width('100%');
                        // 规则内容
                        Column.layoutWeight(1);
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 规则1
                        Row.create();
                        // 规则1
                        Row.width('100%');
                        // 规则1
                        Row.margin({ bottom: 16 });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('1.');
                        Text.fontSize(16);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#333333');
                        Text.margin({ right: 8 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('系统从题库中随机挑选一句诗，并提示上下句字数');
                        Text.fontSize(16);
                        Text.fontColor('#666666');
                        Text.layoutWeight(1);
                    }, Text);
                    Text.pop();
                    // 规则1
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 规则2
                        Row.create();
                        // 规则2
                        Row.width('100%');
                        // 规则2
                        Row.margin({ bottom: 16 });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('2.');
                        Text.fontSize(16);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#333333');
                        Text.margin({ right: 8 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('输入猜测的诗句并点击"猜测"（无需输入标点）');
                        Text.fontSize(16);
                        Text.fontColor('#666666');
                        Text.layoutWeight(1);
                    }, Text);
                    Text.pop();
                    // 规则2
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 规则3
                        Row.create();
                        // 规则3
                        Row.width('100%');
                        // 规则3
                        Row.margin({ bottom: 16 });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('3.');
                        Text.fontSize(16);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#333333');
                        Text.margin({ right: 8 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('若诗句与答案完全匹配，则游戏成功');
                        Text.fontSize(16);
                        Text.fontColor('#666666');
                        Text.layoutWeight(1);
                    }, Text);
                    Text.pop();
                    // 规则3
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 规则4
                        Column.create();
                        // 规则4
                        Column.width('100%');
                        // 规则4
                        Column.margin({ bottom: 16 });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.width('100%');
                        Row.margin({ bottom: 12 });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('4.');
                        Text.fontSize(16);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#333333');
                        Text.margin({ right: 8 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('否则，系统会用颜色标记反馈：');
                        Text.fontSize(16);
                        Text.fontColor('#666666');
                        Text.layoutWeight(1);
                    }, Text);
                    Text.pop();
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 颜色图例
                        Column.create();
                        // 颜色图例
                        Column.width('100%');
                        // 颜色图例
                        Column.padding({ left: 24 });
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.width('100%');
                        Row.margin({ bottom: 8 });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create();
                        Text.width(32);
                        Text.height(32);
                        Text.backgroundColor(Colors.COLOR_CORRECT);
                        Text.borderRadius(4);
                        Text.margin({ right: 12 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('绿色：答案中含有且位置正确的字');
                        Text.fontSize(14);
                        Text.fontColor('#666666');
                        Text.layoutWeight(1);
                    }, Text);
                    Text.pop();
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.width('100%');
                        Row.margin({ bottom: 8 });
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create();
                        Text.width(32);
                        Text.height(32);
                        Text.backgroundColor(Colors.COLOR_MISPLACED);
                        Text.borderRadius(4);
                        Text.margin({ right: 12 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('黄色：答案中含有但位置不正确的字');
                        Text.fontSize(14);
                        Text.fontColor('#666666');
                        Text.layoutWeight(1);
                    }, Text);
                    Text.pop();
                    Row.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Row.create();
                        Row.width('100%');
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create();
                        Text.width(32);
                        Text.height(32);
                        Text.backgroundColor(Colors.COLOR_ABSENT);
                        Text.borderRadius(4);
                        Text.margin({ right: 12 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('灰色：答案中不存在的字');
                        Text.fontSize(14);
                        Text.fontColor('#666666');
                        Text.layoutWeight(1);
                    }, Text);
                    Text.pop();
                    Row.pop();
                    // 颜色图例
                    Column.pop();
                    // 规则4
                    Column.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        // 规则5
                        Row.create();
                        // 规则5
                        Row.width('100%');
                    }, Row);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('5.');
                        Text.fontSize(16);
                        Text.fontWeight(FontWeight.Bold);
                        Text.fontColor('#333333');
                        Text.margin({ right: 8 });
                    }, Text);
                    Text.pop();
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('每轮有20次猜测机会');
                        Text.fontSize(16);
                        Text.fontColor('#666666');
                        Text.layoutWeight(1);
                    }, Text);
                    Text.pop();
                    // 规则5
                    Row.pop();
                    // 规则内容
                    Column.pop();
                    Column.pop();
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
