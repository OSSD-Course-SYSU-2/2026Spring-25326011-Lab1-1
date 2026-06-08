if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface AppTitleBar_Params {
    title?: string;
    showBack?: boolean;
    onBackClick?: () => void;
    onRightClick?: () => void;
    rightIcon?: string;
}
export class AppTitleBar extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__title = new SynchedPropertySimpleOneWayPU(params.title, this, "title");
        this.__showBack = new SynchedPropertySimpleOneWayPU(params.showBack, this, "showBack");
        this.onBackClick = undefined;
        this.onRightClick = undefined;
        this.__rightIcon = new SynchedPropertySimpleOneWayPU(params.rightIcon, this, "rightIcon");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: AppTitleBar_Params) {
        if (params.title === undefined) {
            this.__title.set('猜诗词游戏');
        }
        if (params.showBack === undefined) {
            this.__showBack.set(false);
        }
        if (params.onBackClick !== undefined) {
            this.onBackClick = params.onBackClick;
        }
        if (params.onRightClick !== undefined) {
            this.onRightClick = params.onRightClick;
        }
        if (params.rightIcon === undefined) {
            this.__rightIcon.set('');
        }
    }
    updateStateVars(params: AppTitleBar_Params) {
        this.__title.reset(params.title);
        this.__showBack.reset(params.showBack);
        this.__rightIcon.reset(params.rightIcon);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__title.purgeDependencyOnElmtId(rmElmtId);
        this.__showBack.purgeDependencyOnElmtId(rmElmtId);
        this.__rightIcon.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__title.aboutToBeDeleted();
        this.__showBack.aboutToBeDeleted();
        this.__rightIcon.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __title: SynchedPropertySimpleOneWayPU<string>;
    get title() {
        return this.__title.get();
    }
    set title(newValue: string) {
        this.__title.set(newValue);
    }
    private __showBack: SynchedPropertySimpleOneWayPU<boolean>;
    get showBack() {
        return this.__showBack.get();
    }
    set showBack(newValue: boolean) {
        this.__showBack.set(newValue);
    }
    private onBackClick?: () => void;
    private onRightClick?: () => void;
    private __rightIcon: SynchedPropertySimpleOneWayPU<string>;
    get rightIcon() {
        return this.__rightIcon.get();
    }
    set rightIcon(newValue: string) {
        this.__rightIcon.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.width('100%');
            Row.height(56);
            Row.padding({ left: 16, right: 16 });
            Row.backgroundColor('#FFFFFF');
            Row.shadow({
                radius: 2,
                color: '#1A000000',
                offsetY: 2
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 返回按钮
            if (this.showBack) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Button.createWithChild({ type: ButtonType.Circle });
                        Button.width(40);
                        Button.height(40);
                        Button.backgroundColor('#F5F5F5');
                        Button.onClick(() => {
                            if (this.onBackClick) {
                                this.onBackClick();
                            }
                        });
                        Button.margin({ right: 12 });
                    }, Button);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create({ "id": 125830087, "type": 20000, params: [], "bundleName": "com.example.guesspoetrygame", "moduleName": "entry" });
                        Image.width(24);
                        Image.height(24);
                        Image.fillColor('#333333');
                    }, Image);
                    Button.pop();
                });
            }
            // 标题
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 标题
            Text.create(this.title);
            // 标题
            Text.fontSize(20);
            // 标题
            Text.fontWeight(FontWeight.Bold);
            // 标题
            Text.fontColor('#333333');
            // 标题
            Text.layoutWeight(1);
        }, Text);
        // 标题
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 右侧按钮
            if (this.rightIcon) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Button.createWithChild({ type: ButtonType.Circle });
                        Button.width(40);
                        Button.height(40);
                        Button.backgroundColor('#F5F5F5');
                        Button.onClick(() => {
                            if (this.onRightClick) {
                                this.onRightClick();
                            }
                        });
                    }, Button);
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create({ "id": -1, "type": -1, params: [this.rightIcon], "bundleName": "com.example.guesspoetrygame", "moduleName": "entry" });
                        Image.width(24);
                        Image.height(24);
                        Image.fillColor('#333333');
                    }, Image);
                    Button.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                });
            }
        }, If);
        If.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
