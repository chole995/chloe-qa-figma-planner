---
name: chloe-qa-figma-planner
description: 基于 Figma 自动化 QA 测试。用法：/qa <figma-id> <url>
trigger: explicit
---

# Chloe QA Figma Planner

一条指令完成：Figma 规格提取 → 生成用例 → 执行测试 → 引导交互 → 生成报告

## 用法

```
/qa <figma-node-id> <url>
```

## 示例

```
/qa 123:456 http://localhost:3000/login
```

---

## 你只需发送 3 条指令

| 步骤 | 你的指令 | 系统行为 |
|------|----------|----------|
| 1 | `/qa 123:456 http://localhost:3000/login` | 自动开始全部测试流程 |
| 2 | `测试结束` | 询问是否生成报告 |
| 3 | `是` | 生成测试报告 |

---

## 自动执行流程

收到 `/qa <figma-id> <url>` 后，**自动**执行：

### 1. 提取 Figma 设计规格

使用 Figma MCP 获取：
- 组件结构和层级
- 样式规格（颜色、字体、间距、尺寸）
- 交互状态（hover、active、disabled）

### 2. 自动生成测试用例

基于 Figma 规格生成：
- **UI 样式用例** - 颜色、字体、间距、尺寸对比
- **交互状态用例** - hover、focus、active 状态检查
- **功能用例** - 按钮点击、表单提交、导航跳转

### 3. 连接 Chrome DevTools 执行测试

自动连接 → 导航到 URL → 逐条执行用例 → 记录结果

### 4. 交互测试引导

遇到需要用户操作的测试时（如表单填写、登录）：

```
我: 现在需要测试登录功能，请在页面上输入测试账号并登录。
你: 好的，我输入了 test@example.com 和密码 Test123!
我: 已记录。登录后跳转到了 /dashboard，显示"欢迎回来"。测试通过 ✅
```

操作步骤会自动记录到测试用例的"测试数据"部分。

### 5. 等待结束信号

持续测试直到你说：
- "测试结束"
- "完成了"
- "生成报告"

### 6. 生成测试报告

确认后生成 Markdown 报告：
- 测试摘要（通过/失败/总数）
- 失败用例详情
- Figma vs 实现的差异
- 交互测试中记录的测试数据

---

## 输出示例

### 测试过程

```
正在从 Figma 获取设计规格...
✅ 已获取 15 个组件的设计规格

正在生成测试用例...
✅ 生成 8 个 UI 样式用例
✅ 生成 4 个交互状态用例
✅ 生成 3 个功能用例

正在连接 Chrome DevTools...
✅ 已连接，导航到 http://localhost:3000/login

执行测试用例：

TC-001: 主按钮样式 ✅
TC-002: 输入框样式 ✅
TC-003: 主按钮 hover 状态 ❌
  - 期望 background: #0052CC
  - 实际 background: #0066FF

TC-004: 登录功能
  → 请在页面上输入测试账号并登录...
```

### 测试报告

```markdown
# 测试报告: 登录页面

**Figma:** 123:456
**URL:** http://localhost:3000/login
**时间:** 2024-01-15 14:30

## 摘要

| 状态 | 数量 |
|------|------|
| ✅ 通过 | 12 |
| ❌ 失败 | 3 |
| 总计 | 15 |

## 失败用例

### TC-003: 主按钮 hover 状态

| 属性 | Figma | 实际 |
|------|-------|------|
| background | #0052CC | #0066FF |

## 交互测试数据

### 登录测试
- 账号: test@example.com
- 密码: Test123!
- 结果: 跳转到 /dashboard
```

---

## 前置条件

启动 Chrome 调试模式：

```bash
# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222

# Windows
chrome.exe --remote-debugging-port=9222

# Linux
google-chrome --remote-debugging-port=9222
```

---

## 检查内容

| 类别 | 属性 |
|------|------|
| 尺寸 | width, height |
| 颜色 | color, background-color, border-color |
| 字体 | font-family, font-size, font-weight, line-height |
| 间距 | padding, margin |
| 边框 | border-width, border-radius |
| 交互状态 | :hover, :active, :focus, :disabled |

---

## 参考资料

<details>
<summary><strong>测试用例模板</strong></summary>

```markdown
## TC-001: [测试用例标题]

**优先级:** P0 | P1 | P2
**类型:** UI | 功能 | 交互
**状态:** 未执行 | 通过 | 失败

### 前置条件
- [条件 1]
- [条件 2]

### 测试步骤
1. [操作]
   **预期:** [结果]

2. [操作]
   **预期:** [结果]

### 测试数据
- 账号: [由交互测试记录]
- 密码: [由交互测试记录]
```

</details>

<details>
<summary><strong>Bug 报告模板</strong></summary>

```markdown
# BUG-[ID]: [标题]

**严重程度:** Critical | High | Medium | Low
**环境:** Chrome 120 / macOS 14

## 复现步骤
1. [步骤]
2. [步骤]

## 期望行为
[描述]

## 实际行为
[描述]

## 截图
[附件]
```

</details>

<details>
<summary><strong>Chrome DevTools 自动化</strong></summary>

### 连接流程

```javascript
// 1. 列出页面
mcp__chrome-devtools__list_pages()

// 2. 选择页面
mcp__chrome-devtools__select_page({ pageId: 0 })

// 3. 导航
mcp__chrome-devtools__navigate_page({ type: "url", url: "..." })

// 4. 快照
mcp__chrome-devtools__take_snapshot()
```

### 获取样式

```javascript
mcp__chrome-devtools__evaluate_script({
  function: `(selector) => {
    const el = document.querySelector(selector);
    const styles = window.getComputedStyle(el);
    return {
      color: styles.color,
      backgroundColor: styles.backgroundColor,
      fontSize: styles.fontSize
    };
  }`,
  args: [{ value: ".btn-primary" }]
})
```

### 交互状态

```javascript
// Hover
mcp__chrome-devtools__hover({ uid: "element-uid" })

// Click
mcp__chrome-devtools__click({ uid: "element-uid" })

// 截图
mcp__chrome-devtools__take_screenshot({ uid: "element-uid" })
```

</details>
