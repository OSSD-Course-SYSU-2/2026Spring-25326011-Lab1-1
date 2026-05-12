import { Category } from '../types/models';
import { Result } from '../types/results';
import { CategoryRepository } from '../repositories/CategoryRepository';
import { QuestionRepository } from '../repositories/QuestionRepository';

/**
 * 分类服务类
 */
export class CategoryService {
  private categoryRepository: CategoryRepository;
  private questionRepository: QuestionRepository;

  constructor(categoryRepository: CategoryRepository, questionRepository: QuestionRepository) {
    this.categoryRepository = categoryRepository;
    this.questionRepository = questionRepository;
  }

  /**
   * 获取所有分类
   */
  async getAllCategories(): Promise<Result<Category[]>> {
    try {
      const categories = await this.categoryRepository.getAll();
      return { success: true, data: categories };
    } catch (error) {
      return { success: false, error: `获取分类列表失败: ${error}` };
    }
  }

  /**
   * 根据ID获取分类
   */
  async getCategoryById(id: string): Promise<Result<Category>> {
    try {
      const category = await this.categoryRepository.getById(id);
      if (!category) {
        return { success: false, error: '未找到分类' };
      }
      return { success: true, data: category };
    } catch (error) {
      return { success: false, error: `获取分类失败: ${error}` };
    }
  }

  /**
   * 添加分类
   */
  async addCategory(category: Category): Promise<Result<Category>> {
    try {
      // 检查是否已存在相同名称的分类
      const existing = await this.categoryRepository.existsByName(category.name);
      if (existing) {
        return { success: false, error: '分类名称已存在' };
      }

      return await this.categoryRepository.add(category);
    } catch (error) {
      return { success: false, error: `添加分类失败: ${error}` };
    }
  }

  /**
   * 更新分类
   */
  async updateCategory(category: Category): Promise<Result<Category>> {
    try {
      return await this.categoryRepository.update(category);
    } catch (error) {
      return { success: false, error: `更新分类失败: ${error}` };
    }
  }

  /**
   * 删除分类
   */
  async deleteCategory(id: string): Promise<Result<void>> {
    try {
      return await this.categoryRepository.delete(id);
    } catch (error) {
      return { success: false, error: `删除分类失败: ${error}` };
    }
  }

  /**
   * 获取分类及其题目数量
   */
  async getCategoriesWithCount(): Promise<Result<Array<Category & { count: number }>>> {
    try {
      const categories = await this.categoryRepository.getAll();
      const questions = await this.questionRepository.getAll();

      const categoriesWithCount = categories.map((category: Category) => {
        const count = questions.filter((q: any) => {
          return q.categoryIds && q.categoryIds.includes(category.id);
        }).length;
        return { ...category, count };
      });

      return { success: true, data: categoriesWithCount };
    } catch (error) {
      return { success: false, error: `获取分类统计失败: ${error}` };
    }
  }
}
