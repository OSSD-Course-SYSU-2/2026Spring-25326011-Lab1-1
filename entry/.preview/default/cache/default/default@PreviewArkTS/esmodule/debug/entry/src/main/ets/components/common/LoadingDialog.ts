if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface LoadingDialog_Params {
    visible?: boolean;
    message?: string;
}
export class LoadingDialog extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__visible = new SynchedPropertySimpleOneWayPU(params.visible, this, "visible");
        this.__message = new SynchedPropertySimpleOneWayPU(params.message, this, "message");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: LoadingDialog_Params) {
        if (params.visible === undefined) {
            this.__visible.set(false);
        }
        if (params.message === undefined) {
            this.__message.set('加载中...');
        }
    }
    updateStateVars(params: LoadingDialog_Params) {
        this.__visible.reset(params.visible);
        this.__message.reset(params.message);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__visible.purgeDependencyOnElmtId(rmElmtId);
        this.__message.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__visible.aboutToBeDeleted();
        this.__message.aboutToBeDeleted();
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
    private __message: SynchedPropertySimpleOneWayPU<string>;
    get message() {
        return this.__message.get();
    }
    set message(newValue: string) {
        this.__message.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (this.visible) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/components/common/LoadingDialog.ets(8:7)", "entry");
                        Column.width('100%');
                        Column.height('100%');
                        Column.backgroundColor('#80000000');
                        Column.justifyContent(FlexAlign.Center);
                        Column.alignItems(HorizontalAlign.Center);
                    }, Column);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Column.create();
                        Column.debugLine("entry/src/main/ets/components/common/LoadingDialog.ets(9:9)", "entry");
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
                        LoadingProgress.create();
                        LoadingProgress.debugLine("entry/src/main/ets/components/common/LoadingDialog.ets(10:11)", "entry");
                        LoadingProgress.width(48);
                        LoadingProgress.height(48);
                        LoadingProgress.color('#3B82F6');
                    }, LoadingProgress);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create(this.message);
                        Text.debugLine("entry/src/main/ets/components/common/LoadingDialog.ets(15:11)", "entry");
                        Text.fontSize(14);
                        Text.fontColor('#666666');
                        Text.margin({ top: 16 });
                    }, Text);
                    Text.pop();
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
