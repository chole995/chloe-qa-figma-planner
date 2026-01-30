# Chloe QA Figma Planner

基于 Figma 的自动化 QA 测试工具。一条指令完成全流程测试。

## 安装

```bash
git clone https://github.com/chole995/chloe-qa-figma-planner.git ~/.claude/skills/chloe-qa-figma-planner
```

## 使用

```
/qa <figma-node-id> <url>
```

### 示例

```
/qa 123:456 http://localhost:3000/login
```

## 你只需发送 3 条指令

| 步骤 | 你的指令 | 系统行为 |
|------|----------|----------|
| 1 | `/qa 123:456 http://localhost:3000/login` | 自动开始全部测试 |
| 2 | `测试结束` | 询问是否生成报告 |
| 3 | `是` | 生成测试报告 |

## 自动执行流程

```
/qa <figma-id> <url>
        │
        ▼
   提取 Figma 设计规格（自动）
        │
        ▼
   生成测试用例（自动）
        │
        ▼
   执行测试（自动 + 交互引导）
        │
        ▼
   等待你说"测试结束"
        │
        ▼
   生成测试报告
```

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

## 检查内容

| 类别 | 属性 |
|------|------|
| 尺寸 | width, height |
| 颜色 | color, background-color, border-color |
| 字体 | font-family, font-size, font-weight, line-height |
| 间距 | padding, margin |
| 边框 | border-width, border-radius |
| 交互状态 | :hover, :active, :focus, :disabled |

## License

MIT
