[CmdletBinding(PositionalBinding = $false)]
param(
    [switch]$Check,
    [string[]]$Exclude = @(),
    [switch]$Help,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Paths = @()
)

Set-StrictMode -Version Latest

$EXIT_CLEAN = 0
$EXIT_CHANGES_NEEDED = 1
$EXIT_ERROR = 2

$REPLACEMENTS = @(
    @([string][char]0x2014, '-'),
    @([string][char]0x2013, '-'),
    @([string][char]0x2212, '-'),
    @([string][char]0x201C, '"'),
    @([string][char]0x201D, '"'),
    @([string][char]0x2018, "'"),
    @([string][char]0x2019, "'"),
    @([string][char]0x2026, '...'),
    @([string][char]0x00A0, ' '),
    @([string][char]0x202F, ' '),
    @([string][char]0x200B, ' '),
    @([string][char]0x2060, ' '),
    @([string][char]0xFEFF, '')
)

$StrictUtf8 = New-Object System.Text.UTF8Encoding($false, $true)
$IsVerbose = $PSBoundParameters.ContainsKey('Verbose')
$ExcludedNames = @('.git') + $Exclude
$script:ChangedCount = 0
$script:ErrorCount = 0

function Show-Usage([int]$Status) {
    Write-Output @'
Usage: normalize-text.ps1 [-Check] [-Verbose] [-Exclude NAME[,NAME...]] [PATH]

Recursively normalize UTF-8 text under PATH (default: current directory).
  -Check          List files that would change without writing; exits 1 if found
  -Verbose        List files as they are changed
  -Exclude NAME   Skip directories with this name; comma-separate for several
  -Help           Show this help
'@
    exit $Status
}

function Test-IsLink([System.IO.FileSystemInfo]$Item) {
    return [bool]($Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint)
}

function Invoke-NormalizeFile([string]$Path) {
    $stream = $null
    try {
        $access = if ($Check) { [System.IO.FileAccess]::Read } else { [System.IO.FileAccess]::ReadWrite }
        $share = if ($Check) { [System.IO.FileShare]::ReadWrite } else { [System.IO.FileShare]::None }
        $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, $access, $share)
    } catch {
        [Console]::Error.WriteLine("Cannot open ${Path}: $($_.Exception.Message)")
        $script:ErrorCount++
        return
    }

    try {
        $buffer = New-Object byte[] $stream.Length
        $read = 0
        while ($read -lt $buffer.Length) {
            $n = $stream.Read($buffer, $read, $buffer.Length - $read)
            if ($n -le 0) { break }
            $read += $n
        }

        if ([Array]::IndexOf($buffer, [byte]0) -ge 0) { return }

        try {
            $text = $StrictUtf8.GetString($buffer)
        } catch {
            return
        }

        $original = $text
        foreach ($pair in $REPLACEMENTS) {
            $text = $text.Replace($pair[0], $pair[1])
        }

        if ($text -ceq $original) { return }

        $script:ChangedCount++
        if ($Check -or $IsVerbose) { Write-Output $Path }
        if ($Check) { return }

        $output = $StrictUtf8.GetBytes($text)
        try {
            $stream.SetLength(0)
            $stream.Write($output, 0, $output.Length)
            $stream.Flush()
        } catch {
            [Console]::Error.WriteLine("Cannot write ${Path}: $($_.Exception.Message)")
            $script:ErrorCount++
        }
    } finally {
        $stream.Dispose()
    }
}

function Invoke-NormalizeDirectory([System.IO.DirectoryInfo]$Directory) {
    foreach ($entry in $Directory.EnumerateFileSystemInfos()) {
        if (Test-IsLink $entry) { continue }
        if ($entry -is [System.IO.DirectoryInfo]) {
            if ($ExcludedNames -contains $entry.Name) { continue }
            Invoke-NormalizeDirectory $entry
        } else {
            Invoke-NormalizeFile $entry.FullName
        }
    }
}

if ($Help) { Show-Usage $EXIT_CLEAN }
if ($Paths.Count -gt 1) { Show-Usage $EXIT_ERROR }

$root = if ($Paths.Count -eq 1) { $Paths[0] } else { '.' }

if (-not (Test-Path -LiteralPath $root)) {
    [Console]::Error.WriteLine("Path does not exist: $root")
    exit $EXIT_ERROR
}

$rootItem = Get-Item -LiteralPath $root -Force
if ($rootItem -is [System.IO.FileInfo] -and -not (Test-IsLink $rootItem)) {
    Invoke-NormalizeFile $rootItem.FullName
} elseif ($rootItem -is [System.IO.DirectoryInfo]) {
    Invoke-NormalizeDirectory $rootItem
} else {
    [Console]::Error.WriteLine("Path is not a regular file or directory: $root")
    exit $EXIT_ERROR
}

if ($script:ErrorCount) {
    [Console]::Error.WriteLine("Normalization failed for $($script:ErrorCount) file(s).")
    exit $EXIT_ERROR
}

if ($Check -and $script:ChangedCount) {
    [Console]::Error.WriteLine("$($script:ChangedCount) file(s) require normalization.")
    exit $EXIT_CHANGES_NEEDED
}

if (-not $Check) { [Console]::Error.WriteLine("Normalized $($script:ChangedCount) file(s).") }
exit $EXIT_CLEAN
