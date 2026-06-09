# HarmonyOS 多端部署实践

## 项目概述

本项目基于猜诗词游戏，实现了HarmonyOS的"一次开发，多端部署"能力。

## 支持的设备类型

### 1. 手机 (Phone)
- 屏幕尺寸: 360x640
- 字符大小: 24px
- 字体大小: 14px
- 最大猜测次数: 20次

### 2. 平板 (Tablet)
- 屏幕尺寸: 720x1280
- 字符大小: 32px
- 字体大小: 18px
- 最大猜测次数: 20次

### 3. 智能手表 (Watch)
- 屏幕尺寸: 200x200
- 字符大小: 18px
- 字体大小: 12px
- 最大猜测次数: 10次（简化版）

### 4. 智能电视 (TV)
- 屏幕尺寸: 1920x1080
- 字符大小: 48px
- 字体大小: 24px
- 最大猜测次数: 20次

### 5. 车载系统 (Car)
- 屏幕尺寸: 800x480
- 字符大小: 28px
- 字体大小: 16px
- 最大猜测次数: 15次

## 技术实现

### 1. 响应式布局
- 使用 `DeviceConfigManager` 自动检测设备类型
- 根据设备类型动态调整UI尺寸
- 统一的配置管理

### 2. 自适应组件
- `ResponsiveChar`: 自适应字符方块
- 根据设备类型调整大小和间距

### 3. 设备检测
```typescript
const configManager = DeviceConfigManager.getInstance();
configManager.init(screenWidth, screenHeight);
const config = configManager.getConfig();
```

## 部署步骤

### 1. 配置 module.json5
```json
{
  "module": {
    "deviceTypes": ["phone", "tablet", "tv", "wearable"]
  }
}
```

### 2. 构建多端应用
```bash
# 构建手机版本
hvigorw assembleHap -p product=phone

# 构建平板版本
hvigorw assembleHap -p product=tablet

# 构建电视版本
hvigorw assembleHap -p product=tv

# 构建手表版本
hvigorw assembleHap -p product=wearable
```

### 3. 安装到不同设备
```bash
# 安装到手机
hdc install entry-phone-signed.hap

# 安装到平板
hdc install entry-tablet-signed.hap

# 安装到电视
hdc install entry-tv-signed.hap
```

## 核心优势

### 1. 代码复用
- 一套代码适配所有设备
- 业务逻辑完全复用
- UI组件自动适配

### 2. 开发效率
- 只需开发一次
- 自动适配多端
- 降低维护成本

### 3. 用户体验
- 针对每类设备优化
- 最佳的显示效果
- 流畅的交互体验

## 项目结构

```
entry/
├── src/main/
│   ├── ets/
│   │   ├── config/
│   │   │   └── DeviceConfig.ets       # 多端配置
│   │   ├── components/
│   │   │   └── common/
│   │   │       └── ResponsiveChar.ets # 响应式组件
│   │   ├── pages/
│   │   │   └── GamePage.ets           # 游戏页面
│   │   └── ...
│   └── resources/
│       └── rawfile/
│           ├── poems.json             # 诗词数据
│           └── questions.json         # 题目数据
└── module.json5                       # 模块配置
```

## 测试验证

### 1. 手机测试
- 在DevEco Studio中选择Phone模拟器
- 运行应用，验证UI显示

### 2. 平板测试
- 选择Tablet模拟器
- 验证大屏适配效果

### 3. 电视测试
- 选择TV模拟器
- 验证遥控器操作

### 4. 手表测试
- 选择Wearable模拟器
- 验证简化版功能

## 开源协议

本项目采用 Apache 2.0 协议开源。

## 贡献指南

欢迎提交Issue和Pull Request，共同完善多端适配能力。

## 联系方式

- 项目地址: [GitHub仓库地址]
- 问题反馈: [Issue地址]
