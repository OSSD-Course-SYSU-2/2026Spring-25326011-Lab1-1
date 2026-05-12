# 猜诗词游戏实现任务列表

## 任务概览

本文档将技术设计方案转化为可执行的实现任务，按照依赖关系和优先级排序。

**任务统计**：
- 主任务：12个
- 子任务：38个
- 覆盖需求：61条EARS验收标准

---

## 任务 1：项目基础架构搭建

**任务描述**：创建HarmonyOS项目基础结构，配置开发环境和构建脚本。

**输入**：
- 技术设计方案中的项目目录结构
- HarmonyOS项目配置要求

**输出**：
- 完整的项目目录结构
- 可编译运行的空项目

**验收标准**：
- 项目能够成功编译
- 目录结构符合设计规范
- 所有必要的配置文件就位

**子任务**：

### 1.1 创建HarmonyOS项目
- 使用DevEco Studio创建新项目，选择Empty Ability模板
- 配置项目名称为"GuessPoetryGame"
- 设置minAPIVersion为9，targetAPIVersion为当前最新版本

### 1.2 创建目录结构
- 创建 `ets/types/` 目录存放类型定义
- 创建 `ets/utils/` 目录存放工具类
- 创建 `ets/constants/` 目录存放常量
- 创建 `ets/services/` 目录存放服务层
- 创建 `ets/repositories/` 目录存放数据访问层
- 创建 `ets/viewmodels/` 目录存放视图模型
- 创建 `ets/components/common/` 目录存放公共组件
- 创建 `ets/components/game/` 目录存放游戏组件
- 创建 `ets/components/manage/` 目录存放管理组件
- 创建 `ets/components/rules/` 目录存放规则组件
- 创建 `resources/rawfile/` 目录存放初始数据文件

### 1.3 配置项目依赖
- 确认 `@ohos.data.preferences` 依赖可用
- 确认 `@ohos.resourceManager` 依赖可用

**代码生成提示**：
```
创建HarmonyOS ArkTS项目，配置build-profile.json5和oh-package.json5，
确保项目结构符合MVVM架构设计。
```

---

## 任务 2：类型定义与常量配置

**任务描述**：定义所有数据模型、状态类型、结果类型和常量。

**输入**：
- 设计文档第3节核心类型定义
- 设计文档第9节工具类设计

**输出**：
- `types/models.ets` - 数据模型类型
- `types/states.ets` - 状态类型
- `types/results.ets` - 结果类型
- `constants/GameConstants.ets` - 游戏常量
- `constants/Colors.ets` - 颜色常量

**验收标准**：
- 所有类型定义完整且类型安全
- 枚举值正确对应业务含义
- 常量值符合设计规范

**子任务**：

### 2.1 定义数据模型类型
- 定义 `FeedbackStatus` 枚举（CORRECT, MISPLACED, ABSENT）
- 定义 `Difficulty` 枚举（1-5难度等级）
- 定义 `Poem` 接口（id, title, author, dynasty, verses）
- 定义 `Question` 接口（id, content, poemId, difficulty, categoryIds）
- 定义 `Category` 接口（id, name, description）
- 定义 `FeedbackItem` 接口（char, status）
- 定义 `GuessRecord` 接口（content, feedback, timestamp）

### 2.2 定义状态类型
- 定义 `GameState` 枚举（IDLE, PLAYING, SUCCESS, FAILED）
- 定义 `GameSession` 接口（state, currentQuestion, currentPoem, remainingGuesses, guessHistory, hint）
- 定义 `HintInfo` 接口（prevVerseCharCount, nextVerseCharCount, currentVerseCharCount）
- 定义 `GamePageState` 接口（session, inputText, isLoading, showRules）
- 定义 `ManagePageState` 接口（activeTab, poems, questions, categories, searchKeyword, isLoading）

### 2.3 定义结果类型
- 定义 `MatchResult` 接口（isCorrect, isValidInput, feedback, errorMessage）
- 定义泛型 `Result<T>` 接口（success, data, error）
- 定义 `ImportStats` 接口（poemsImported, questionsImported, poemsSkipped, questionsSkipped）

### 2.4 定义游戏常量
- 定义 `MAX_GUESSES = 20` 最大猜测次数
- 定义 `FEEDBACK_TIMEOUT = 500` 反馈超时时间（ms）
- 定义 `RANDOM_SELECT_TIMEOUT = 100` 随机选题超时时间（ms）

### 2.5 定义颜色常量
- 定义 `COLOR_CORRECT = '#22C55E'` 正确位置颜色（绿色）
- 定义 `COLOR_MISPLACED = '#EAB308'` 错误位置颜色（黄色）
- 定义 `COLOR_ABSENT = '#6B7280'` 不存在颜色（灰色）
- 定义深色模式对应颜色值

**代码生成提示**：
```
在types目录下创建models.ets、states.ets、results.ets文件，
使用ArkTS的interface和enum语法定义所有类型，确保类型安全。
在constants目录下创建GameConstants.ets和Colors.ets文件，
导出所有常量值。
```

---

## 任务 3：工具类实现

**任务描述**：实现字符串处理、ID生成、数据验证等工具类。

**输入**：
- 设计文档第9节工具类设计

**输出**：
- `utils/StringUtils.ets` - 字符串工具类
- `utils/IdGenerator.ets` - ID生成工具
- `utils/Validator.ets` - 数据验证工具

**验收标准**：
- StringUtils能正确过滤中文标点符号
- IdGenerator生成的ID具有唯一性
- Validator能正确验证诗词和题目数据格式

**子任务**：

### 3.1 实现StringUtils工具类
- 实现 `filterPunctuation(text: string)` 方法，过滤中文标点
- 实现 `countChars(text: string)` 方法，计算字符数（不含标点）
- 实现 `toCharArray(text: string)` 方法，字符串转字符数组（过滤标点）
- 定义中文标点正则表达式：`/[，。、；：？！""''《》【】（）—…·\s]/g`

### 3.2 实现IdGenerator工具类
- 实现 `generate()` 静态方法，生成唯一ID
- ID格式：`${Date.now()}_${Math.random().toString(36).substr(2, 9)}`

### 3.3 实现Validator工具类
- 实现 `validatePoem(data: unknown)` 方法，验证诗词数据
- 实现 `validateQuestion(data: unknown)` 方法，验证题目数据
- 实现 `validateCategory(data: unknown)` 方法，验证分类数据
- 实现私有辅助方法 `isObject(value: unknown)`

**代码生成提示**：
```
在utils目录下创建StringUtils.ets、IdGenerator.ets、Validator.ets文件，
使用ArkTS的class和static语法定义工具类方法，
StringUtils使用正则表达式处理中文标点，
Validator返回Result<T>类型确保类型安全。
```

---

## 任务 4：数据访问层实现

**任务描述**：实现Repository层，封装数据存储和读取逻辑。

**输入**：
- 设计文档第5节数据访问层设计
- 设计文档第2节数据存储方案

**输出**：
- `repositories/BaseRepository.ets` - 基础仓储类
- `repositories/PoemRepository.ets` - 诗词仓储
- `repositories/QuestionRepository.ets` - 题目仓储
- `repositories/CategoryRepository.ets` - 分类仓储

**验收标准**：
- Repository能正确读写Preferences数据
- 首次运行时能从RawFile加载初始数据
- 数据持久化正常工作

**子任务**：

### 4.1 实现BaseRepository基类
- 定义 `IRepository<T>` 通用接口
- 实现 `initDataFromRawFile()` 方法，从RawFile加载初始数据
- 实现 `saveToPreferences()` 方法，保存数据到Preferences
- 实现 `loadFromPreferences()` 方法，从Preferences加载数据
- 实现数据初始化流程：检查Preferences → 有则加载 → 无则从RawFile加载并保存

### 4.2 实现PoemRepository
- 继承BaseRepository<Poem>
- 实现 `getAll()` 获取所有诗词
- 实现 `getById(id: string)` 根据ID获取诗词
- 实现 `add(poem: Poem)` 添加诗词
- 实现 `update(poem: Poem)` 更新诗词
- 实现 `delete(id: string)` 删除诗词
- 实现 `findByVerse(verse: string)` 根据诗句查找诗词

### 4.3 实现QuestionRepository
- 继承BaseRepository<Question>
- 实现所有CRUD方法
- 实现 `getByCategory(categoryId: string)` 根据分类获取题目
- 实现 `getRandom()` 随机获取一道题目（使用Fisher-Yates洗牌算法）

### 4.4 实现CategoryRepository
- 继承BaseRepository<Category>
- 实现所有CRUD方法

**代码生成提示**：
```
在repositories目录下创建各仓储类文件，
使用@ohos.data.preferences API进行本地存储，
使用@ohos.resourceManager读取RawFile资源，
实现数据初始化流程，确保首次运行时加载初始数据。
```

---

## 任务 5：服务层实现

**任务描述**：实现核心业务逻辑服务层。

**输入**：
- 设计文档第4节核心服务设计
- Repository层实现

**输出**：
- `services/PoemService.ets` - 诗词服务
- `services/QuestionService.ets` - 题目服务
- `services/CategoryService.ets` - 分类服务
- `services/GameService.ets` - 游戏服务
- `services/DataService.ets` - 数据导入导出服务

**验收标准**：
- 所有服务方法返回 `Result<T>` 类型
- GameService的反馈计算算法正确
- 服务层正确调用Repository层

**子任务**：

### 5.1 实现PoemService
- 实现 `getAllPoems()` 获取所有诗词
- 实现 `getPoemById(id)` 根据ID获取诗词
- 实现 `searchPoems(keyword)` 搜索诗词（支持标题、作者、内容搜索）
- 实现 `addPoem(poem)` 添加诗词（检查重复）
- 实现 `updatePoem(poem)` 更新诗词
- 实现 `deletePoem(id)` 删除诗词
- 实现 `containsVerse(verse)` 检查诗句是否在诗词库中
- 实现 `findPoemByVerse(verse)` 根据诗句查找诗词

### 5.2 实现QuestionService
- 实现所有CRUD方法
- 实现 `getRandomQuestion()` 随机选择题目
- 实现 `setDifficulty(id, difficulty)` 设置难度
- 实现 `assignToCategory(questionId, categoryId)` 分配到分类
- 实现 `removeFromCategory(questionId, categoryId)` 从分类移除

### 5.3 实现CategoryService
- 实现所有CRUD方法
- 实现 `getCategoriesWithCount()` 获取分类及其题目数量

### 5.4 实现GameService（核心）
- 实现 `startNewGame()` 开始新游戏
  - 从QuestionService获取随机题目
  - 从PoemService获取对应诗词
  - 生成提示信息
  - 初始化游戏会话
- 实现 `submitGuess(input, session)` 提交猜测
  - 验证输入非空
  - 过滤标点符号
  - 检查字数是否正确
  - 检查是否在诗词库中
  - 计算反馈
  - 更新游戏状态
- 实现 `calculateFeedback(guess, answer)` 计算反馈（核心算法）
  - 第一遍遍历：标记正确位置（绿色）
  - 第二遍遍历：标记错误位置（黄色）或不存在（灰色）
  - 处理重复字符的优先级
- 实现 `generateHint(poem, verseIndex)` 生成提示信息
  - 计算上一句字数
  - 计算当前句字数
  - 计算下一句字数

### 5.5 实现DataService
- 实现 `exportData()` 导出数据
  - 获取所有诗词和题目
  - 生成JSON格式数据
  - 返回导出结果
- 实现 `importData(data)` 导入数据
  - 验证数据格式
  - 批量添加诗词和题目
  - 返回导入统计
- 实现 `validateData(data)` 验证数据格式

**代码生成提示**：
```
在services目录下创建各服务类文件，
服务类依赖注入Repository实例，
所有方法返回Result<T>类型，
GameService的calculateFeedback方法实现Wordle式反馈算法，
使用StringUtils过滤标点，使用Validator验证数据。
```

---

## 任务 6：ViewModel层实现

**任务描述**：实现视图模型层，管理UI状态和业务逻辑调用。

**输入**：
- 设计文档第8节状态管理设计
- 服务层实现

**输出**：
- `viewmodels/GameViewModel.ets` - 游戏视图模型
- `viewmodels/ManageViewModel.ets` - 管理视图模型

**验收标准**：
- ViewModel正确管理状态
- ViewModel正确调用服务层
- 状态更新能触发UI响应

**子任务**：

### 6.1 实现GameViewModel
- 定义 `state: GamePageState` 状态属性
- 实现 `startNewGame()` 开始新游戏
- 实现 `submitGuess()` 提交猜测
- 实现 `resetGame()` 重置游戏
- 实现 `setInputText(text)` 设置输入文本
- 实现 `toggleRules()` 切换规则显示
- 实现 `getState()` 获取当前状态
- 依赖注入：GameService, PoemService, QuestionService

### 6.2 实现ManageViewModel
- 定义 `state: ManagePageState` 状态属性
- 实现 `setActiveTab(tab)` 切换标签页
- 实现 `loadPoems()` 加载诗词列表
- 实现 `loadQuestions()` 加载题目列表
- 实现 `loadCategories()` 加载分类列表
- 实现 `search(keyword)` 搜索
- 实现 `addPoem(poem)` 添加诗词
- 实现 `updatePoem(poem)` 更新诗词
- 实现 `deletePoem(id)` 删除诗词
- 实现题目和分类的类似管理方法
- 实现 `exportData()` 导出数据
- 实现 `importData(data)` 导入数据

**代码生成提示**：
```
在viewmodels目录下创建GameViewModel.ets和ManageViewModel.ets文件，
使用@Observed装饰器标记状态对象，
通过构造函数依赖注入服务实例，
所有异步操作使用async/await，
状态更新后通知UI刷新。
```

---

## 任务 7：公共UI组件实现

**任务描述**：实现可复用的公共UI组件。

**输入**：
- 设计文档第6节UI组件设计

**输出**：
- `components/common/AppTitleBar.ets` - 标题栏组件
- `components/common/LoadingDialog.ets` - 加载对话框
- `components/common/ConfirmDialog.ets` - 确认对话框
- `components/common/Toast.ets` - 提示消息组件

**验收标准**：
- 组件样式符合设计规范
- 组件可复用且可配置
- 组件响应式适配

**子任务**：

### 7.1 实现AppTitleBar组件
- 接收属性：title（标题）、showBack（是否显示返回按钮）、onBackClick（返回回调）
- 显示标题文字
- 可选显示返回按钮
- 可选显示右侧操作按钮

### 7.2 实现LoadingDialog组件
- 接收属性：visible（是否显示）、message（加载提示）
- 显示加载动画和提示文字
- 阻止用户交互

### 7.3 实现ConfirmDialog组件
- 接收属性：visible、title、message、onConfirm、onCancel
- 显示确认对话框
- 包含确认和取消按钮

### 7.4 实现Toast组件
- 接收属性：message、duration
- 显示短暂提示消息
- 自动消失

**代码生成提示**：
```
在components/common目录下创建各组件文件，
使用@Component装饰器定义组件，
使用@Prop接收外部属性，
使用@Link实现双向绑定，
样式使用ArkUI的链式调用语法。
```

---

## 任务 8：游戏UI组件实现

**任务描述**：实现游戏相关的UI组件。

**输入**：
- 设计文档第6.3节核心UI组件接口
- 设计文档第7.1节游戏主页面布局

**输出**：
- `components/game/FeedbackChar.ets` - 反馈字符组件
- `components/game/GuessHistory.ets` - 猜测历史组件
- `components/game/GuessInput.ets` - 猜测输入组件
- `components/game/GameStatus.ets` - 游戏状态组件
- `components/game/HintDisplay.ets` - 提示显示组件
- `components/game/GameResult.ets` - 游戏结果组件

**验收标准**：
- FeedbackChar正确显示三种颜色状态
- GuessHistory正确显示历史记录
- 组件交互响应正确

**子任务**：

### 8.1 实现FeedbackChar组件
- 接收属性：char（字符）、status（反馈状态）
- 根据status显示对应背景颜色
- 正确：绿色（#22C55E）
- 错误位置：黄色（#EAB308）
- 不存在：灰色（#6B7280）
- 字符居中显示，白色字体

### 8.2 实现GuessHistory组件
- 接收属性：history（GuessRecord数组）
- 使用List组件显示历史记录
- 每条记录使用Row横向排列FeedbackChar
- 支持滚动查看

### 8.3 实现GuessInput组件
- 接收属性：text（输入文本）、onTextChange（文本变化回调）、onSubmit（提交回调）、disabled（是否禁用）
- 显示TextInput输入框
- 显示"猜测"按钮
- 输入框支持回车提交
- 禁用状态下不可输入

### 8.4 实现GameStatus组件
- 接收属性：remainingGuesses（剩余次数）、totalGuesses（总次数）
- 显示剩余猜测次数
- 显示进度条或进度指示

### 8.5 实现HintDisplay组件
- 接收属性：hint（HintInfo对象）
- 显示上一句字数
- 显示当前句字数
- 显示下一句字数
- 格式：上句: X字 | 本句: Y字 | 下句: Z字

### 8.6 实现GameResult组件
- 接收属性：isSuccess（是否成功）、guessCount（猜测次数）、answer（正确答案）、onNewGame（新游戏回调）
- 成功时显示祝贺信息和猜测次数
- 失败时显示正确答案
- 显示"开始新游戏"按钮

**代码生成提示**：
```
在components/game目录下创建各组件文件，
FeedbackChar使用Colors常量设置背景色，
GuessHistory使用List和ForEach渲染历史记录，
GuessInput使用TextInput和Button组件，
所有组件使用@Prop接收只读属性，@Link接收双向绑定属性。
```

---

## 任务 9：管理UI组件实现

**任务描述**：实现数据管理相关的UI组件。

**输入**：
- 设计文档第7.2节管理页面布局

**输出**：
- `components/manage/PoemList.ets` - 诗词列表组件
- `components/manage/PoemEditor.ets` - 诗词编辑组件
- `components/manage/QuestionList.ets` - 题目列表组件
- `components/manage/QuestionEditor.ets` - 题目编辑组件
- `components/manage/CategoryList.ets` - 分类列表组件

**验收标准**：
- 列表组件正确显示数据
- 编辑组件正确处理输入
- 增删改操作正确触发

**子任务**：

### 9.1 实现PoemList组件
- 接收属性：poems（诗词数组）、onEdit（编辑回调）、onDelete（删除回调）
- 使用List组件显示诗词列表
- 每项显示：标题 - 作者 (朝代)
- 右侧显示编辑和删除按钮

### 9.2 实现PoemEditor组件
- 接收属性：poem（编辑时传入）、onSave（保存回调）、onCancel（取消回调）
- 显示标题输入框
- 显示作者输入框
- 显示朝代输入框
- 显示诗句输入区（多行，每行一句）
- 显示保存和取消按钮

### 9.3 实现QuestionList组件
- 接收属性：questions（题目数组）、poems（诗词数组用于显示关联）、onEdit、onDelete
- 使用List组件显示题目列表
- 每项显示：诗句内容、难度、所属诗词
- 右侧显示编辑和删除按钮

### 9.4 实现QuestionEditor组件
- 接收属性：question（编辑时传入）、poems（诗词列表）、categories（分类列表）、onSave、onCancel
- 显示诗句内容输入框
- 显示诗词选择下拉框
- 显示难度选择（1-5）
- 显示分类多选
- 显示保存和取消按钮

### 9.5 实现CategoryList组件
- 接收属性：categories（分类数组）、onEdit、onDelete
- 使用List组件显示分类列表
- 每项显示：分类名称、描述
- 右侧显示编辑和删除按钮

**代码生成提示**：
```
在components/manage目录下创建各组件文件，
列表组件使用List和ForEach渲染，
编辑组件使用TextInput、TextArea、Select等输入组件，
使用@State管理组件内部状态，
保存时验证数据有效性。
```

---

## 任务 10：游戏规则组件实现

**任务描述**：实现游戏规则说明组件。

**输入**：
- 需求规格说明中的游戏规则

**输出**：
- `components/rules/GameRules.ets` - 游戏规则组件

**验收标准**：
- 规则说明清晰完整
- 包含颜色图例说明
- 支持关闭操作

**子任务**：

### 10.1 实现GameRules组件
- 接收属性：visible（是否显示）、onClose（关闭回调）
- 显示游戏规则说明：
  - 系统随机选择诗句作为答案
  - 显示上下句字数提示
  - 输入猜测诗句
  - 颜色反馈机制说明
  - 20次猜测机会
- 显示颜色图例：
  - 绿色：位置正确
  - 黄色：存在但位置错误
  - 灰色：不存在
- 显示关闭按钮

**代码生成提示**：
```
在components/rules目录下创建GameRules.ets文件，
使用Column和Row布局，
使用Text组件显示规则文字，
使用三个带颜色的方块显示颜色图例，
使用自定义弹窗或全屏遮罩显示。
```

---

## 任务 11：页面实现

**任务描述**：实现所有页面，整合组件和ViewModel。

**输入**：
- 设计文档第7节页面设计
- 所有组件实现
- ViewModel实现

**输出**：
- `pages/Index.ets` - 入口页面
- `pages/GamePage.ets` - 游戏页面
- `pages/ManagePage.ets` - 管理页面

**验收标准**：
- 页面布局符合设计
- 页面正确使用ViewModel
- 页面导航正常工作

**子任务**：

### 11.1 实现Index入口页面
- 作为应用入口
- 初始化ViewModel和Service
- 跳转到GamePage

### 11.2 实现GamePage游戏页面
- 使用@Entry和@Component装饰器
- 初始化GameViewModel
- 使用@State管理session和inputText
- 布局结构：
  - AppTitleBar（标题栏，包含规则和管理按钮）
  - GameStatus（游戏状态）
  - HintDisplay（提示显示）
  - GuessHistory（猜测历史）
  - GuessInput（输入区域）
  - 开始新游戏按钮
- 实现交互逻辑：
  - 点击猜测按钮调用viewModel.submitGuess()
  - 点击新游戏调用viewModel.startNewGame()
  - 点击规则显示GameRules组件
  - 点击管理跳转到ManagePage
- 页面生命周期：
  - aboutToAppear时自动开始新游戏

### 11.3 实现ManagePage管理页面
- 使用@Entry和@Component装饰器
- 初始化ManageViewModel
- 使用@State管理页面状态
- 布局结构：
  - AppTitleBar（标题栏，包含返回按钮）
  - Tabs组件（诗词库、题库、分类）
  - 搜索框和添加按钮
  - 数据列表（PoemList/QuestionList/CategoryList）
  - 导入导出按钮
- 实现交互逻辑：
  - 切换标签页加载对应数据
  - 点击添加显示编辑组件
  - 点击编辑显示编辑组件
  - 点击删除显示确认对话框
  - 点击导入触发文件选择
  - 点击导出生成JSON文件

**代码生成提示**：
```
在pages目录下创建各页面文件，
使用@Entry装饰器标记入口页面，
使用@State管理响应式状态，
页面aboutToAppear生命周期中初始化数据，
使用router.pushUrl()进行页面导航，
整合所有组件构建完整页面布局。
```

---

## 任务 12：初始数据准备与集成测试

**任务描述**：准备初始诗词和题目数据，进行集成测试。

**输入**：
- 原项目的poems.json和questions.json

**输出**：
- `resources/rawfile/poems.json` - 初始诗词数据
- `resources/rawfile/questions.json` - 初始题目数据
- 集成测试验证

**验收标准**：
- 初始数据格式正确
- 应用能正常加载初始数据
- 完整游戏流程可运行

**子任务**：

### 12.1 准备初始诗词数据
- 转换原项目poems.json为ArkTS格式
- 确保数据结构符合Poem接口定义
- 包含至少50首经典诗词
- 放置到resources/rawfile/poems.json

### 12.2 准备初始题目数据
- 转换原项目questions.json为ArkTS格式
- 确保数据结构符合Question接口定义
- 每道题目关联正确的诗词ID
- 设置合理的难度等级
- 放置到resources/rawfile/questions.json

### 12.3 集成测试
- 测试应用启动流程
- 测试游戏完整流程：开始→猜测→反馈→结束
- 测试数据管理流程：添加→编辑→删除→保存
- 测试数据导入导出
- 测试异常情况处理

### 12.4 性能验证
- 验证反馈计算在500ms内完成
- 验证随机选题在100ms内完成
- 验证列表滚动流畅

**代码生成提示**：
```
将原项目的JSON数据转换为符合新类型定义的格式，
确保所有ID唯一且关联正确，
放置到resources/rawfile目录下，
运行应用进行完整功能测试，
验证所有EARS验收标准。
```

---

## 任务依赖关系

```
任务1（项目搭建）
    │
    ├──→ 任务2（类型定义）
    │        │
    │        └──→ 任务3（工具类）
    │                 │
    │                 └──→ 任务4（Repository）
    │                          │
    │                          └──→ 任务5（Service）
    │                                   │
    │                                   └──→ 任务6（ViewModel）
    │                                            │
    └──→ 任务7（公共组件）                        │
             │                                   │
             ├──→ 任务8（游戏组件）               │
             │        │                          │
             │        └──→ 任务11（页面）←────────┘
             │
             ├──→ 任务9（管理组件）
             │        │
             │        └──→ 任务11（页面）
             │
             └──→ 任务10（规则组件）
                      │
                      └──→ 任务11（页面）

任务11（页面）
    │
    └──→ 任务12（数据与测试）
```

---

## 执行建议

### 推荐执行顺序

1. **第一阶段（基础）**：任务1 → 任务2 → 任务3
2. **第二阶段（数据层）**：任务4 → 任务5
3. **第三阶段（UI层）**：任务7 → 任务8 → 任务9 → 任务10
4. **第四阶段（整合）**：任务6 → 任务11
5. **第五阶段（验证）**：任务12

### 关键里程碑

- **里程碑1**：完成任务1-3，项目基础架构就绪
- **里程碑2**：完成任务4-5，数据层和服务层可用
- **里程碑3**：完成任务7-10，所有UI组件就绪
- **里程碑4**：完成任务6和11，应用可运行
- **里程碑5**：完成任务12，应用功能完整验证通过

---

## 需求追溯矩阵

| 需求ID | 对应任务 |
|--------|----------|
| EARS-001~003 | 任务5.4, 任务11.2 |
| EARS-004~006 | 任务5.4, 任务8.3 |
| EARS-007~009 | 任务5.4 |
| EARS-010~013 | 任务5.4, 任务8.1 |
| EARS-014~016 | 任务5.4, 任务8.4 |
| EARS-017~020 | 任务8.4, 任务8.6 |
| EARS-021~023 | 任务5.2, 任务9.4 |
| EARS-024~025 | 任务9.4 |
| EARS-026~027 | 任务5.2, 任务9.3 |
| EARS-028~029 | 任务5.2 |
| EARS-030~033 | 任务5.2, 任务5.3 |
| EARS-034~035 | 任务5.1, 任务9.2 |
| EARS-036~037 | 任务9.2 |
| EARS-038~039 | 任务5.1, 任务9.1 |
| EARS-040~041 | 任务5.1 |
| EARS-042~043 | 任务5.5, 任务11.3 |
| EARS-044~046 | 任务5.5, 任务11.3 |
| EARS-047~049 | 任务11.2 |
| EARS-050~051 | 任务11.3 |
| EARS-052~053 | 任务7, 任务8, 任务9 |
| EARS-054~055 | 任务5.4, 任务12.4 |
| EARS-056~057 | 任务10.1 |
| EARS-058~059 | 任务4, 任务5.5 |
| EARS-060~061 | 任务7, 任务2.5 |
