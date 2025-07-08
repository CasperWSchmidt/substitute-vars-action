# 🔤 Placeholder Substitution Action

Replaces text-based variable placeholders in files using environment variables.  
Supports multiple files and customizable patterns like `$(VAR)`, `${VAR}`, `#{VAR}`, or `<<VAR>>`.

---

## ✅ Features

- Replace placeholder variables with values from environment variables
- Works on Windows, Linux, and macOS GitHub runners
- Fully customizable prefix/suffix for placeholder format
- UTF-8 encoding (cross-platform safe)

---

## 🔧 Inputs
| Input    | Description                                 | Required | Default |
|----------|---------------------------------------------|----------|---------|
| `files`  | Newline-separated list of XML file paths    | ✅       |         |
| `prefix` | Prefix for placeholder (e.g., `#{`)         | ❌       | `#{`    |
| `suffix` | Suffix for placeholder (e.g., `}`)          | ❌       | `}`     |

---

## 🖥️ Compatibility
- ✅ ubuntu-latest
- ✅ windows-latest
- ✅ macos-latest
- 🔧 Requires PowerShell Core
- 🚫 Skips files that are not valid XML

---

## 📦 Example Use

```yaml
- name: Substitute placeholders in files
  uses: CasperWSchmidt/substitute-vars-action@v1
  with:
    files: |
      global.asax
      settings.config
    prefix: '${'
    suffix: '}'
```
If `MY_SETTING=Production`, then this line:
```xml
<add key="Environment" value="#{MY_SETTING}" />
```
...will become:
```xml
<add key="Environment" value="Production" />
```
