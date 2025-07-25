param (
  [string[]]$Files,
  [string]$Prefix = '#{',
  [string]$Suffix = '}'
)

Write-Host "🔄 Starting variable substitution with pattern: $Prefix<VAR>$Suffix"

$envVars = [System.Environment]::GetEnvironmentVariables()

Write-Host "🔄 Resolving file paths..."

# Expand all glob patterns (e.g., deploy/*.config)
# HashSet to store full paths (avoids duplicates)
$resolved = [System.Collections.Generic.HashSet[string]]::new()

foreach ($pattern in $Files) {
  $matches = Get-ChildItem -Path $pattern -File -Recurse -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
  if (-not $matches) {
    Write-Warning "⚠️ No matches found for pattern: $pattern"
  }

  foreach ($file in $matches) {
    $resolved.Add($file) | Out-Null
  }
}

if ($resolved.Count -eq 0) {
  Write-Error "❌ No valid files found. Exiting."
  exit 1
}

foreach ($file in $resolved) {
  if (-not (Test-Path $file)) {
    Write-Warning "⚠️ File not found: $file"
    continue
  }

  try {
    $content = Get-Content -Path $file -Raw

    foreach ($envVar in $envVars.Keys) {
      $name = [Regex]::Escape($envVar)
      $value = $envVars[$envVar]

      $pattern = [Regex]::Escape($Prefix) + $name + [Regex]::Escape($Suffix)
      $content = [Regex]::Replace($content, $pattern, [Regex]::Escape($value))
    }

    Set-Content -Path $file -Value $content -Encoding UTF8NoBOM
    Write-Host "✅ Updated file: $file"
  } catch {
    Write-Warning "⚠️ Error processing file: $file"
  }
}

Write-Host "✅ Substitution complete."
