if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface FeedbackChar_Params {
    char?: string;
    status?: FeedbackStatus;
}
import { FeedbackStatus } from "@bundle:com.example.guesspoetrygame/entry/ets/types/models";
import { Colors } from "@bundle:com.example.guesspoetrygame/entry/ets/constants/Colors";
export class FeedbackChar extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__char = new SynchedPropertySimpleOneWayPU(params.char, this, "char");
        this.__status = new SynchedPropertySimpleOneWayPU(params.status, this, "status");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: FeedbackChar_Params) {
        if (params.char === undefined) {
            this.__char.set('');
        }
        if (params.status === undefined) {
            this.__status.set(FeedbackStatus.ABSENT);
        }
    }
    updateStateVars(params: FeedbackChar_Params) {
        this.__char.reset(params.char);
        this.__status.reset(params.status);
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__char.purgeDependencyOnElmtId(rmElmtId);
        this.__status.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__char.aboutToBeDeleted();
        this.__status.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __char: SynchedPropertySimpleOneWayPU<string>;
    get char() {
        return this.__char.get();
    }
    set char(newValue: string) {
        this.__char.set(newValue);
    }
    private __status: SynchedPropertySimpleOneWayPU<FeedbackStatus>;
    get status() {
        return this.__status.get();
    }
    set status(newValue: FeedbackStatus) {
        this.__status.set(newValue);
    }
    private getBackgroundColor(): string {
        switch (this.status) {
            case FeedbackStatus.CORRECT:
                return Colors.COLOR_CORRECT;
            case FeedbackStatus.MISPLACED:
                return Colors.COLOR_MISPLACED;
            case FeedbackStatus.ABSENT:
            default:
                return Colors.COLOR_ABSENT;
        }
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.char);
            Text.width(32);
            Text.height(32);
            Text.fontSize(16);
            Text.fontWeight(FontWeight.Bold);
            Text.fontColor('#FFFFFF');
            Text.backgroundColor(this.getBackgroundColor());
            Text.borderRadius(4);
            Text.textAlign(TextAlign.Center);
            Text.margin({ right: 3 });
        }, Text);
        Text.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
