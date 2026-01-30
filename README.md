# Chloe QA Figma Planner

A Claude Code skill for QA engineers to create test plans, generate manual test cases, build regression test suites, validate designs against Figma, and document bugs effectively.

## Features

- **Test Plans** - Generate comprehensive test strategies with scope, schedule, and risks
- **Manual Test Cases** - Create step-by-step test cases with expected results
- **Regression Suites** - Build smoke tests, critical paths, and execution order
- **Figma Validation** - Compare UI implementation against Figma designs
- **Bug Reports** - Generate reproducible bug reports with evidence
- **Chrome DevTools Automation** - Auto-validate UI styles via Chrome debugging mode

## Installation

```bash
# Clone to your Claude skills directory
git clone https://github.com/chole995/chloe-qa-figma-planner.git ~/.claude/skills/chloe-qa-figma-planner
```

## Usage

### Quick Start

Activate the skill in Claude Code:

```
/chloe-qa-figma-planner
```

Or use the shortcut:

```
/qa <figma-node-id>                      # Generate test cases from Figma
/qa <figma-node-id> --test <url>         # Generate + validate implementation
/qa <module-name>                        # Use pre-configured module mapping
```

### Examples

**Create a test plan:**
```
"Create a test plan for the user authentication feature"
```

**Generate test cases:**
```
"Generate manual test cases for the checkout flow"
```

**Build regression suite:**
```
"Build a regression test suite for the payment module"
```

**Validate UI against Figma:**
```
"验收 http://localhost:3000/login 的 .btn-primary 按钮"
```

**Batch validation:**
```
"使用 config/my-project.json 批量验收"
```

**Create bug report:**
```
"Create a bug report for the form validation issue"
```

## Chrome DevTools Automation

### Prerequisites

Start Chrome with remote debugging:

```bash
# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222

# Windows
chrome.exe --remote-debugging-port=9222

# Linux
google-chrome --remote-debugging-port=9222
```

### What it checks

| Category | Properties |
|----------|------------|
| Dimensions | width, height, min/max-width, min/max-height |
| Colors | color, background-color, border-color |
| Typography | font-family, font-size, font-weight, line-height |
| Spacing | padding (t/r/b/l), margin (t/r/b/l) |
| Borders | border-width, border-style, border-radius |
| States | :hover, :active, :focus, :disabled |
| Effects | box-shadow, text-shadow, opacity, transform, transition, animation |

### Design Spec Sources

| Source | Description |
|--------|-------------|
| Figma MCP | Real-time specs from Figma |
| JSON File | Pre-exported design tokens |
| Manual Input | Interactive expected value entry |

## Module Mapping (Optional)

Configure frequently used modules in `~/.claude/skills/qa/modules.json`:

```json
{
  "login": {
    "figmaNodeId": "123:456",
    "figmaFileKey": "your-file-key",
    "testUrl": "http://localhost:3000/login",
    "description": "Login page"
  }
}
```

Then use directly:
```
/qa login        # Generate test cases for login page
/qa login --test # Generate + validate
```

## Quick Reference

| Task | What You Get | Time |
|------|--------------|------|
| Test Plan | Strategy, scope, schedule, risks | 10-15 min |
| Test Cases | Step-by-step instructions, expected results | 5-10 min each |
| Regression Suite | Smoke tests, critical paths, execution order | 15-20 min |
| Figma Validation | Design-implementation comparison, discrepancy list | 10-15 min |
| Bug Report | Reproducible steps, environment, evidence | 5 min |

## File Structure

```
chloe-qa-figma-planner/
├── SKILL.md                              # Main skill document
├── README.md                             # This file
├── config/
│   └── validation_config.example.json    # Batch validation config
├── templates/
│   └── validation_report.md              # Report template
├── scripts/
│   ├── batch_validate.sh                 # Batch validation script
│   ├── create_bug_report.sh              # Bug report generator
│   └── generate_test_cases.sh            # Test case generator
├── references/
│   ├── figma_validation.md               # Figma validation guide
│   ├── test_case_templates.md            # Test case formats
│   ├── bug_report_templates.md           # Bug report formats
│   └── regression_testing.md             # Regression testing guide
└── docs/
    └── plans/                            # Implementation plans
```

## Workflow

```
Figma Design → Generate Test Cases → Validate Implementation → Report
     │                │                      │                   │
     ▼                ▼                      ▼                   ▼
  Node ID      UI + Functional        Chrome DevTools       Markdown
              + Edge Cases            Style Comparison       Report
```

## Best Practices

### Test Case Writing
- Be specific and unambiguous
- Include expected results for each step
- Test one thing per test case
- Document preconditions

### Bug Reporting
- Provide clear reproduction steps
- Include screenshots/videos
- Specify exact environment details
- Link to Figma for UI bugs

### Regression Testing
- Prioritize critical paths
- Run smoke tests frequently
- Update suite after each release

## License

MIT
