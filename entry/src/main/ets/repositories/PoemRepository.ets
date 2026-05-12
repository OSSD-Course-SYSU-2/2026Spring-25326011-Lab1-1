import { Poem } from '../types/models';
import { Result } from '../types/results';
import { BaseRepository } from './BaseRepository';
import { StringUtils } from '../utils/StringUtils';

/**
 * 诗词仓储类
 */
export class PoemRepository extends BaseRepository<Poem> {
  constructor(context: Context) {
    super(context, 'poetry_game_prefs', 'poems', 'poems.json');
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

  /**
   * 检查诗句是否在诗词库中
   * @param verse 诗句
   * @returns 是否存在
   */
  async containsVerse(verse: string): Promise<boolean> {
    const poem = await this.findByVerse(verse);
    return poem !== null;
  }

  /**
   * 搜索诗词
   * @param keyword 关键词
   * @returns 匹配的诗词列表
   */
  async search(keyword: string): Promise<Poem[]> {
    const lowerKeyword = keyword.toLowerCase();
    return this.items.filter((p: Poem) => {
      return p.title.toLowerCase().includes(lowerKeyword) ||
        p.author.toLowerCase().includes(lowerKeyword) ||
        p.verses.some((v: string) => v.toLowerCase().includes(lowerKeyword));
    });
  }
}
