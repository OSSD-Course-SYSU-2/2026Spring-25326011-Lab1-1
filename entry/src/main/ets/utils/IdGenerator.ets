/**
 * ID生成工具类
 */
export class IdGenerator {
  /**
   * 生成唯一ID
   * @returns 唯一ID字符串
   */
  static generate(): string {
    const timestamp = Date.now();
    const random = Math.random().toString(36).substr(2, 9);
    return `${timestamp}_${random}`;
  }

  /**
   * 生成带前缀的唯一ID
   * @param prefix 前缀
   * @returns 带前缀的唯一ID字符串
   */
  static generateWithPrefix(prefix: string): string {
    return `${prefix}_${IdGenerator.generate()}`;
  }
}
