$ErrorActionPreference = 'Stop'

$Tools = @('git', 'node', 'npm', 'python3', 'docker', 'rustc')
$NotInstalled = 'not installed'

Write-Output '== System =='
Write-Output "os: $([System.Runtime.InteropServices.RuntimeInformation]::OSDescription)"
Write-Output "arch: $([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture)"
Write-Output "hostname: $([System.Environment]::MachineName)"
Write-Output "shell: PowerShell $($PSVersionTable.PSVersion)"

Write-Output '== Tools =='
foreach ($tool in $Tools) {
    if (Get-Command $tool -ErrorAction SilentlyContinue) {
        $version = & $tool --version 2>$null | Select-Object -First 1
        Write-Output "${tool}: $version"
    }
    else {
        Write-Output "${tool}: $NotInstalled"
    }
}
