# 猜诗词游戏

一个基于Wordle机制的中文诗词猜谜游戏，使用ArkTS和HarmonyOS开发。

## 游戏规则

1. 系统从题库中随机挑选一句诗，并提示上下句字数
2. 玩家输入诗句并点击"猜测"（无需输入标点）
3. 若诗句与答案完全匹配，则游戏成功
4. 否则：
   - 若诗句在诗词库中且字数正确，则用颜色标记反馈：
     - 绿色：答案中含有且位置正确的字
     - 黄色：答案中含有但位置不正确的字
     - 灰色：答案中不存在的字
   - 若不在诗词库中或字数不正确，提示"请输入一句字数正确的古诗词"
5. 玩家每轮有20次猜测机会

## 功能特性

✅ Wordle式颜色反馈机制
✅ 题库和诗词库管理
✅ 灰色字提示功能
✅ 句间标点规则处理
✅ 特殊情况标记支持

预览：

开始界面：

<img width="458" height="946" alt="image" src="https://github.com/user-attachments/assets/b9b42ce9-40a8-4fd3-b9ea-f78c2cb3f575" />

若成功：

<img width="355" height="719" alt="image" src="https://github.com/user-attachments/assets/15a6540a-31fe-4e19-82cd-05bea5834426" />



## 项目结构

```
entry/
├── src/main/
│   ├── ets/
│   │   ├── types/           # 类型定义
│   │   ├── utils/           # 工具类
│   │   ├── constants/       # 常量配置
│   │   ├── services/        # 服务层
│   │   ├── repositories/    # 数据访问层
│   │   ├── viewmodels/      # 视图模型
│   │   ├── components/      # UI组件
│   │   │   ├── common/      # 公共组件
│   │   │   ├── game/        # 游戏组件
│   │   │   ├── manage/      # 管理组件
│   │   │   └── rules/       # 规则组件
│   │   └── pages/           # 页面
│   └── resources/
│       └── rawfile/         # 初始数据文件
│           ├── poems.json
│           ├── questions.json
│           └── categories.json
```

## 构建要求

- DevEco Studio 3.1+
- HarmonyOS SDK API 9+
- Node.js 14+

## 使用说明

### 游戏界面

1. 启动游戏后自动开始新游戏
2. 在输入框中输入猜测的诗句
3. 点击"猜测"按钮或按回车提交
4. 观察颜色反馈，继续猜测直到成功或次数用尽


## 技术架构

本项目采用MVVM架构：

- **Model**: 数据模型和Repository层
- **View**: UI组件和页面
- **ViewModel**: 状态管理和业务逻辑

### 核心技术

- **ArkTS**: HarmonyOS应用开发语言
- **ArkUI**: HarmonyOS UI框架
- **Preferences**: 本地数据存储
- **ResourceManager**: 资源文件管理

## 开发说明

### 数据存储

- 使用Preferences进行本地数据持久化
- 首次运行时从RawFile加载初始数据
- 题库在questions.json文件中，所有题目选自此文件，一共3k+题目
- 诗词库在poems.json文件中，若输入的诗句属于此文件，才视为合法
- poems.json文件仍在完善中
- 2026/6/9：已完善poems.json文件



## 许可证

ISC License
