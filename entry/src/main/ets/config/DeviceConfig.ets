/**
 * 设备类型枚举
 */
export enum DeviceType {
  PHONE = 'phone',
  TABLET = 'tablet',
  WATCH = 'watch',
  TV = 'tv',
  CAR = 'car'
}

/**
 * 设备配置接口
 */
export interface DeviceConfig {
  type: DeviceType;
  screenWidth: number;
  screenHeight: number;
  fontSize: number;
  charSize: number;
  padding: number;
  maxGuesses: number;
}

/**
 * 多端配置管理类
 */
export class DeviceConfigManager {
  private static instance: DeviceConfigManager;
  private currentConfig: DeviceConfig | null = null;
  
  // 预定义的设备配置
  private readonly configs: Record<string, DeviceConfig> = {
    [DeviceType.PHONE]: {
      type: DeviceType.PHONE,
      screenWidth: 360,
      screenHeight: 640,
      fontSize: 14,
      charSize: 24,
      padding: 4,
      maxGuesses: 20
    },
    [DeviceType.TABLET]: {
      type: DeviceType.TABLET,
      screenWidth: 720,
      screenHeight: 1280,
      fontSize: 18,
      charSize: 32,
      padding: 8,
      maxGuesses: 20
    },
    [DeviceType.WATCH]: {
      type: DeviceType.WATCH,
      screenWidth: 200,
      screenHeight: 200,
      fontSize: 12,
      charSize: 18,
      padding: 2,
      maxGuesses: 10
    },
    [DeviceType.TV]: {
      type: DeviceType.TV,
      screenWidth: 1920,
      screenHeight: 1080,
      fontSize: 24,
      charSize: 48,
      padding: 16,
      maxGuesses: 20
    },
    [DeviceType.CAR]: {
      type: DeviceType.CAR,
      screenWidth: 800,
      screenHeight: 480,
      fontSize: 16,
      charSize: 28,
      padding: 6,
      maxGuesses: 15
    }
  };
  
  private constructor() {}
  
  /**
   * 获取单例实例
   */
  public static getInstance(): DeviceConfigManager {
    if (!DeviceConfigManager.instance) {
      DeviceConfigManager.instance = new DeviceConfigManager();
    }
    return DeviceConfigManager.instance;
  }
  
  /**
   * 根据屏幕尺寸自动识别设备类型
   */
  public detectDevice(width: number, height: number): DeviceType {
    const minDimension = width < height ? width : height;
    
    if (minDimension < 250) {
      return DeviceType.WATCH;
    } else if (minDimension < 400) {
      return DeviceType.PHONE;
    } else if (minDimension < 900) {
      return DeviceType.TABLET;
    } else if (minDimension >= 1080) {
      return DeviceType.TV;
    } else {
      return DeviceType.CAR;
    }
  }
  
  /**
   * 初始化设备配置
   */
  public init(width: number, height: number): void {
    const deviceType = this.detectDevice(width, height);
    this.currentConfig = this.configs[deviceType];
    console.info(`[DeviceConfig] 检测到设备类型: ${deviceType}, 屏幕: ${width}x${height}`);
  }
  
  /**
   * 获取当前设备配置
   */
  public getConfig(): DeviceConfig {
    if (!this.currentConfig) {
      // 默认使用手机配置
      this.currentConfig = this.configs[DeviceType.PHONE];
    }
    return this.currentConfig;
  }
  
  /**
   * 获取字体大小
   */
  public getFontSize(): number {
    return this.getConfig().fontSize;
  }
  
  /**
   * 获取字符大小
   */
  public getCharSize(): number {
    return this.getConfig().charSize;
  }
  
  /**
   * 获取内边距
   */
  public getPadding(): number {
    return this.getConfig().padding;
  }
  
  /**
   * 获取最大猜测次数
   */
  public getMaxGuesses(): number {
    return this.getConfig().maxGuesses;
  }
}
