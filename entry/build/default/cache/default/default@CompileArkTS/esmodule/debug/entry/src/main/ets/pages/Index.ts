if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
}
import router from "@ohos:router";
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.backgroundColor('#F5F5F5');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.layoutWeight(1);
            Column.justifyContent(FlexAlign.Center);
            Column.alignItems(HorizontalAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // Logo
            Text.create('猜诗词游戏');
            // Logo
            Text.fontSize(32);
            // Logo
            Text.fontWeight(FontWeight.Bold);
            // Logo
            Text.fontColor('#3B82F6');
            // Logo
            Text.margin({ bottom: 16 });
        }, Text);
        // Logo
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('基于Wordle机制的中文诗词猜谜游戏');
            Text.fontSize(16);
            Text.fontColor('#666666');
            Text.margin({ bottom: 48 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 开始游戏按钮
            Button.createWithLabel('开始游戏');
            // 开始游戏按钮
            Button.width('80%');
            // 开始游戏按钮
            Button.height(56);
            // 开始游戏按钮
            Button.fontSize(18);
            // 开始游戏按钮
            Button.fontWeight(FontWeight.Bold);
            // 开始游戏按钮
            Button.fontColor('#FFFFFF');
            // 开始游戏按钮
            Button.backgroundColor('#3B82F6');
            // 开始游戏按钮
            Button.borderRadius(12);
            // 开始游戏按钮
            Button.onClick(() => {
                router.pushUrl({
                    url: 'pages/GamePage'
                });
            });
        }, Button);
        // 开始游戏按钮
        Button.pop();
        Column.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.example.guesspoetrygame", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
