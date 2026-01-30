# Figma Design Validation with MCP

Guide for validating UI implementation against Figma designs using Figma MCP.

---

## Prerequisites

**Required:**
- Figma MCP server configured
- Access to Figma design files
- Figma URLs for components/pages

**Setup:**
```bash
# Install Figma MCP (follow official docs)
# Configure API token
# Verify access to design files
```

---

## Validation Workflow

### Step 1: Get Design Specifications

**Using Figma MCP:**
```
"Get the specifications for the primary button from Figma file at [URL]"

Response includes:
- Dimensions (width, height)
- Colors (background, text, border)
- Typography (font, size, weight)
- Spacing (padding, margin)
- Border radius
- States (default, hover, active, disabled)
```

### Step 2: Inspect Implementation

**Browser DevTools:**
1. Inspect element
2. Check computed styles
3. Verify dimensions
4. Compare colors (use color picker)
5. Check typography
6. Test interactive states

### Step 3: Document Discrepancies

**Create test case or bug:**
```
TC-UI-001: Primary Button Visual Validation

Design (Figma):
- Size: 120x40px
- Background: #0066FF
- Border-radius: 8px
- Font: 16px Medium #FFFFFF

Implementation:
- Size: 120x40px ✓
- Background: #0052CC ✗ (wrong shade)
- Border-radius: 8px ✓
- Font: 16px Regular #FFFFFF ✗ (wrong weight)

Status: FAIL
Bugs: BUG-234, BUG-235
```

---

## What to Validate

### Layout & Spacing
- [ ] Component dimensions
- [ ] Padding (all sides)
- [ ] Margins
- [ ] Grid alignment
- [ ] Responsive breakpoints
- [ ] Container max-width

**Example Query:**
```
"Extract spacing values for the card component from Figma"
```

### Typography
- [ ] Font family
- [ ] Font size
- [ ] Font weight
- [ ] Line height
- [ ] Letter spacing
- [ ] Text color
- [ ] Text alignment

**Example Query:**
```
"Get typography specifications for all heading levels from Figma design system"
```

### Colors
- [ ] Background colors
- [ ] Text colors
- [ ] Border colors
- [ ] Shadow colors
- [ ] Gradient values
- [ ] Opacity values

**Example Query:**
```
"List all color tokens used in the navigation component"
```

### Components
- [ ] Icon sizes and colors
- [ ] Button states
- [ ] Input field styling
- [ ] Checkbox/radio appearance
- [ ] Dropdown styling
- [ ] Card components

**Example Query:**
```
"Compare the implemented dropdown menu with Figma design at [URL]"
```

### Interactive States
- [ ] Default state
- [ ] Hover state
- [ ] Active/pressed state
- [ ] Focus state
- [ ] Disabled state
- [ ] Loading state
- [ ] Error state

---

## Common Discrepancies

### Typography Mismatches
- Wrong font weight (e.g., Regular instead of Medium)
- Incorrect font size
- Missing line-height
- Color hex codes off by a shade

### Spacing Issues
- Padding not matching
- Inconsistent margins
- Grid misalignment
- Component spacing varies

### Color Differences
- Hex values off (#0066FF vs #0052CC)
- Opacity not applied
- Gradient angles wrong
- Shadow colors incorrect

### Responsive Behavior
- Breakpoints don't match
- Mobile layout different
- Tablet view inconsistent
- Scaling not as designed

---

## Test Case Template

```markdown
## TC-UI-XXX: [Component] Visual Validation

**Figma Design:** [URL to specific component]

### Desktop (1920x1080)

**Layout:**
- [ ] Width: XXXpx
- [ ] Height: XXXpx
- [ ] Padding: XXpx XXpx XXpx XXpx
- [ ] Margin: XXpx

**Typography:**
- [ ] Font: [Family] [Weight]
- [ ] Size: XXpx
- [ ] Line-height: XXpx
- [ ] Color: #XXXXXX

**Colors:**
- [ ] Background: #XXXXXX
- [ ] Border: Xpx solid #XXXXXX
- [ ] Shadow: XXpx XXpx XXpx rgba(X,X,X,X)

**Interactive States:**
- [ ] Hover: [changes]
- [ ] Active: [changes]
- [ ] Focus: [changes]
- [ ] Disabled: [changes]

### Tablet (768px)
- [ ] [Responsive changes]

### Mobile (375px)
- [ ] [Responsive changes]

### Status
- [ ] PASS - All match
- [ ] FAIL - Discrepancies found
- [ ] BLOCKED - Design incomplete
```

---

## Figma MCP Queries

### Component Specifications
```
"Get complete specifications for the [component name] from Figma at [URL]"
"Extract all button variants from the design system"
"List typography styles defined in Figma"
```

### Color System
```
"Show me all color tokens in the Figma design system"
"What colors are used in the navigation bar design?"
"Get the exact hex values for primary, secondary, and accent colors"
```

### Spacing & Layout
```
"What are the padding values for the card component?"
"Extract grid specifications from the page layout"
"Get spacing tokens (8px, 16px, 24px, etc.)"
```

### Responsive Breakpoints
```
"What are the defined breakpoints in this Figma design?"
"Show mobile vs desktop layout differences for [component]"
```

---

## Bug Report for UI Discrepancies

```markdown
# BUG-XXX: [Component] doesn't match Figma design

**Severity:** Medium (UI)
**Type:** Visual

## Design vs Implementation

**Figma Design:** [URL]

**Expected (from Figma):**
- Button background: #0066FF
- Font weight: 600 (Semi-bold)
- Padding: 12px 24px

**Actual (in implementation):**
- Button background: #0052CC ❌
- Font weight: 400 (Regular) ❌
- Padding: 12px 24px ✓

## Screenshots

- Figma design: [attach]
- Current implementation: [attach]
- Side-by-side comparison: [attach]

## Impact

Users see inconsistent branding. Button appears less prominent than designed.
```

---

## Automation Ideas

### Visual Regression Testing
- Capture screenshots
- Compare against Figma exports
- Highlight pixel differences
- Tools: Percy, Chromatic, BackstopJS

### Design Token Validation
- Extract Figma design tokens
- Compare with CSS variables
- Flag mismatches
- Automate with scripts

---

## Best Practices

**DO:**
- ✅ Always reference specific Figma URLs
- ✅ Test all component states
- ✅ Check responsive breakpoints
- ✅ Document exact values (not "close enough")
- ✅ Screenshot both design and implementation
- ✅ Test in multiple browsers

**DON'T:**
- ❌ Assume "it looks right"
- ❌ Skip hover/active states
- ❌ Ignore small color differences
- ❌ Test only on one screen size
- ❌ Forget to check typography
- ❌ Miss spacing issues

---

## Checklist for UI Test Cases

Per component:
- [ ] Figma URL documented
- [ ] Desktop layout validated
- [ ] Mobile/tablet responsive checked
- [ ] All interactive states tested
- [ ] Colors match exactly (use color picker)
- [ ] Typography specifications correct
- [ ] Spacing (padding/margins) accurate
- [ ] Icons match design
- [ ] Shadows/borders match
- [ ] Animations match timing/easing

---

## Quick Reference

| Element | What to Check | Tool |
|---------|---------------|------|
| Colors | Hex values exact | Browser color picker |
| Spacing | Padding/margin px | DevTools computed styles |
| Typography | Font, size, weight | DevTools font panel |
| Layout | Width, height, position | DevTools box model |
| States | Hover, active, focus | Manual interaction |
| Responsive | Breakpoint behavior | DevTools device mode |

---

**Remember:** Pixel-perfect implementation builds user trust and brand consistency.

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
