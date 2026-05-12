import { Category } from '../types/models';
import { Result } from '../types/results';
import { BaseRepository } from './BaseRepository';

/**
 * 分类仓储类
 */
export class CategoryRepository extends BaseRepository<Category> {
  constructor(context: Context) {
    super(context, 'poetry_game_prefs', 'categories', 'categories.json');
  }

  /**
   * 根据名称获取分类
   * @param name 分类名称
   * @returns 分类
   */
  async getByName(name: string): Promise<Category | null> {
    const category = this.items.find((c: Category) => c.name === name);
    return category || null;
  }

  /**
   * 检查分类名称是否存在
   * @param name 分类名称
   * @returns 是否存在
   */
  async existsByName(name: string): Promise<boolean> {
    const category = await this.getByName(name);
    return category !== null;
  }
}
