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

Activate the skill in Claude Code:

```
/chloe-qa-figma-planner
```

### Examples

**Create a test plan:**
```
"Create a test plan for the user authentication feature"
```

**Validate UI against Figma:**
```
"验收 http://localhost:3000/login 的 .btn-primary 按钮"
```

**Batch validation:**
```
"使用 config/my-project.json 批量验收"
```

## Chrome DevTools Automation

### Prerequisites

Start Chrome with remote debugging:

```bash
# macOS
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222
```

### What it checks

| Category | Properties |
|----------|------------|
| Dimensions | width, height, min/max-width, min/max-height |
| Colors | color, background-color, border-color |
| Typography | font-family, font-size, font-weight, line-height |
| Spacing | padding, margin |
| Borders | border-width, border-style, border-radius |
| States | :hover, :active, :focus, :disabled |
| Effects | box-shadow, text-shadow, opacity, transform, transition, animation |

## File Structure

```
chloe-qa-figma-planner/
├── SKILL.md                 # Main skill document
├── config/
│   └── validation_config.example.json
├── templates/
│   └── validation_report.md
├── scripts/
│   ├── batch_validate.sh
│   ├── create_bug_report.sh
│   └── generate_test_cases.sh
└── references/
    ├── figma_validation.md
    ├── test_case_templates.md
    ├── bug_report_templates.md
    └── regression_testing.md
```

## License

MIT
