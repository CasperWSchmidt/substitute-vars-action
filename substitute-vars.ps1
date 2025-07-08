param (
  [string[]]$Files,
  [string]$Prefix = '#{',
  [string]$Suffix = '}'
)

Write-Host "🔄 Starting variable substitution with pattern: $Prefix<VAR>$Suffix"

$envVars = [System.Environment]::GetEnvironmentVariables()

foreach ($file in $Files) {
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
