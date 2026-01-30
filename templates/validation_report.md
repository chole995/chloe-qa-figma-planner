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
