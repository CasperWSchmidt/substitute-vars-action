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
- 🔠 Case-insensitive matching for variable names
- ✨ Supports **glob patterns** like `**/*.asa`
- 🚫 Automatically deduplicates matched files
- 🛡️ Fails cleanly if no files matched
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

---

## 🚀 Usage

Because GitHub Actions composite actions cannot directly access the `vars`, `inputs`, or `secrets` contexts, you must manually pass any required values through the `env` block (see example below).
Alternatively you can dump all variables as environment variables using the following script in a step before calling this action:

> ⚠️ **Warning:** Dumping all variables may expose sensitive information. Use with caution.

```yaml
- name: Export all GitHub vars
  run: |
    $json = '${{ toJson(vars) }}'
	$vars = ConvertFrom-Json $json
	foreach ($property in $vars.PSObject.Properties) {
	  $key = $property.Name
	  $value = $property.Value
	  Write-Host "Setting $key to $value"
	  $output = "${key}<<EOF`n${value}`nEOF" # Needed if any value contains a new-line (\r\n)
	  Add-Content -Path $Env:GITHUB_ENV -Value $output
    }
    Write-Host "Variables exported successfully."
```

### 🧪 Example workflow step setting environment variables manually

```yaml
- name: Substitute placeholders in files
  uses: CasperWSchmidt/substitute-vars-action@v1
  with:
    files: |
      deploy/global.asa
      deploy/**/*.config
    prefix: '${'
    suffix: '}'
  env: # required to pass variables into the action
    ENVIRONMENT: ${{ inputs.environment }}
    CONNECTION_STRING: ${{ secrets.MY_DATABASE_CONNECTION  }}
	ROOT_DIRECTORY: ${{ vars.MY_ROOT_DIRECTORY }}
```

### 🧪 Example workflow step using dynamic variable export

```yaml
- name: Export all GitHub vars
  run: |
    $json = '${{ toJson(vars) }}'
	$vars = ConvertFrom-Json $json
	foreach ($property in $vars.PSObject.Properties) {
	  $key = $property.Name
	  $value = $property.Value
	  Write-Host "Setting $key to $value"
	  $output = "${key}<<EOF`n${value}`nEOF" # Needed if any value contains a new-line (\r\n)
	  Add-Content -Path $Env:GITHUB_ENV -Value $output
    }
    Write-Host "Variables exported successfully."
	
- name: Substitute placeholders in files
  uses: CasperWSchmidt/substitute-vars-action@v1
  with:
    files: |
      deploy/global.asa
      deploy/**/*.config
    prefix: '${'
    suffix: '}'
```

### 🗂️ Example `web.config` (before)
```xml
<configuration>
  <appSettings>
    <add key="Environment" value="#{ENVIRONMENT}" />
    <add key="RootDirectory" value="#{ROOT_DIRECTORY}" />
  </appSettings>
  <connectionStrings>
    <add name="DefaultConnection" connectionString="#{CONNECTION_STRING}" />
  </connectionStrings>
</configuration>
```

### ✅ Result (after)
```xml
<configuration>
  <appSettings>
    <add key="Environment" value="Production" />
    <add key="RootDirectory" value="C:\Some\Path" />
  </appSettings>
  <connectionStrings>
    <add name="DefaultConnection" connectionString="Server=sql;Database=prod;User Id=admin;" />
  </connectionStrings>
</configuration>
```
