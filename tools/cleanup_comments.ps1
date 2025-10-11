Param(
  [string]$Root = "lib"
)

Write-Host "[cleanup] Starting cleanup under: $Root"

function Remove-BlockComments {
  param([string]$content)
  # Remove /* ... */ across file (singleline mode to allow dot to match newlines)
  return [Regex]::Replace($content, "/\*[\s\S]*?\*/", "", [System.Text.RegularExpressions.RegexOptions]::Singleline)
}

function Remove-LineCommentsExceptBang {
  param([string]$content)
  # Remove whole-line // comments that are NOT starting with //!
  $content = [Regex]::Replace($content, "(?m)^[ \t]*//(?!\!).*$", "")
  return $content
}

function Ensure-ClassHeaders {
  param([string[]]$lines)
  $result = New-Object System.Collections.Generic.List[string]
  for ($i=0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    # Match class definitions
    $m = [Regex]::Match($line, "^\s*class\s+([A-Za-z_]\w*)\b")
    if ($m.Success) {
      $className = $m.Groups[1].Value
      # Find previous non-empty non-whitespace line to check if it already has //!
      $prevIndex = $result.Count - 1
      $hasHeader = $false
      while ($prevIndex -ge 0) {
        $prevLine = $result[$prevIndex]
        if ($prevLine -match "^\s*$") { $prevIndex--; continue }
        if ($prevLine -match "^\s*//!\s*$className\s*$") { $hasHeader = $true }
        break
      }
      if (-not $hasHeader) {
        $result.Add("//! $className")
      }
    }
    $result.Add($line)
  }
  return ,$result.ToArray()
}

function Ensure-TopLevelFunctionHeaders {
  param([string[]]$lines)
  $result = New-Object System.Collections.Generic.List[string]
  for ($i=0; $i -lt $lines.Length; $i++) {
    $line = $lines[$i]
    # Skip declarations keywords
    if ($line -match "^\s*(class|enum|typedef|extension|mixin|import|export|part)\b") {
      $result.Add($line)
      continue
    }
    # Only consider top-level (no leading spaces)
    if ($line -match "^[^\s]" -and $line -match "^([A-Za-z_]\w*)\s*\([^;{}]*\)\s*\{") {
      $funcName = [Regex]::Match($line, "^([A-Za-z_]\w*)").Groups[1].Value
      # Check previous significant line for existing header
      $prevIndex = $result.Count - 1
      $hasHeader = $false
      while ($prevIndex -ge 0) {
        $prevLine = $result[$prevIndex]
        if ($prevLine -match "^\s*$") { $prevIndex--; continue }
        if ($prevLine -match ("^\s*//!\s*$funcName\s*$")) { $hasHeader = $true }
        break
      }
      if (-not $hasHeader) {
        $result.Add("//! $funcName")
      }
    }
    $result.Add($line)
  }
  return ,$result.ToArray()
}

$dartFiles = Get-ChildItem -Path $Root -Recurse -Include *.dart | Where-Object { -not $_.PSIsContainer }
$changed = @()
foreach ($f in $dartFiles) {
  $raw = Get-Content -Path $f.FullName -Raw
  $orig = $raw
  $raw = Remove-BlockComments -content $raw
  $raw = Remove-LineCommentsExceptBang -content $raw
  $lines = $raw -split "`r?`n"
  $lines = Ensure-ClassHeaders -lines $lines
  $lines = Ensure-TopLevelFunctionHeaders -lines $lines
  $new = ($lines -join "`r`n")
  if ($new -ne $orig) {
    Set-Content -Path $f.FullName -Value $new -NoNewline
    $changed += $f.FullName
    Write-Host "[cleanup] Updated: $($f.FullName)"
  }
}

Write-Host "[cleanup] Done. Files changed: $($changed.Count)"
