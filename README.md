# 🔤 Placeholder Substitution Action

This GitHub Action replaces placeholder variables in text-based config files using environment variables.

It supports patterns like:
- `$(VAR)`
- `${VAR}`
- `#{VAR}`
- `<<VAR>>`

---

## ✅ Features

- 🔁 Replaces variable placeholders with values from environment variables
- ✨ Customizable prefix and suffix (`${VAR}`, `$(VAR)`, etc.)
- ✨ Supports **glob patterns** like `**/*.asa`
- 🚫 Automatically deduplicates matched files
- 🛡️ Gracefully fails if no files match
- 🧾 Works with `.config`, `.asa`, `.env`, `.json`, etc.
- ⚙️ Fully cross-platform (Windows, Linux, macOS)

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
      deploy/global.asa
      deploy/**/*.config
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
