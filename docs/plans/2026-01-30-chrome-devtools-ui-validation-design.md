# Chrome DevTools 自动化 UI 验收设计

**日期:** 2026-01-30
**状态:** 待实现

---

## 概述

增强 qa-test-planner skill，通过 Chrome DevTools MCP（调试模式）自动化 UI 验收流程。连接本地 Chrome 实例，自动获取元素的 computed styles，与设计规格对比，生成 Markdown 报告。

---

## 整体架构

```
┌─────────────────────────────────────────────────────────────┐
│                     触发入口                                 │
│  ┌──────────────────┐    ┌──────────────────────────────┐   │
│  │ 交互式验收       │    │ 批量验收 (config.json)       │   │
│  │ "验收按钮样式"   │    │ ./scripts/batch_validate.sh  │   │
│  └────────┬─────────┘    └──────────────┬───────────────┘   │
└───────────┼─────────────────────────────┼───────────────────┘
            │                             │
            ▼                             ▼
┌─────────────────────────────────────────────────────────────┐
│                   设计规格获取                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────┐    │
│  │ Figma MCP   │ │ JSON 文件   │ │ 手动输入期望值      │    │
│  │ 实时拉取    │ │ design      │ │ (交互式填写)        │    │
│  │             │ │ tokens      │ │                     │    │
│  └─────────────┘ └─────────────┘ └─────────────────────┘    │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│              Chrome DevTools MCP (调试模式)                  │
│              连接 localhost:9222                             │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ 1. 导航到目标 URL                                        ││
│  │ 2. 定位元素 (选择器 / 交互选取)                          ││
│  │ 3. 获取 computed styles                                 ││
│  │ 4. 触发交互状态 (hover/focus/active)                    ││
│  │ 5. 截取元素截图                                          ││
│  └─────────────────────────────────────────────────────────┘│
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                    对比 & 报告生成                           │
│  ┌─────────────────────────────────────────────────────────┐│
│  │ • 逐属性对比 (期望值 vs 实际值)                          ││
│  │ • 标记 ✓ / ✗ 状态                                       ││
│  │ • 生成 Markdown 报告 + 截图                             ││
│  └─────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────┘
```

---

## 关键配置

- **Chrome 调试端口:** 9222
- **项目 URL:** 每个项目不同，验收时手动指定
- **元素选择:** CSS 选择器为主，也支持交互选取
- **报告格式:** Markdown

---

## 检查属性清单

### 基础样式

| 类别 | 属性 |
|------|------|
| 尺寸 | width, height, min/max-width, min/max-height |
| 颜色 | color, background-color, border-color |
| 字体 | font-family, font-size, font-weight, line-height |
| 间距 | padding (t/r/b/l), margin (t/r/b/l) |
| 边框 | border-width, border-style, border-radius |

### 交互状态

| 状态 | 说明 |
|------|------|
| :hover | 模拟鼠标悬停，获取样式变化 |
| :active | 模拟点击按下状态 |
| :focus | 模拟聚焦状态 |
| :disabled | 检查禁用状态样式 |

### 动画 & 效果

| 属性 | 说明 |
|------|------|
| box-shadow | 盒子阴影 |
| text-shadow | 文字阴影 |
| opacity | 透明度 |
| transform | 变换 |
| transition | 过渡 (duration, timing-function, property) |
| animation | 动画 (name, duration, timing-function) |

---

## 文件结构

```
qa-test-planner/
├── SKILL.md                          # 主文档 (更新)
├── references/
│   ├── figma_validation.md           # 更新：增加自动化流程说明
│   └── ...
├── scripts/
│   ├── generate_test_cases.sh        # 已有
│   ├── create_bug_report.sh          # 已有
│   └── batch_validate.sh             # 新增：批量验收脚本
├── templates/
│   └── validation_report.md          # 新增：报告模板
└── config/
    └── validation_config.example.json # 新增：批量验收配置示例
```

---

## 报告输出示例

```markdown
# UI 验收报告

**页面:** http://localhost:3000/login
**时间:** 2026-01-30 14:30:00
**状态:** ❌ 3 项不通过

---

## .btn-primary

### 基础样式

| 属性 | 期望值 | 实际值 | 状态 |
|------|--------|--------|------|
| background-color | #0066FF | #0066FF | ✓ |
| color | #FFFFFF | #FFFFFF | ✓ |
| font-size | 16px | 14px | ✗ |
| padding | 12px 24px | 12px 24px | ✓ |
| border-radius | 8px | 8px | ✓ |

### 交互状态: hover

| 属性 | 期望值 | 实际值 | 状态 |
|------|--------|--------|------|
| background-color | #0052CC | #0052CC | ✓ |
| transform | scale(1.02) | none | ✗ |

### 截图

![default](./screenshots/btn-primary-default.png)
![hover](./screenshots/btn-primary-hover.png)

---

## 总结

- 通过: 8 项
- 不通过: 3 项
- 通过率: 72.7%
```

---

## 批量验收配置

### 基本结构

```json
{
  "name": "Login Page Validation",
  "url": "http://localhost:3000/login",
  "chrome_debug_port": 9222,
  "output_dir": "./reports",
  "design_source": {
    "type": "figma",
    "file_url": "https://figma.com/file/xxx"
  },
  "elements": [
    {
      "name": "主按钮",
      "selector": ".btn-primary",
      "states": ["default", "hover", "active", "disabled"],
      "screenshot": true
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

### 设计规格来源

**Figma MCP:**

```json
{
  "design_source": {
    "type": "figma",
    "file_url": "https://figma.com/file/xxx"
  }
}
```

**JSON 文件:**

```json
{
  "design_source": {
    "type": "json",
    "path": "./design-tokens.json"
  }
}
```

**手动指定期望值:**

```json
{
  "elements": [
    {
      "name": "主按钮",
      "selector": ".btn-primary",
      "expected": {
        "default": {
          "background-color": "#0066FF",
          "font-size": "16px"
        },
        "hover": {
          "background-color": "#0052CC"
        }
      }
    }
  ]
}
```

---

## 使用方式

### 交互式验收

```
用户: 验收 http://localhost:3000/login 的 .btn-primary 按钮

Claude:
1. 连接 Chrome 调试端口 9222
2. 导航到页面
3. 定位元素
4. 请选择设计规格来源：
   - A. 从 Figma 获取 (输入 URL)
   - B. 从 JSON 文件读取 (输入路径)
   - C. 手动输入期望值
5. 获取实际样式 + 截图
6. 生成对比报告
```

### 批量验收

```bash
# 指定配置文件执行
./scripts/batch_validate.sh ./config/login-page.json

# 输出
✓ 连接 Chrome localhost:9222
✓ 导航到 http://localhost:3000/login
✓ 验收 .btn-primary (4 states)
✓ 验收 input[type='text'] (2 states)
✓ 截图已保存
✓ 报告已生成: ./reports/2026-01-30-login-validation.md
```

### 交互选取元素

```
用户: 我想选择页面上的元素验收

Claude:
1. 已开启元素选择模式
2. 请在浏览器中点击要验收的元素
3. [等待用户点击]
4. 已选中: button.submit-btn
5. 继续验收流程...
```

---

## 实现计划

### 1. 更新 SKILL.md

- 添加自动化 UI 验收章节
- 说明 Chrome 调试模式连接方式
- 添加使用示例

### 2. 更新 references/figma_validation.md

- 添加 Chrome DevTools MCP 自动化流程
- 更新属性检查清单

### 3. 新增文件

- `templates/validation_report.md` - 报告模板
- `config/validation_config.example.json` - 配置示例
- `scripts/batch_validate.sh` - 批量验收脚本

---

## 依赖

- Chrome DevTools MCP (`mcp__chrome-devtools__*`)
- Figma MCP (可选，用于获取设计规格)
