# Chrome DevTools 自动化 UI 验收实现计划

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 为 qa-test-planner skill 添加 Chrome DevTools MCP 自动化 UI 验收功能

**Architecture:** 通过 Chrome DevTools MCP 连接本地 Chrome 调试端口 (9222)，自动获取元素 computed styles，与设计规格对比，生成 Markdown 报告 + 截图

**Tech Stack:** Chrome DevTools MCP, Figma MCP (可选), Bash scripts, Markdown

---

## Task 1: 创建报告模板

**Files:**
- Create: `templates/validation_report.md`

**Step 1: 创建 templates 目录**

```bash
mkdir -p /Users/chole/.claude/skills/qa-test-planner/templates
```

**Step 2: 写入报告模板**

创建 `/Users/chole/.claude/skills/qa-test-planner/templates/validation_report.md`:

```markdown
# UI 验收报告

**页面:** {{url}}
**时间:** {{timestamp}}
**状态:** {{status}}

---

{{#elements}}
## {{name}} (`{{selector}}`)

### 基础样式

| 属性 | 期望值 | 实际值 | 状态 |
|------|--------|--------|------|
{{#base_styles}}
| {{property}} | {{expected}} | {{actual}} | {{status}} |
{{/base_styles}}

{{#has_states}}
### 交互状态: {{state_name}}

| 属性 | 期望值 | 实际值 | 状态 |
|------|--------|--------|------|
{{#state_styles}}
| {{property}} | {{expected}} | {{actual}} | {{status}} |
{{/state_styles}}
{{/has_states}}

### 截图

{{#screenshots}}
![{{state}}]({{path}})
{{/screenshots}}

---
{{/elements}}

## 总结

- 通过: {{pass_count}} 项
- 不通过: {{fail_count}} 项
- 通过率: {{pass_rate}}%
```

**Step 3: 验证文件创建**

```bash
cat /Users/chole/.claude/skills/qa-test-planner/templates/validation_report.md
```

Expected: 模板内容显示

**Step 4: Commit**

```bash
cd /Users/chole/.claude/skills/qa-test-planner && git add templates/validation_report.md && git commit -m "feat(qa): add validation report template"
```

---

## Task 2: 创建配置示例文件

**Files:**
- Create: `config/validation_config.example.json`

**Step 1: 创建 config 目录**

```bash
mkdir -p /Users/chole/.claude/skills/qa-test-planner/config
```

**Step 2: 写入配置示例**

创建 `/Users/chole/.claude/skills/qa-test-planner/config/validation_config.example.json`:

```json
{
  "name": "Example Page Validation",
  "url": "http://localhost:3000",
  "chrome_debug_port": 9222,
  "output_dir": "./reports",
  "screenshot_dir": "./reports/screenshots",
  "design_source": {
    "type": "manual",
    "comment": "type can be: figma, json, manual"
  },
  "css_properties": {
    "base": [
      "width",
      "height",
      "min-width",
      "max-width",
      "min-height",
      "max-height",
      "color",
      "background-color",
      "border-color",
      "font-family",
      "font-size",
      "font-weight",
      "line-height",
      "padding-top",
      "padding-right",
      "padding-bottom",
      "padding-left",
      "margin-top",
      "margin-right",
      "margin-bottom",
      "margin-left",
      "border-width",
      "border-style",
      "border-radius"
    ],
    "effects": [
      "box-shadow",
      "text-shadow",
      "opacity",
      "transform",
      "transition-property",
      "transition-duration",
      "transition-timing-function",
      "animation-name",
      "animation-duration",
      "animation-timing-function"
    ]
  },
  "elements": [
    {
      "name": "主按钮",
      "selector": ".btn-primary",
      "states": ["default", "hover", "active", "focus", "disabled"],
      "screenshot": true,
      "expected": {
        "default": {
          "background-color": "#0066FF",
          "color": "#FFFFFF",
          "font-size": "16px",
          "padding": "12px 24px",
          "border-radius": "8px"
        },
        "hover": {
          "background-color": "#0052CC"
        }
      }
    },
    {
      "name": "输入框",
      "selector": "input[type='text']",
      "states": ["default", "focus"],
      "screenshot": true
    }
  ]
}
```

**Step 3: 验证文件创建**

```bash
cat /Users/chole/.claude/skills/qa-test-planner/config/validation_config.example.json | head -30
```

Expected: JSON 配置内容显示

**Step 4: Commit**

```bash
cd /Users/chole/.claude/skills/qa-test-planner && git add config/validation_config.example.json && git commit -m "feat(qa): add validation config example"
```

---

## Task 3: 更新 figma_validation.md 添加自动化流程

**Files:**
- Modify: `references/figma_validation.md`

**Step 1: 读取现有文件**

读取 `/Users/chole/.claude/skills/qa-test-planner/references/figma_validation.md`

**Step 2: 在文件末尾添加自动化章节**

在文件末尾 (最后一行之前) 添加:

```markdown

---

## Chrome DevTools 自动化验收

### 概述

使用 Chrome DevTools MCP 连接本地 Chrome 调试端口，自动获取元素的 computed styles 并与设计规格对比。

### 前置条件

1. **启动 Chrome 调试模式:**

```bash
# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222

# Linux
google-chrome --remote-debugging-port=9222

# Windows
"C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222
```

2. **确认连接:**
   - 打开 `http://localhost:9222/json` 应返回页面列表

### 自动化流程

```
┌─────────────────────────────────────────────────────────────┐
│ 1. 连接 Chrome (localhost:9222)                             │
│    mcp__chrome-devtools__list_pages                         │
│    mcp__chrome-devtools__select_page                        │
├─────────────────────────────────────────────────────────────┤
│ 2. 导航到目标页面                                            │
│    mcp__chrome-devtools__navigate_page                      │
├─────────────────────────────────────────────────────────────┤
│ 3. 获取页面快照，定位元素                                    │
│    mcp__chrome-devtools__take_snapshot                      │
├─────────────────────────────────────────────────────────────┤
│ 4. 获取元素 computed styles                                 │
│    mcp__chrome-devtools__evaluate_script                    │
│    window.getComputedStyle(element)                         │
├─────────────────────────────────────────────────────────────┤
│ 5. 触发交互状态                                              │
│    mcp__chrome-devtools__hover (hover 状态)                 │
│    mcp__chrome-devtools__click (active 状态)                │
│    mcp__chrome-devtools__fill + focus (focus 状态)          │
├─────────────────────────────────────────────────────────────┤
│ 6. 截取元素截图                                              │
│    mcp__chrome-devtools__take_screenshot                    │
├─────────────────────────────────────────────────────────────┤
│ 7. 对比 & 生成报告                                           │
│    期望值 vs 实际值 → Markdown 报告                         │
└─────────────────────────────────────────────────────────────┘
```

### 获取 Computed Styles 的脚本

```javascript
// 通过 mcp__chrome-devtools__evaluate_script 执行
(selector) => {
  const el = document.querySelector(selector);
  if (!el) return { error: 'Element not found' };

  const styles = window.getComputedStyle(el);
  const properties = [
    'width', 'height', 'min-width', 'max-width', 'min-height', 'max-height',
    'color', 'background-color', 'border-color',
    'font-family', 'font-size', 'font-weight', 'line-height',
    'padding-top', 'padding-right', 'padding-bottom', 'padding-left',
    'margin-top', 'margin-right', 'margin-bottom', 'margin-left',
    'border-width', 'border-style', 'border-radius',
    'box-shadow', 'text-shadow', 'opacity', 'transform',
    'transition-property', 'transition-duration', 'transition-timing-function',
    'animation-name', 'animation-duration', 'animation-timing-function'
  ];

  const result = {};
  properties.forEach(prop => {
    result[prop] = styles.getPropertyValue(prop);
  });
  return result;
}
```

### 交互状态触发

| 状态 | MCP 工具 | 说明 |
|------|----------|------|
| default | - | 初始状态，直接获取 |
| hover | `mcp__chrome-devtools__hover` | 悬停后获取样式 |
| active | `mcp__chrome-devtools__click` (不释放) | 点击按下状态 |
| focus | `mcp__chrome-devtools__click` → 元素获得焦点 | 聚焦状态 |
| disabled | 元素需有 `disabled` 属性 | 检查禁用样式 |

### 交互式元素选取

使用 `mcp__chrome-devtools__take_snapshot` 获取页面元素树，用户可以选择要验收的元素 uid，然后执行验收流程。

### 使用示例

**交互式验收:**

```
用户: 验收 http://localhost:3000/login 的 .btn-primary

Claude:
1. 连接 Chrome 9222 端口
2. 导航到页面
3. 获取 .btn-primary 的 computed styles
4. 模拟 hover/focus 等状态并获取样式
5. 截取各状态截图
6. 与期望值对比，生成报告
```

**批量验收:**

```
用户: 使用配置文件批量验收
配置: config/my-project.json

Claude:
1. 读取配置文件
2. 依次验收每个元素
3. 生成完整报告
```
```

**Step 3: 验证修改**

```bash
tail -50 /Users/chole/.claude/skills/qa-test-planner/references/figma_validation.md
```

Expected: 新增的自动化章节内容

**Step 4: Commit**

```bash
cd /Users/chole/.claude/skills/qa-test-planner && git add references/figma_validation.md && git commit -m "feat(qa): add Chrome DevTools automation workflow"
```

---

## Task 4: 更新 SKILL.md 添加自动化 UI 验收章节

**Files:**
- Modify: `SKILL.md`

**Step 1: 读取现有 SKILL.md**

读取文件，找到合适的插入位置 (在 Quick Reference 表格之后)

**Step 2: 在 Quick Reference 表格后添加新章节**

在 `| Bug Report | Reproducible steps, environment, evidence | 5 min |` 这行之后添加:

```markdown

---

## Automated UI Validation (Chrome DevTools)

> **NEW:** 使用 Chrome DevTools MCP 自动化 UI 验收，支持样式对比、交互状态检查、截图证据。

### 前置条件

启动 Chrome 调试模式:

```bash
# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222
```

### Quick Start

**交互式验收:**
```
"验收 http://localhost:3000/login 的 .btn-primary 按钮"
```

**批量验收 (配置文件):**
```
"使用 config/my-project.json 批量验收"
```

**交互选取元素:**
```
"打开 http://localhost:3000，让我选择要验收的元素"
```

### 检查内容

| 类别 | 属性 |
|------|------|
| 尺寸 | width, height, min/max-width, min/max-height |
| 颜色 | color, background-color, border-color |
| 字体 | font-family, font-size, font-weight, line-height |
| 间距 | padding (t/r/b/l), margin (t/r/b/l) |
| 边框 | border-width, border-style, border-radius |
| 交互状态 | :hover, :active, :focus, :disabled |
| 效果 | box-shadow, text-shadow, opacity, transform, transition, animation |

### 设计规格来源

| 来源 | 说明 |
|------|------|
| Figma MCP | 实时从 Figma 获取设计规格 |
| JSON 文件 | 预先导出的 design tokens |
| 手动输入 | 交互式填写期望值 |

### 配置文件示例

参见 `config/validation_config.example.json`

### 输出

- Markdown 验收报告
- 各状态截图
- 通过/不通过统计
```

**Step 3: 同时在 References 章节添加链接**

在 `- [Figma Validation Guide](references/figma_validation.md)` 之后添加:

```markdown
- [Validation Config Example](config/validation_config.example.json) - Batch validation configuration
- [Report Template](templates/validation_report.md) - Markdown report template
```

**Step 4: 验证修改**

```bash
grep -A 5 "Automated UI Validation" /Users/chole/.claude/skills/qa-test-planner/SKILL.md
```

Expected: 新章节标题显示

**Step 5: Commit**

```bash
cd /Users/chole/.claude/skills/qa-test-planner && git add SKILL.md && git commit -m "feat(qa): add automated UI validation section to SKILL.md"
```

---

## Task 5: 创建批量验收脚本

**Files:**
- Create: `scripts/batch_validate.sh`

**Step 1: 创建脚本文件**

创建 `/Users/chole/.claude/skills/qa-test-planner/scripts/batch_validate.sh`:

```bash
#!/bin/bash

# UI Batch Validation Script
# Usage: ./batch_validate.sh <config.json>

set -e

CONFIG_FILE="${1:-}"

if [ -z "$CONFIG_FILE" ]; then
  echo "Usage: $0 <config.json>"
  echo ""
  echo "Example:"
  echo "  $0 ./config/my-project.json"
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Config file not found: $CONFIG_FILE"
  exit 1
fi

echo "═══════════════════════════════════════════════════════"
echo "  UI Batch Validation"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "Config: $CONFIG_FILE"
echo ""

# Parse config
NAME=$(jq -r '.name' "$CONFIG_FILE")
URL=$(jq -r '.url' "$CONFIG_FILE")
PORT=$(jq -r '.chrome_debug_port // 9222' "$CONFIG_FILE")
OUTPUT_DIR=$(jq -r '.output_dir // "./reports"' "$CONFIG_FILE")
SCREENSHOT_DIR=$(jq -r '.screenshot_dir // "./reports/screenshots"' "$CONFIG_FILE")
ELEMENT_COUNT=$(jq '.elements | length' "$CONFIG_FILE")

echo "Name: $NAME"
echo "URL: $URL"
echo "Chrome Debug Port: $PORT"
echo "Output Dir: $OUTPUT_DIR"
echo "Elements to validate: $ELEMENT_COUNT"
echo ""

# Check Chrome debug port
echo "Checking Chrome debug port..."
if curl -s "http://localhost:$PORT/json" > /dev/null 2>&1; then
  echo "✓ Chrome debug port $PORT is accessible"
else
  echo "✗ Chrome debug port $PORT is not accessible"
  echo ""
  echo "Please start Chrome with remote debugging:"
  echo "  /Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --remote-debugging-port=$PORT"
  exit 1
fi

# Create output directories
mkdir -p "$OUTPUT_DIR"
mkdir -p "$SCREENSHOT_DIR"

echo ""
echo "───────────────────────────────────────────────────────"
echo "Ready for validation. Use Claude Code to execute:"
echo ""
echo "  验收配置文件: $CONFIG_FILE"
echo ""
echo "Claude will:"
echo "  1. Connect to Chrome at localhost:$PORT"
echo "  2. Navigate to $URL"
echo "  3. Validate $ELEMENT_COUNT elements"
echo "  4. Generate report in $OUTPUT_DIR"
echo "───────────────────────────────────────────────────────"
```

**Step 2: 添加执行权限**

```bash
chmod +x /Users/chole/.claude/skills/qa-test-planner/scripts/batch_validate.sh
```

**Step 3: 验证脚本**

```bash
/Users/chole/.claude/skills/qa-test-planner/scripts/batch_validate.sh
```

Expected: 显示 usage 信息

**Step 4: Commit**

```bash
cd /Users/chole/.claude/skills/qa-test-planner && git add scripts/batch_validate.sh && git commit -m "feat(qa): add batch validation script"
```

---

## Task 6: 添加 Deep Dive 章节到 SKILL.md

**Files:**
- Modify: `SKILL.md`

**Step 1: 在现有 Deep Dive 章节之后添加新的 Deep Dive**

在 `</details>` (最后一个 Deep Dive 之后，Examples 之前) 添加:

```markdown

<details>
<summary><strong>Deep Dive: Chrome DevTools Automation</strong></summary>

### 连接流程

```javascript
// 1. 列出所有页面
mcp__chrome-devtools__list_pages()

// 2. 选择页面
mcp__chrome-devtools__select_page({ pageId: 0 })

// 3. 导航到目标 URL
mcp__chrome-devtools__navigate_page({
  type: "url",
  url: "http://localhost:3000/login"
})

// 4. 获取页面快照
mcp__chrome-devtools__take_snapshot()
```

### 获取 Computed Styles

```javascript
mcp__chrome-devtools__evaluate_script({
  function: `(selector) => {
    const el = document.querySelector(selector);
    if (!el) return { error: 'Element not found' };

    const styles = window.getComputedStyle(el);
    const props = ['color', 'background-color', 'font-size', ...];

    const result = {};
    props.forEach(p => result[p] = styles.getPropertyValue(p));
    return result;
  }`,
  args: [{ value: ".btn-primary" }]
})
```

### 触发交互状态

**Hover:**
```javascript
// 从 snapshot 获取元素 uid
mcp__chrome-devtools__hover({ uid: "element-uid" })
// 再次获取 computed styles
```

**Focus:**
```javascript
mcp__chrome-devtools__click({ uid: "element-uid" })
// 或使用 evaluate_script 调用 element.focus()
```

**Active:**
```javascript
// 使用 evaluate_script 模拟 mousedown 事件
mcp__chrome-devtools__evaluate_script({
  function: `(selector) => {
    const el = document.querySelector(selector);
    el.dispatchEvent(new MouseEvent('mousedown', { bubbles: true }));
  }`,
  args: [{ value: ".btn-primary" }]
})
```

### 截图

```javascript
// 元素截图
mcp__chrome-devtools__take_screenshot({
  uid: "element-uid",
  filePath: "./reports/screenshots/btn-primary-default.png"
})

// 全页面截图
mcp__chrome-devtools__take_screenshot({
  fullPage: true,
  filePath: "./reports/screenshots/full-page.png"
})
```

### 颜色对比注意事项

- 浏览器返回 `rgb(0, 102, 255)` 而非 `#0066FF`
- 需要转换格式后对比
- 透明度会影响颜色值 (rgba)

### 常见问题

| 问题 | 原因 | 解决 |
|------|------|------|
| 连接失败 | Chrome 未开启调试模式 | 启动时加 `--remote-debugging-port=9222` |
| 元素找不到 | 选择器错误或页面未加载 | 使用 `wait_for` 等待元素 |
| 样式不一致 | 伪类状态未触发 | 使用 hover/click 触发状态 |
| 截图空白 | 元素不可见 | 检查元素是否在视口内 |

</details>
```

**Step 2: 验证添加**

```bash
grep -c "Deep Dive: Chrome DevTools Automation" /Users/chole/.claude/skills/qa-test-planner/SKILL.md
```

Expected: 1

**Step 3: Commit**

```bash
cd /Users/chole/.claude/skills/qa-test-planner && git add SKILL.md && git commit -m "feat(qa): add Chrome DevTools deep dive documentation"
```

---

## Task 7: 最终验证

**Step 1: 检查所有新增文件**

```bash
ls -la /Users/chole/.claude/skills/qa-test-planner/templates/
ls -la /Users/chole/.claude/skills/qa-test-planner/config/
ls -la /Users/chole/.claude/skills/qa-test-planner/scripts/
```

Expected: 所有新文件存在

**Step 2: 检查 git log**

```bash
cd /Users/chole/.claude/skills/qa-test-planner && git log --oneline -5
```

Expected: 显示所有 commit

**Step 3: 运行 batch_validate.sh 测试**

```bash
/Users/chole/.claude/skills/qa-test-planner/scripts/batch_validate.sh /Users/chole/.claude/skills/qa-test-planner/config/validation_config.example.json
```

Expected: 显示配置信息和 Chrome 连接检查

---

## 完成

实现完成后，qa-test-planner skill 将支持:

1. **交互式验收**: 指定 URL 和选择器，自动获取样式并对比
2. **批量验收**: 使用配置文件定义多个元素，一次性验收
3. **交互选取**: 从页面快照中选择要验收的元素
4. **多数据源**: 支持 Figma MCP / JSON 文件 / 手动输入期望值
5. **完整报告**: Markdown 格式，包含截图和通过率统计
