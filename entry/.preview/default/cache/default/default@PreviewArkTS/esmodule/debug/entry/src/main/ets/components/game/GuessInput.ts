if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface GuessInput_Params {
    text?: string;
    disabled?: boolean;
    onSubmit?: () => void;
}
export class GuessInput extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__text = new SynchedPropertySimpleTwoWayPU(params.text, this, "text");
        this.__disabled = new SynchedPropertySimpleOneWayPU(params.disabled, this, "disabled");
        this.onSubmit = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: GuessInput_Params) {
        if (params.disabled === undefined) {
            this.__disabled.set(false);
        }
        if (params.onSubmit !== undefined) {
            this.onSubmit = params.onSubmit;
        }
    }
    updateStateVars(params: GuessInput_Params) {
        this.__disabled.reset(params.disabled);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__text.purgeDependencyOnElmtId(rmElmtId);
        this.__disabled.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__text.aboutToBeDeleted();
        this.__disabled.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __text: SynchedPropertySimpleTwoWayPU<string>;
    get text() {
        return this.__text.get();
    }
    set text(newValue: string) {
        this.__text.set(newValue);
    }
    private __disabled: SynchedPropertySimpleOneWayPU<boolean>;
    get disabled() {
        return this.__disabled.get();
    }
    set disabled(newValue: boolean) {
        this.__disabled.set(newValue);
    }
    private onSubmit?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.debugLine("entry/src/main/ets/components/game/GuessInput.ets(8:5)", "entry");
            Row.width('100%');
            Row.justifyContent(FlexAlign.SpaceBetween);
            Row.padding({ left: 16, right: 16 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ placeholder: '请输入诗句', text: this.text });
            TextInput.debugLine("entry/src/main/ets/components/game/GuessInput.ets(9:7)", "entry");
            TextInput.width('70%');
            TextInput.height(48);
            TextInput.fontSize(16);
            TextInput.fontColor('#333333');
            TextInput.placeholderColor('#999999');
            TextInput.backgroundColor('#F5F5F5');
            TextInput.borderRadius(8);
            TextInput.padding({ left: 16, right: 16 });
            TextInput.enabled(!this.disabled);
            TextInput.onChange((value: string) => {
                this.text = value;
            });
            TextInput.onSubmit(() => {
                if (this.onSubmit) {
                    this.onSubmit();
                }
            });
        }, TextInput);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('猜测');
            Button.debugLine("entry/src/main/ets/components/game/GuessInput.ets(28:7)", "entry");
            Button.width('25%');
            Button.height(48);
            Button.fontSize(16);
            Button.fontColor('#FFFFFF');
            Button.backgroundColor('#3B82F6');
            Button.borderRadius(8);
            Button.enabled(!this.disabled && this.text.length > 0);
            Button.onClick(() => {
                if (this.onSubmit) {
                    this.onSubmit();
                }
            });
        }, Button);
        Button.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
