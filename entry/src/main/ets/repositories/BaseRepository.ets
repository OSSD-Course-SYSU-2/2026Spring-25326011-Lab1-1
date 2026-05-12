import dataPreferences from '@ohos.data.preferences';
import resourceManager from '@ohos.resourceManager';
import { Result } from '../types/results';

/**
 * 仓储接口
 */
export interface IRepository<T> {
  getAll(): Promise<T[]>;
  getById(id: string): Promise<T | null>;
  add(item: T): Promise<Result<T>>;
  update(item: T): Promise<Result<T>>;
  delete(id: string): Promise<Result<void>>;
}

/**
 * 基础仓储类
 */
export abstract class BaseRepository<T> implements IRepository<T> {
  protected context: Context;
  protected preferencesName: string;
  protected dataKey: string;
  protected rawFileName: string;
  protected items: T[] = [];

  constructor(
    context: Context,
    preferencesName: string,
    dataKey: string,
    rawFileName: string
  ) {
    this.context = context;
    this.preferencesName = preferencesName;
    this.dataKey = dataKey;
    this.rawFileName = rawFileName;
  }

  /**
   * 初始化数据
   */
  async init(): Promise<void> {
    try {
      // 尝试从Preferences加载数据
      const loaded = await this.loadFromPreferences();
      if (loaded) {
        return;
      }

      // 如果Preferences没有数据，从RawFile加载
      await this.initDataFromRawFile();
    } catch (error) {
      console.error(`初始化数据失败: ${error}`);
    }
  }

  /**
   * 从RawFile加载初始数据
   */
  protected async initDataFromRawFile(): Promise<void> {
    try {
      const resMgr = await resourceManager.getResourceManager(this.context);
      const fileData = await resMgr.getRawFileContent(this.rawFileName);
      const text = String.fromCharCode.apply(null, Array.from(fileData));
      const data = JSON.parse(text);

      if (Array.isArray(data)) {
        this.items = data;
        await this.saveToPreferences();
      }
    } catch (error) {
      console.error(`从RawFile加载数据失败: ${error}`);
      this.items = [];
    }
  }

  /**
   * 保存数据到Preferences
   */
  protected async saveToPreferences(): Promise<void> {
    try {
      const preferences = await dataPreferences.getPreferences(this.context, this.preferencesName);
      await preferences.put(this.dataKey, JSON.stringify(this.items));
      await preferences.flush();
    } catch (error) {
      console.error(`保存数据到Preferences失败: ${error}`);
    }
  }

  /**
   * 从Preferences加载数据
   */
  protected async loadFromPreferences(): Promise<boolean> {
    try {
      const preferences = await dataPreferences.getPreferences(this.context, this.preferencesName);
      const dataStr = await preferences.get(this.dataKey, '');

      if (dataStr && typeof dataStr === 'string') {
        const data = JSON.parse(dataStr);
        if (Array.isArray(data)) {
          this.items = data;
          return true;
        }
      }
      return false;
    } catch (error) {
      console.error(`从Preferences加载数据失败: ${error}`);
      return false;
    }
  }

  /**
   * 获取所有数据
   */
  async getAll(): Promise<T[]> {
    return this.items;
  }

  /**
   * 根据ID获取数据
   */
  async getById(id: string): Promise<T | null> {
    const item = this.items.find((i: T) => (i as any).id === id);
    return item || null;
  }

  /**
   * 添加数据
   */
  async add(item: T): Promise<Result<T>> {
    try {
      this.items.push(item);
      await this.saveToPreferences();
      return { success: true, data: item };
    } catch (error) {
      return { success: false, error: `添加数据失败: ${error}` };
    }
  }

  /**
   * 更新数据
   */
  async update(item: T): Promise<Result<T>> {
    try {
      const index = this.items.findIndex((i: T) => (i as any).id === (item as any).id);
      if (index === -1) {
        return { success: false, error: '未找到要更新的数据' };
      }
      this.items[index] = item;
      await this.saveToPreferences();
      return { success: true, data: item };
    } catch (error) {
      return { success: false, error: `更新数据失败: ${error}` };
    }
  }

  /**
   * 删除数据
   */
  async delete(id: string): Promise<Result<void>> {
    try {
      const index = this.items.findIndex((i: T) => (i as any).id === id);
      if (index === -1) {
        return { success: false, error: '未找到要删除的数据' };
      }
      this.items.splice(index, 1);
      await this.saveToPreferences();
      return { success: true };
    } catch (error) {
      return { success: false, error: `删除数据失败: ${error}` };
    }
  }
}
