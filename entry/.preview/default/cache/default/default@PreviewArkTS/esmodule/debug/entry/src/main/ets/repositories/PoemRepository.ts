import type { Poem } from '../types/models';
import { BaseRepository } from "@bundle:com.example.guesspoetrygame/entry/ets/repositories/BaseRepository";
import { StringUtils } from "@bundle:com.example.guesspoetrygame/entry/ets/utils/StringUtils";
/**
 * 诗词仓储类
 */
export class PoemRepository extends BaseRepository<Poem> {
    // 预加载的合法诗句数组（过滤标点后）
    private validVersesList: string[] = [];
    constructor(context: Context) {
        super(context, 'poetry_game_prefs', 'poems', 'poems.json');
    }
    /**
     * 初始化数据（重写父类方法，添加预加载）
     */
    async init(): Promise<void> {
        try {
            console.info(`[PoemRepository] 开始初始化: ${this.rawFileName}`);
            // 调用父类初始化
            await super.init();
            // 预加载所有合法诗句
            await this.buildValidVersesList();
            console.info(`[PoemRepository] 初始化完成，预加载 ${this.validVersesList.length} 个合法诗句`);
        }
        catch (error) {
            console.error(`[PoemRepository] 初始化失败: ${error}`);
            if (error instanceof Error) {
                throw error;
            }
            else {
                throw new Error(`初始化失败: ${error}`);
            }
        }
    }
    /**
     * 构建合法诗句数组（预加载）
     */
    private async buildValidVersesList(): Promise<void> {
        console.info(`[PoemRepository] 开始构建合法诗句集合`);
        console.info(`[PoemRepository] 当前诗词数量: ${this.items.length}`);
        const tempList: string[] = [];
        // 使用普通for循环
        for (let p = 0; p < this.items.length; p++) {
            const poem = this.items[p];
            console.info(`[PoemRepository] 处理诗词[${p}]: ${poem.id}`);
            // 检查verses和punctuations
            if (poem.verses === undefined || poem.verses === null) {
                console.warn(`[PoemRepository] 诗词 ${poem.id} 缺少verses`);
                continue;
            }
            if (poem.punctuations === undefined || poem.punctuations === null) {
                console.warn(`[PoemRepository] 诗词 ${poem.id} 缺少punctuations`);
                continue;
            }
            const verses = poem.verses;
            const punctuations = poem.punctuations;
            console.info(`[PoemRepository] 诗词 ${poem.id} 有 ${verses.length} 个诗句`);
            // 添加相邻两句的组合（逗号分隔）
            for (let i = 0; i < verses.length - 1; i++) {
                const punct = punctuations[i];
                if (punct === '，') {
                    const verse1 = verses[i];
                    const verse2 = verses[i + 1];
                    const combined = verse1 + verse2;
                    console.info(`[PoemRepository] 组合: ${combined}`);
                    // 调用StringUtils
                    const filtered = StringUtils.filterPunctuation(combined);
                    tempList.push(filtered);
                }
            }
        }
        this.validVersesList = tempList;
        console.info(`[PoemRepository] 构建完成，共 ${this.validVersesList.length} 个诗句组合`);
    }
    /**
     * 检查诗句组合是否合法
     * @param content 完整诗句（包含上下句）
     * @returns 是否合法
     */
    async isValidVerseCombination(content: string): Promise<boolean> {
        // 过滤标点
        const filtered = StringUtils.filterPunctuation(content);
        console.info(`[PoemRepository] 验证诗句: ${content}`);
        console.info(`[PoemRepository] 过滤后: ${filtered} (${filtered.length}字)`);
        console.info(`[PoemRepository] 合法诗句库大小: ${this.validVersesList.length}`);
        // 在预加载的数组中查找
        for (let i = 0; i < this.validVersesList.length; i++) {
            if (this.validVersesList[i] === filtered) {
                console.info(`[PoemRepository] ✅ 验证通过`);
                return true;
            }
        }
        console.warn(`[PoemRepository] ❌ 验证失败: 不在合法诗句库中`);
        return false;
    }
    /**
     * 获取所有合法的诗句组合（用于验证题库）
     * @returns 合法的诗句组合数组
     */
    async getAllValidCombinations(): Promise<string[]> {
        const combinations: string[] = [];
        for (const poem of this.items) {
            const verses = poem.verses;
            const punctuations = poem.punctuations;
            if (!verses || !punctuations) {
                continue;
            }
            // 检查相邻两句的组合
            for (let i = 0; i < verses.length - 1; i++) {
                // 只有当标点是逗号时才合法
                if (punctuations[i] === '，') {
                    const combined = verses[i] + '，' + verses[i + 1];
                    combinations.push(combined);
                }
            }
            // 添加specialCouplets
            if (poem.specialCouplets && poem.specialCouplets.length > 0) {
                for (const couplet of poem.specialCouplets) {
                    combinations.push(couplet);
                }
            }
        }
        return combinations;
    }
    /**
     * 根据诗句查找诗词
     * @param verse 诗句
     * @returns 包含该诗句的诗词
     */
    async findByVerse(verse: string): Promise<Poem | null> {
        const filteredVerse = StringUtils.filterPunctuation(verse);
        const poem = this.items.find((p: Poem) => {
            return p.verses.some((v: string) => {
                return StringUtils.filterPunctuation(v) === filteredVerse;
            });
        });
        return poem || null;
    }
}
