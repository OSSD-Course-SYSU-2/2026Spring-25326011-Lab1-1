# 猜诗词游戏技术设计方案

## 1. 架构概览

### 1.1 整体架构

本应用采用 **MVVM架构模式**，结合HarmonyOS的ArkUI声明式开发范式，实现关注点分离和响应式数据绑定。

```
┌─────────────────────────────────────────────────────────────┐
│                      Presentation Layer                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  GamePage   │  │ ManagePage  │  │  Other UI Pages     │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
└─────────┼────────────────┼────────────────────┼─────────────┘
          │                │                    │
          ▼                ▼                    ▼
┌─────────────────────────────────────────────────────────────┐
│                       ViewModel Layer                        │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ GameViewModel│  │ManageViewModel│  │  Other ViewModels  │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
└─────────┼────────────────┼────────────────────┼─────────────┘
          │                │                    │
          ▼                ▼                    ▼
┌─────────────────────────────────────────────────────────────┐
│                        Service Layer                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ GameService │  │PoemService  │  │ QuestionService     │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
└─────────┼────────────────┼────────────────────┼─────────────┘
          │                │                    │
          ▼                ▼                    ▼
┌─────────────────────────────────────────────────────────────┐
│                        Data Layer                            │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Repository (Data Access)                  │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌───────────────┐  │  │
│  │  │PoemRepository│  │QuestionRepo │  │CategoryRepo   │  │  │
│  │  └─────────────┘  └─────────────┘  └───────────────┘  │  │
│  └───────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │              Data Source (Storage)                     │  │
│  │  ┌─────────────────┐  ┌─────────────────────────────┐ │  │
│  │  │ LocalStorage    │  │  JSON File Handler          │ │  │
│  │  │ (Preferences)   │  │  (RawFile)                  │ │  │
│  │  └─────────────────┘  └─────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 模块划分

| 模块 | 职责 | 关键组件 |
|------|------|----------|
| **Game** | 游戏核心逻辑 | GamePage, GameViewModel, GameService |
| **Poem** | 诗词数据管理 | PoemService, PoemRepository |
| **Question** | 题目数据管理 | QuestionService, QuestionRepository |
| **Category** | 分类数据管理 | CategoryService, CategoryRepository |
| **Common** | 公共组件与工具 | UI组件, 工具类, 类型定义 |

---

## 2. 技术选型

### 2.1 核心技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| ArkTS | API 9+ | 应用开发语言 |
| ArkUI | 声明式范式 | UI框架 |
| @ohos.data.preferences | API 9+ | 本地数据存储 |
| @ohos.resourceManager | API 9+ | 资源文件读取 |

### 2.2 数据存储方案

```
┌─────────────────────────────────────────────────────────┐
│                    Data Storage Strategy                 │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌─────────────────┐      ┌─────────────────────────┐   │
│  │  Initial Load   │ ───▶ │  RawFile (resources/)   │   │
│  │  (First Run)    │      │  - poems.json           │   │
│  │                 │      │  - questions.json       │   │
│  └─────────────────┘      └─────────────────────────┘   │
│           │                                              │
│           ▼                                              │
│  ┌─────────────────┐      ┌─────────────────────────┐   │
│  │  Runtime Data   │ ───▶ │  Preferences            │   │
│  │  (User Changes) │      │  - Key-Value Storage    │   │
│  │                 │      │  - JSON Serialization   │   │
│  └─────────────────┘      └─────────────────────────┘   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**存储策略说明**：
- **初始数据**：通过RawFile读取resources/rawfile目录下的JSON文件
- **运行时数据**：使用Preferences API存储用户修改后的数据
- **数据同步**：首次运行时从RawFile加载，后续从Preferences读取

---

## 3. 核心类型定义

### 3.1 数据模型类型

```typescript
// ==================== 基础类型 ====================

/**
 * 反馈状态枚举
 */
export enum FeedbackStatus {
  CORRECT = 'correct',      // 位置正确（绿色）
  MISPLACED = 'misplaced',  // 存在但位置错误（黄色）
  ABSENT = 'absent'         // 不存在（灰色）
}

/**
 * 难度等级枚举
 */
export enum Difficulty {
  EASY = 1,
  MEDIUM = 2,
  HARD = 3,
  EXPERT = 4,
  MASTER = 5
}

// ==================== 实体类型 ====================

/**
 * 诗词实体
 */
export interface Poem {
  id: string;
  title: string;
  author: string;
  dynasty: string;
  verses: string[];
}

/**
 * 题目实体
 */
export interface Question {
  id: string;
  content: string;
  poemId: string;
  difficulty: Difficulty;
  categoryIds: string[];
}

/**
 * 分类实体
 */
export interface Category {
  id: string;
  name: string;
  description: string;
}

/**
 * 反馈项
 */
export interface FeedbackItem {
  char: string;
  status: FeedbackStatus;
}

/**
 * 猜测记录
 */
export interface GuessRecord {
  content: string;
  feedback: FeedbackItem[];
  timestamp: number;
}

// ==================== 状态类型 ====================

/**
 * 游戏状态枚举
 */
export enum GameState {
  IDLE = 'idle',           // 空闲（未开始）
  PLAYING = 'playing',     // 游戏中
  SUCCESS = 'success',     // 成功
  FAILED = 'failed'        // 失败
}

/**
 * 游戏会话状态
 */
export interface GameSession {
  state: GameState;
  currentQuestion: Question | null;
  currentPoem: Poem | null;
  remainingGuesses: number;
  guessHistory: GuessRecord[];
  hint: HintInfo | null;
}

/**
 * 提示信息
 */
export interface HintInfo {
  prevVerseCharCount: number;   // 上一句字数
  nextVerseCharCount: number;   // 下一句字数
  currentVerseCharCount: number; // 当前句字数
}

// ==================== 结果类型 ====================

/**
 * 匹配结果
 */
export interface MatchResult {
  isCorrect: boolean;
  isValidInput: boolean;
  feedback: FeedbackItem[];
  errorMessage?: string;
}

/**
 * 操作结果（泛型）
 */
export interface Result<T> {
  success: boolean;
  data?: T;
  error?: string;
}
```

### 3.2 ViewModel状态类型

```typescript
/**
 * 游戏页面状态
 */
export interface GamePageState {
  session: GameSession;
  inputText: string;
  isLoading: boolean;
  showRules: boolean;
}

/**
 * 管理页面状态
 */
export interface ManagePageState {
  activeTab: 'poem' | 'question' | 'category';
  poems: Poem[];
  questions: Question[];
  categories: Category[];
  searchKeyword: string;
  isLoading: boolean;
}
```

---

## 4. 核心服务设计

### 4.1 游戏服务 (GameService)

**职责**：处理游戏核心逻辑，包括题目选择、猜测匹配、反馈计算

```typescript
/**
 * 游戏服务接口
 */
export interface IGameService {
  /**
   * 开始新游戏
   * @returns 游戏会话
   */
  startNewGame(): Promise<Result<GameSession>>;

  /**
   * 提交猜测
   * @param input 玩家输入
   * @param session 当前游戏会话
   * @returns 匹配结果
   */
  submitGuess(input: string, session: GameSession): Promise<Result<MatchResult>>;

  /**
   * 计算反馈
   * @param guess 猜测内容
   * @param answer 正确答案
   * @returns 反馈项数组
   */
  calculateFeedback(guess: string, answer: string): FeedbackItem[];

  /**
   * 生成提示信息
   * @param poem 诗词
   * @param verseIndex 诗句索引
   * @returns 提示信息
   */
  generateHint(poem: Poem, verseIndex: number): HintInfo;
}
```

**核心算法：反馈计算**

```
算法：calculateFeedback(guess, answer)
输入：guess - 猜测字符串, answer - 答案字符串
输出：FeedbackItem[] - 反馈项数组

步骤：
1. 过滤标点：guessChars = filterPunctuation(guess)
2. 过滤标点：answerChars = filterPunctuation(answer)
3. 初始化：feedback = [], answerRemaining = answerChars副本

4. 第一遍遍历（标记正确位置）：
   FOR i = 0 TO guessChars.length - 1:
     IF guessChars[i] == answerChars[i]:
       feedback[i] = {char: guessChars[i], status: CORRECT}
       从answerRemaining中移除该字符

5. 第二遍遍历（标记错误位置）：
   FOR i = 0 TO guessChars.length - 1:
     IF feedback[i] 未设置:
       IF guessChars[i] 在 answerRemaining 中:
         feedback[i] = {char: guessChars[i], status: MISPLACED}
         从answerRemaining中移除一个该字符
       ELSE:
         feedback[i] = {char: guessChars[i], status: ABSENT}

6. 返回 feedback
```

### 4.2 诗词服务 (PoemService)

**职责**：管理诗词数据的增删改查

```typescript
/**
 * 诗词服务接口
 */
export interface IPoemService {
  /**
   * 获取所有诗词
   */
  getAllPoems(): Promise<Result<Poem[]>>;

  /**
   * 根据ID获取诗词
   */
  getPoemById(id: string): Promise<Result<Poem>>;

  /**
   * 搜索诗词
   */
  searchPoems(keyword: string): Promise<Result<Poem[]>>;

  /**
   * 添加诗词
   */
  addPoem(poem: Omit<Poem, 'id'>): Promise<Result<Poem>>;

  /**
   * 更新诗词
   */
  updatePoem(poem: Poem): Promise<Result<void>>;

  /**
   * 删除诗词
   */
  deletePoem(id: string): Promise<Result<void>>;

  /**
   * 检查诗句是否在诗词库中
   */
  containsVerse(verse: string): Promise<boolean>;

  /**
   * 根据诗句查找诗词
   */
  findPoemByVerse(verse: string): Promise<Result<Poem>>;
}
```

### 4.3 题目服务 (QuestionService)

**职责**：管理题目数据的增删改查、分类关联

```typescript
/**
 * 题目服务接口
 */
export interface IQuestionService {
  /**
   * 获取所有题目
   */
  getAllQuestions(): Promise<Result<Question[]>>;

  /**
   * 根据ID获取题目
   */
  getQuestionById(id: string): Promise<Result<Question>>;

  /**
   * 根据分类获取题目
   */
  getQuestionsByCategory(categoryId: string): Promise<Result<Question[]>>;

  /**
   * 添加题目
   */
  addQuestion(question: Omit<Question, 'id'>): Promise<Result<Question>>;

  /**
   * 批量添加题目
   */
  addQuestions(questions: Array<Omit<Question, 'id'>>): Promise<Result<Question[]>>;

  /**
   * 更新题目
   */
  updateQuestion(question: Question): Promise<Result<void>>;

  /**
   * 删除题目
   */
  deleteQuestion(id: string): Promise<Result<void>>;

  /**
   * 随机选择题目
   */
  getRandomQuestion(): Promise<Result<Question>>;

  /**
   * 设置题目难度
   */
  setDifficulty(id: string, difficulty: Difficulty): Promise<Result<void>>;

  /**
   * 分配题目到分类
   */
  assignToCategory(questionId: string, categoryId: string): Promise<Result<void>>;

  /**
   * 从分类移除题目
   */
  removeFromCategory(questionId: string, categoryId: string): Promise<Result<void>>;
}
```

### 4.4 数据导入导出服务 (DataService)

**职责**：处理数据的导入导出

```typescript
/**
 * 数据服务接口
 */
export interface IDataService {
  /**
   * 导出所有数据
   */
  exportData(): Promise<Result<{ poems: Poem[], questions: Question[] }>>;

  /**
   * 导入数据
   */
  importData(data: { poems?: Poem[], questions?: Question[] }): Promise<Result<ImportStats>>;

  /**
   * 验证数据格式
   */
  validateData(data: unknown): Result<boolean>;
}

/**
 * 导入统计
 */
export interface ImportStats {
  poemsImported: number;
  questionsImported: number;
  poemsSkipped: number;
  questionsSkipped: number;
}
```

---

## 5. 数据访问层设计

### 5.1 仓储模式

```typescript
/**
 * 通用仓储接口
 */
export interface IRepository<T> {
  getAll(): Promise<T[]>;
  getById(id: string): Promise<T | null>;
  add(entity: T): Promise<void>;
  update(entity: T): Promise<void>;
  delete(id: string): Promise<void>;
}

/**
 * 诗词仓储实现
 */
export class PoemRepository implements IRepository<Poem> {
  private storageKey = 'poems';
  private preferences: dataPreferences.Preferences;

  constructor(preferences: dataPreferences.Preferences) {
    this.preferences = preferences;
  }

  async getAll(): Promise<Poem[]> {
    const data = await this.preferences.get(this.storageKey, '[]');
    return JSON.parse(data as string) as Poem[];
  }

  // ... 其他方法实现
}
```

### 5.2 数据初始化流程

```
┌─────────────────────────────────────────────────────────────┐
│                    Data Initialization Flow                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  1. 应用启动                                                  │
│     │                                                        │
│     ▼                                                        │
│  2. 检查 Preferences 是否有数据                               │
│     │                                                        │
│     ├── 有数据 ──▶ 直接加载 Preferences 数据                  │
│     │                                                        │
│     └── 无数据 ──▶ 3. 从 RawFile 读取初始数据                 │
│                       │                                      │
│                       ▼                                      │
│                    4. 写入 Preferences                        │
│                       │                                      │
│                       ▼                                      │
│                    5. 返回数据                                │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. UI组件设计

### 6.1 页面结构

```
pages/
├── Index.ets                    # 入口页面（游戏主界面）
├── GamePage.ets                 # 游戏页面
├── ManagePage.ets               # 管理页面
├── PoemManagePage.ets           # 诗词管理页面
├── QuestionManagePage.ets       # 题目管理页面
└── CategoryManagePage.ets       # 分类管理页面
```

### 6.2 组件结构

```
components/
├── common/
│   ├── AppTitleBar.ets          # 标题栏
│   ├── LoadingDialog.ets        # 加载对话框
│   └── ConfirmDialog.ets        # 确认对话框
│
├── game/
│   ├── GuessInput.ets           # 猜测输入组件
│   ├── GuessHistory.ets         # 猜测历史组件
│   ├── FeedbackChar.ets         # 反馈字符组件
│   ├── GameStatus.ets           # 游戏状态组件
│   └── HintDisplay.ets          # 提示显示组件
│
├── manage/
│   ├── PoemList.ets             # 诗词列表组件
│   ├── PoemEditor.ets           # 诗词编辑组件
│   ├── QuestionList.ets         # 题目列表组件
│   ├── QuestionEditor.ets       # 题目编辑组件
│   └── CategoryList.ets         # 分类列表组件
│
└── rules/
    └── GameRules.ets            # 游戏规则说明组件
```

### 6.3 核心UI组件接口

#### 6.3.1 反馈字符组件

```typescript
/**
 * 反馈字符组件属性
 */
@Component
export struct FeedbackChar {
  @Prop char: string = '';
  @Prop status: FeedbackStatus = FeedbackStatus.ABSENT;

  build() {
    Text(this.char)
      .width(40)
      .height(40)
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .fontColor(Color.White)
      .backgroundColor(this.getBackgroundColor())
      .borderRadius(4)
      .textAlign(TextAlign.Center)
  }

  private getBackgroundColor(): ResourceColor {
    switch (this.status) {
      case FeedbackStatus.CORRECT:
        return '#22C55E';  // 绿色
      case FeedbackStatus.MISPLACED:
        return '#EAB308';  // 黄色
      case FeedbackStatus.ABSENT:
        return '#6B7280';  // 灰色
    }
  }
}
```

#### 6.3.2 猜测历史组件

```typescript
/**
 * 猜测历史组件属性
 */
@Component
export struct GuessHistory {
  @Prop history: GuessRecord[] = [];

  build() {
    List({ space: 8 }) {
      ForEach(this.history, (record: GuessRecord, index: number) => {
        ListItem() {
          Row({ space: 4 }) {
            ForEach(record.feedback, (item: FeedbackItem) => {
              FeedbackChar({ char: item.char, status: item.status });
            });
          }
        }
      });
    }
    .width('100%')
    .layoutWeight(1)
  }
}
```

---

## 7. 页面设计

### 7.1 游戏主页面布局

```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │                    AppTitleBar                       │    │
│  │  猜诗词游戏                          [规则] [管理]   │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                   GameStatus                         │    │
│  │  剩余次数: 15                                        │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                   HintDisplay                        │    │
│  │  上句: 5字  |  本句: 7字  |  下句: 7字              │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                   GuessHistory                       │    │
│  │  ┌───┬───┬───┬───┬───┬───┬───┐                      │    │
│  │  │ 春│ 眠│ 不│ 觉│ 晓│ 处│ 闻│  (历史记录)          │    │
│  │  └───┴───┴───┴───┴───┴───┴───┘                      │    │
│  │  ...                                                 │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                   GuessInput                         │    │
│  │  ┌─────────────────────────────┐  ┌────────┐        │    │
│  │  │ 请输入诗句...               │  │  猜测  │        │    │
│  │  └─────────────────────────────┘  └────────┘        │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                   [开始新游戏]                        │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

### 7.2 管理页面布局

```
┌─────────────────────────────────────────────────────────────┐
│  ┌─────────────────────────────────────────────────────┐    │
│  │                    AppTitleBar                       │    │
│  │  数据管理                                    [返回]  │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  [诗词库]    [题库]    [分类]                        │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  ┌─────────────────────────────────┐  ┌────────┐    │    │
│  │  │ 搜索...                         │  │  添加  │    │    │
│  │  └─────────────────────────────────┘  └────────┘    │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │                   数据列表                           │    │
│  │  ┌─────────────────────────────────────────────┐    │    │
│  │  │ 静夜思 - 李白 (唐)              [编辑][删除]│    │    │
│  │  └─────────────────────────────────────────────┘    │    │
│  │  ...                                                 │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                              │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  [导入数据]                          [导出数据]     │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

---

## 8. 状态管理设计

### 8.1 ViewModel实现

```typescript
/**
 * 游戏ViewModel
 */
export class GameViewModel {
  // 状态
  @Observed
  private state: GamePageState = {
    session: {
      state: GameState.IDLE,
      currentQuestion: null,
      currentPoem: null,
      remainingGuesses: 20,
      guessHistory: [],
      hint: null
    },
    inputText: '',
    isLoading: false,
    showRules: false
  };

  // 依赖服务
  private gameService: IGameService;
  private poemService: IPoemService;
  private questionService: IQuestionService;

  constructor(
    gameService: IGameService,
    poemService: IPoemService,
    questionService: IQuestionService
  ) {
    this.gameService = gameService;
    this.poemService = poemService;
    this.questionService = questionService;
  }

  /**
   * 开始新游戏
   */
  async startNewGame(): Promise<void> {
    this.state.isLoading = true;

    const result = await this.gameService.startNewGame();

    if (result.success && result.data) {
      this.state.session = result.data;
    } else {
      // 显示错误提示
    }

    this.state.isLoading = false;
  }

  /**
   * 提交猜测
   */
  async submitGuess(): Promise<void> {
    if (!this.state.inputText.trim()) {
      return;
    }

    const result = await this.gameService.submitGuess(
      this.state.inputText,
      this.state.session
    );

    if (result.success && result.data) {
      // 更新游戏状态
      this.updateGameState(result.data);
    }

    this.state.inputText = '';
  }

  // ... 其他方法
}
```

### 8.2 响应式数据绑定

ArkUI使用 `@State`、`@Prop`、`@Link` 等装饰器实现响应式数据绑定：

```typescript
@Entry
@Component
struct GamePage {
  // ViewModel实例
  private viewModel: GameViewModel = new GameViewModel(/* ... */);

  // 响应式状态
  @State session: GameSession = this.viewModel.getState().session;
  @State inputText: string = '';

  build() {
    Column() {
      // 使用响应式数据
      GameStatus({ remainingGuesses: this.session.remainingGuesses });

      GuessHistory({ history: this.session.guessHistory });

      GuessInput({
        text: this.inputText,
        onTextChange: (value: string) => {
          this.inputText = value;
        },
        onSubmit: () => {
          this.handleSubmit();
        }
      });
    }
  }

  private async handleSubmit(): Promise<void> {
    // 调用ViewModel处理逻辑
    await this.viewModel.submitGuess();
    // 更新状态
    this.session = this.viewModel.getState().session;
  }
}
```

---

## 9. 工具类设计

### 9.1 标点过滤工具

```typescript
/**
 * 字符串工具类
 */
export class StringUtils {
  // 中文标点符号正则
  private static readonly PUNCTUATION_REGEX =
    /[，。、；：？！""''《》【】（）—…·\s]/g;

  /**
   * 过滤标点符号
   */
  static filterPunctuation(text: string): string {
    return text.replace(this.PUNCTUATION_REGEX, '');
  }

  /**
   * 计算字符数（不含标点）
   */
  static countChars(text: string): number {
    return this.filterPunctuation(text).length;
  }

  /**
   * 字符串转字符数组（过滤标点）
   */
  static toCharArray(text: string): string[] {
    return this.filterPunctuation(text).split('');
  }
}
```

### 9.2 ID生成工具

```typescript
/**
 * ID生成工具
 */
export class IdGenerator {
  /**
   * 生成唯一ID
   */
  static generate(): string {
    return `${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }
}
```

### 9.3 数据验证工具

```typescript
/**
 * 数据验证工具
 */
export class Validator {
  /**
   * 验证诗词数据
   */
  static validatePoem(data: unknown): Result<Poem> {
    if (!this.isObject(data)) {
      return { success: false, error: '数据格式错误' };
    }

    const obj = data as Record<string, unknown>;

    if (!obj.title || !obj.author || !obj.verses) {
      return { success: false, error: '缺少必要字段' };
    }

    if (!Array.isArray(obj.verses) || obj.verses.length === 0) {
      return { success: false, error: '诗句不能为空' };
    }

    return { success: true, data: obj as Poem };
  }

  /**
   * 验证题目数据
   */
  static validateQuestion(data: unknown): Result<Question> {
    // 类似实现
  }

  private static isObject(value: unknown): boolean {
    return typeof value === 'object' && value !== null;
  }
}
```

---

## 10. 项目目录结构

```
GuessPoetryGame/
├── entry/
│   └── src/
│       └── main/
│           ├── ets/
│           │   ├── entryability/
│           │   │   └── EntryAbility.ets      # 应用入口
│           │   │
│           │   ├── pages/
│           │   │   ├── Index.ets             # 入口页面
│           │   │   ├── GamePage.ets          # 游戏页面
│           │   │   ├── ManagePage.ets        # 管理页面
│           │   │   ├── PoemManagePage.ets    # 诗词管理
│           │   │   ├── QuestionManagePage.ets # 题目管理
│           │   │   └── CategoryManagePage.ets # 分类管理
│           │   │
│           │   ├── components/
│           │   │   ├── common/               # 公共组件
│           │   │   ├── game/                 # 游戏组件
│           │   │   ├── manage/               # 管理组件
│           │   │   └── rules/                # 规则组件
│           │   │
│           │   ├── viewmodels/
│           │   │   ├── GameViewModel.ets     # 游戏ViewModel
│           │   │   └── ManageViewModel.ets   # 管理ViewModel
│           │   │
│           │   ├── services/
│           │   │   ├── GameService.ets       # 游戏服务
│           │   │   ├── PoemService.ets       # 诗词服务
│           │   │   ├── QuestionService.ets   # 题目服务
│           │   │   ├── CategoryService.ets   # 分类服务
│           │   │   └── DataService.ets       # 数据服务
│           │   │
│           │   ├── repositories/
│           │   │   ├── PoemRepository.ets    # 诗词仓储
│           │   │   ├── QuestionRepository.ets # 题目仓储
│           │   │   └── CategoryRepository.ets # 分类仓储
│           │   │
│           │   ├── types/
│           │   │   ├── models.ets            # 数据模型类型
│           │   │   ├── states.ets            # 状态类型
│           │   │   └── results.ets           # 结果类型
│           │   │
│           │   ├── utils/
│           │   │   ├── StringUtils.ets       # 字符串工具
│           │   │   ├── IdGenerator.ets       # ID生成器
│           │   │   └── Validator.ets         # 数据验证
│           │   │
│           │   └── constants/
│           │       ├── GameConstants.ets     # 游戏常量
│           │       └── Colors.ets            # 颜色常量
│           │
│           └── resources/
│               └── rawfile/
│                   ├── poems.json            # 初始诗词数据
│                   └── questions.json        # 初始题目数据
│
├── build-profile.json5                       # 构建配置
├── hvigorfile.ts                            # 构建脚本
└── oh-package.json5                         # 依赖配置
```

---

## 11. 关键技术决策

### 11.1 为什么选择MVVM架构

| 决策点 | 理由 |
|--------|------|
| 关注点分离 | UI与业务逻辑解耦，便于测试和维护 |
| 响应式绑定 | ArkUI原生支持@State等装饰器，与MVVM天然契合 |
| 状态管理 | ViewModel集中管理状态，避免状态散落在各组件 |

### 11.2 为什么选择Preferences存储

| 决策点 | 理由 |
|--------|------|
| 数据量 | 题库和诗词库数据量适中（预计<1MB），Preferences足够 |
| 性能 | Preferences提供内存缓存，读取速度快 |
| 简单性 | 相比关系型数据库，Preferences使用更简单 |

### 11.3 为什么使用RawFile初始化

| 决策点 | 理由 |
|--------|------|
| 预置数据 | 应用需要预置诗词和题目数据，RawFile是最佳方式 |
| 版本管理 | 初始数据可随应用版本更新 |
| 灵活性 | 用户修改的数据存储在Preferences，不影响原始数据 |

---

## 12. 性能优化策略

### 12.1 初始化优化

- **懒加载**：管理页面数据按需加载
- **异步初始化**：数据加载不阻塞UI渲染
- **缓存机制**：Repository层缓存已加载数据

### 12.2 渲染优化

- **列表虚拟滚动**：使用List组件的虚拟滚动特性
- **状态最小化**：只更新必要的状态，避免全局重渲染
- **组件复用**：使用ForEach复用列表项组件

### 12.3 算法优化

- **反馈计算**：O(n)时间复杂度，n为诗句长度
- **随机选题**：使用Fisher-Yates洗牌算法，保证均匀分布

---

## 13. 错误处理策略

### 13.1 错误类型

```typescript
/**
 * 应用错误类型
 */
export enum AppError {
  DATA_LOAD_FAILED = 'DATA_LOAD_FAILED',
  DATA_SAVE_FAILED = 'DATA_SAVE_FAILED',
  INVALID_INPUT = 'INVALID_INPUT',
  QUESTION_NOT_FOUND = 'QUESTION_NOT_FOUND',
  POEM_NOT_FOUND = 'POEM_NOT_FOUND',
  NETWORK_ERROR = 'NETWORK_ERROR'
}
```

### 13.2 错误处理流程

```
┌─────────────────────────────────────────────────────────────┐
│                    Error Handling Flow                       │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Service/Repository 抛出错误                                  │
│     │                                                        │
│     ▼                                                        │
│  ViewModel 捕获错误，转换为用户友好消息                       │
│     │                                                        │
│     ▼                                                        │
│  UI 显示错误提示（Toast/Dialog）                             │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 14. 测试策略

### 14.1 单元测试范围

| 模块 | 测试重点 |
|------|----------|
| GameService | 反馈计算算法、匹配逻辑 |
| PoemService/QuestionService | CRUD操作、数据验证 |
| StringUtils | 标点过滤、字符计数 |
| Validator | 数据格式验证 |

### 14.2 集成测试范围

| 场景 | 测试内容 |
|------|----------|
| 游戏流程 | 开始游戏→猜测→反馈→结束 |
| 数据管理 | 添加→编辑→删除→保存 |
| 数据导入导出 | 导出→导入→验证 |

---

## 15. 扩展性设计

### 15.1 预留扩展点

- **难度筛选**：QuestionService预留getQuestionsByDifficulty方法
- **分类筛选**：支持按分类筛选题目
- **主题切换**：Colors常量支持多主题配置
- **国际化**：字符串资源化，支持多语言

### 15.2 未来可扩展功能

- 在线题库同步（预留DataService接口）
- 游戏统计（预留GameSession扩展字段）
- 成就系统（预留扩展点）
