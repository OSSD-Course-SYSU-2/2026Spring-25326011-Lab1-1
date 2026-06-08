/**
 * 字符串工具类
 */
export class StringUtils {
    /**
     * 中文标点正则表达式
     */
    private static readonly PUNCTUATION_REGEX: RegExp = /[，。、；：？！""''《》【】（）—…·\s]/g;
    /**
     * 过滤中文标点符号
     * @param text 输入文本
     * @returns 过滤后的文本
     */
    static filterPunctuation(text: string): string {
        return text.replace(StringUtils.PUNCTUATION_REGEX, '');
    }
    /**
     * 计算字符数（不含标点）
     * @param text 输入文本
     * @returns 字符数
     */
    static countChars(text: string): number {
        const filtered = StringUtils.filterPunctuation(text);
        return filtered.length;
    }
    /**
     * 字符串转字符数组（过滤标点）
     * @param text 输入文本
     * @returns 字符数组
     */
    static toCharArray(text: string): string[] {
        const filtered = StringUtils.filterPunctuation(text);
        return filtered.split('');
    }
    /**
     * 判断是否为空字符串
     * @param text 输入文本
     * @returns 是否为空
     */
    static isEmpty(text: string): boolean {
        return !text || text.trim().length === 0;
    }
    /**
     * 判断是否为空白字符串
     * @param text 输入文本
     * @returns 是否为空白
     */
    static isBlank(text: string): boolean {
        return !text || text.trim().length === 0;
    }
    /**
     * 去除首尾空白
     * @param text 输入文本
     * @returns 去除空白后的文本
     */
    static trim(text: string): string {
        return text ? text.trim() : '';
    }
}
