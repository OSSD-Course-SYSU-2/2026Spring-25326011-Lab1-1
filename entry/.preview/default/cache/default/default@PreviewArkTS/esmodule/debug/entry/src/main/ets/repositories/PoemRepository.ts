import type { Poem } from '../types/models';
import { BaseRepository } from "@bundle:com.example.guesspoetrygame/entry/ets/repositories/BaseRepository";
import { StringUtils } from "@bundle:com.example.guesspoetrygame/entry/ets/utils/StringUtils";
/**
 * 诗词仓储类
 */
export class PoemRepository extends BaseRepository<Poem> {
    constructor(context: Context) {
        super(context, 'poetry_game_prefs', 'poems', 'poems.json');
    }
    /**
     * 检查诗句组合是否合法（相邻两句且中间是逗号）
     * @param content 完整诗句（包含上下句）
     * @returns 是否合法
     */
    async isValidVerseCombination(content: string): Promise<boolean> {
        // 过滤标点后检查
        const filtered = StringUtils.filterPunctuation(content);
        // 遍历所有诗词
        for (const poem of this.items) {
            const verses = poem.verses;
            const punctuations = poem.punctuations;
            // 检查相邻两句的组合
            for (let i = 0; i < verses.length - 1; i++) {
                // 只有当标点是逗号时才合法
                if (punctuations && punctuations[i] === '，') {
                    const combined = verses[i] + verses[i + 1];
                    if (StringUtils.filterPunctuation(combined) === filtered) {
                        return true;
                    }
                }
            }
            // 检查specialCouplets
            if (poem.specialCouplets && poem.specialCouplets.length > 0) {
                for (const couplet of poem.specialCouplets) {
                    if (StringUtils.filterPunctuation(couplet) === filtered) {
                        return true;
                    }
                }
            }
        }
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
            // 检查相邻两句的组合
            for (let i = 0; i < verses.length - 1; i++) {
                // 只有当标点是逗号时才合法
                if (punctuations && punctuations[i] === '，') {
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
