import dataPreferences from '@ohos.data.preferences';
import resourceManager from '@ohos.resourceManager';
import util from '@ohos.util';
import { Result } from '../types/results';

/**
 * 带ID的项接口
 */
interface ItemWithId {
  id: string;
}

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
      console.info(`[BaseRepository] 开始初始化: ${this.rawFileName}`);
      // 直接从RawFile加载，忽略Preferences缓存
      await this.initDataFromRawFile();
      console.info(`[BaseRepository] 初始化完成: ${this.rawFileName}, 数据量: ${this.items.length}`);
    } catch (error) {
      console.error(`[BaseRepository] 初始化数据失败: ${error}`);
      // ArkTS 要求 throw 必须是 Error 类型
      if (error instanceof Error) {
        throw error;
      } else {
        throw new Error(`初始化数据失败: ${error}`);
      }
    }
  }

  /**
   * 从RawFile加载初始数据
   */
  protected async initDataFromRawFile(): Promise<void> {
    try {
      console.info(`[BaseRepository] 开始加载RawFile: ${this.rawFileName}`);
      
      const resMgr = this.context.resourceManager;
      const fileData = await resMgr.getRawFileContent(this.rawFileName);
      
      console.info(`[BaseRepository] 文件读取成功，大小: ${fileData.byteLength} bytes`);
      
      // ArrayBuffer转字符串（使用UTF-8解码）
      const uint8Array = new Uint8Array(fileData);
      let text = '';
      
      // 尝试使用TextDecoder，如果失败则使用备用方法
      console.info(`[BaseRepository] 开始UTF-8解码`);
      try {
        const textDecoder = util.TextDecoder.create('utf-8');
        text = textDecoder.decodeToString(uint8Array);
        console.info(`[BaseRepository] TextDecoder解码成功，文本长度: ${text.length} 字符`);
      } catch (e) {
        console.warn(`[BaseRepository] TextDecoder失败，使用备用方法: ${e}`);
        text = this.utf8ArrayToString(uint8Array);
        console.info(`[BaseRepository] 备用方法解码成功，文本长度: ${text.length} 字符`);
      }
      
      // 如果解码结果为空，使用备用方法
      if (text.length === 0) {
        console.warn(`[BaseRepository] TextDecoder返回空文本，使用备用方法`);
        text = this.utf8ArrayToString(uint8Array);
        console.info(`[BaseRepository] 备用方法解码成功，文本长度: ${text.length} 字符`);
      }
      
      console.info(`[BaseRepository] 最终文本长度: ${text.length} 字符`);
      console.info(`[BaseRepository] 文本前100字符: ${text.substring(0, 100)}`);
      
      // 解析JSON
      console.info(`[BaseRepository] 开始解析JSON`);
      const data: Object = JSON.parse(text);
      console.info(`[BaseRepository] JSON解析成功`);

      // 处理新的JSON格式（包含poems或questions包装对象）
      let items: T[] = [];
      if (Array.isArray(data)) {
        items = data as T[];
        console.info(`[BaseRepository] 数据是数组，长度: ${items.length}`);
      } else {
        const dataObj: Record<string, Object> = data as Record<string, Object>;
        const poemsValue: Object | undefined = dataObj['poems'];
        const questionsValue: Object | undefined = dataObj['questions'];
        
        if (poemsValue !== undefined && Array.isArray(poemsValue)) {
          items = poemsValue as T[];
          console.info(`[BaseRepository] 提取poems数组，长度: ${items.length}`);
        } else if (questionsValue !== undefined && Array.isArray(questionsValue)) {
          items = questionsValue as T[];
          console.info(`[BaseRepository] 提取questions数组，长度: ${items.length}`);
        } else {
          console.warn(`[BaseRepository] 未找到有效的数据数组`);
        }
      }

      this.items = items;
      console.info(`[BaseRepository] 最终数据量: ${this.items.length}`);
      
      await this.saveToPreferences();
      console.info(`[BaseRepository] 数据已保存到Preferences`);
    } catch (error) {
      console.error(`[BaseRepository] 从RawFile加载数据失败: ${error}`);
      console.error(`[BaseRepository] 错误堆栈: ${new Error().stack}`);
      this.items = [];
      // ArkTS 要求 throw 必须是 Error 类型
      if (error instanceof Error) {
        throw error;
      } else {
        throw new Error(`从RawFile加载数据失败: ${error}`);
      }
    }
  }

  /**
   * UTF-8数组转字符串（备用方法）
   */
  private utf8ArrayToString(uint8Array: Uint8Array): string {
    let result = '';
    let i = 0;
    
    while (i < uint8Array.length) {
      let byte1 = uint8Array[i++];
      
      if (byte1 < 0x80) {
        // 单字节字符 (0-127)
        result += String.fromCharCode(byte1);
      } else if (byte1 >= 0xC0 && byte1 < 0xE0) {
        // 双字节字符
        let byte2 = uint8Array[i++];
        let charCode = ((byte1 & 0x1F) << 6) | (byte2 & 0x3F);
        result += String.fromCharCode(charCode);
      } else if (byte1 >= 0xE0 && byte1 < 0xF0) {
        // 三字节字符（中文）
        let byte2 = uint8Array[i++];
        let byte3 = uint8Array[i++];
        let charCode = ((byte1 & 0x0F) << 12) | ((byte2 & 0x3F) << 6) | (byte3 & 0x3F);
        result += String.fromCharCode(charCode);
      } else if (byte1 >= 0xF0 && byte1 < 0xF8) {
        // 四字节字符
        let byte2 = uint8Array[i++];
        let byte3 = uint8Array[i++];
        let byte4 = uint8Array[i++];
        let charCode = ((byte1 & 0x07) << 18) | ((byte2 & 0x3F) << 12) | ((byte3 & 0x3F) << 6) | (byte4 & 0x3F);
        result += String.fromCharCode(charCode);
      }
    }
    
    return result;
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
      console.error(`[BaseRepository] 保存数据到Preferences失败: ${error}`);
    }
  }

  /**
   * 从Preferences加载数据
   */
  protected async loadFromPreferences(): Promise<boolean> {
    try {
      const preferences = await dataPreferences.getPreferences(this.context, this.preferencesName);
      const dataStr: string = await preferences.get(this.dataKey, '') as string;

      if (dataStr && typeof dataStr === 'string') {
        const data: Object = JSON.parse(dataStr);
        if (Array.isArray(data)) {
          this.items = data as T[];
          return true;
        }
      }
      return false;
    } catch (error) {
      console.error(`[BaseRepository] 从Preferences加载数据失败: ${error}`);
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
    const item = this.items.find((i: T) => (i as ItemWithId).id === id);
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
      const index = this.items.findIndex((i: T) => (i as ItemWithId).id === (item as ItemWithId).id);
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
      const index = this.items.findIndex((i: T) => (i as ItemWithId).id === id);
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
