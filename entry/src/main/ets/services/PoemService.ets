import { Poem } from '../types/models';
import { Result } from '../types/results';
import { PoemRepository } from '../repositories/PoemRepository';

/**
 * 诗词服务类
 */
export class PoemService {
  private poemRepository: PoemRepository;

  constructor(poemRepository: PoemRepository) {
    this.poemRepository = poemRepository;
  }

  /**
   * 获取所有诗词
   */
  async getAllPoems(): Promise<Result<Poem[]>> {
    try {
      const poems = await this.poemRepository.getAll();
      return { success: true, data: poems };
    } catch (error) {
      return { success: false, error: `获取诗词列表失败: ${error}` };
    }
  }

  /**
   * 根据ID获取诗词
   */
  async getPoemById(id: string): Promise<Result<Poem>> {
    try {
      const poem = await this.poemRepository.getById(id);
      if (!poem) {
        return { success: false, error: '未找到诗词' };
      }
      return { success: true, data: poem };
    } catch (error) {
      return { success: false, error: `获取诗词失败: ${error}` };
    }
  }

  /**
   * 搜索诗词
   */
  async searchPoems(keyword: string): Promise<Result<Poem[]>> {
    try {
      const poems = await this.poemRepository.search(keyword);
      return { success: true, data: poems };
    } catch (error) {
      return { success: false, error: `搜索诗词失败: ${error}` };
    }
  }

  /**
   * 添加诗词
   */
  async addPoem(poem: Poem): Promise<Result<Poem>> {
    try {
      // 检查是否已存在相同ID的诗词
      const existing = await this.poemRepository.getById(poem.id);
      if (existing) {
        return { success: false, error: '诗词ID已存在' };
      }

      return await this.poemRepository.add(poem);
    } catch (error) {
      return { success: false, error: `添加诗词失败: ${error}` };
    }
  }

  /**
   * 更新诗词
   */
  async updatePoem(poem: Poem): Promise<Result<Poem>> {
    try {
      return await this.poemRepository.update(poem);
    } catch (error) {
      return { success: false, error: `更新诗词失败: ${error}` };
    }
  }

  /**
   * 删除诗词
   */
  async deletePoem(id: string): Promise<Result<void>> {
    try {
      return await this.poemRepository.delete(id);
    } catch (error) {
      return { success: false, error: `删除诗词失败: ${error}` };
    }
  }

  /**
   * 检查诗句是否在诗词库中
   */
  async containsVerse(verse: string): Promise<boolean> {
    return await this.poemRepository.containsVerse(verse);
  }

  /**
   * 根据诗句查找诗词
   */
  async findPoemByVerse(verse: string): Promise<Result<Poem>> {
    try {
      const poem = await this.poemRepository.findByVerse(verse);
      if (!poem) {
        return { success: false, error: '未找到包含该诗句的诗词' };
      }
      return { success: true, data: poem };
    } catch (error) {
      return { success: false, error: `查找诗词失败: ${error}` };
    }
  }
}
