<#
.SYNOPSIS
    Register a Windows Scheduled Task that regenerates a directory-tree index on a schedule,
    so a shared folder index stays current without anyone running Claude or the script by hand.

.EXAMPLE
    .\setup-windows-task.ps1 -Root "G:\My Drive\Proving Grounds"
    # Daily 08:00, writes 00-Folder-Index.txt at the root

.EXAMPLE
    .\setup-windows-task.ps1 -Root "C:\Project" -Format docx -Output "C:\Project\Index.docx" -AtLogon
#>
param(
    [Parameter(Mandatory = $true)][string]$Root,
    [string]$Output,
    [ValidateSet('txt', 'md', 'docx')][string]$Format = 'txt',
    [string]$Time = '08:00',
    [switch]$AtLogon,
    [string]$TaskName = 'Claude Tree - Folder Index',
    [string]$Python = 'python'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $Root -PathType Container)) {
    throw "Root folder not found: $Root"
}
if (-not $Output) {
    $ext = if ($Format -eq 'md') { 'md' } elseif ($Format -eq 'docx') { 'docx' } else { 'txt' }
    $Output = Join-Path $Root "00-Folder-Index.$ext"
}

$script = Join-Path $PSScriptRoot 'dirtree.py'
if (-not (Test-Path -LiteralPath $script)) { throw "Generator not found: $script" }

$arguments = '"{0}" "{1}" -f {2} -o "{3}"' -f $script, $Root, $Format, $Output

# Run once now to verify the command works before scheduling it
Write-Host "Verifying generator..." -ForegroundColor Cyan
& $Python "$script" "$Root" -f $Format -o "$Output"
if ($LASTEXITCODE -ne 0) { throw "Generator failed (exit $LASTEXITCODE) - not scheduling." }

$action  = New-ScheduledTaskAction -Execute $Python -Argument $arguments
$triggers = @()
if ($AtLogon) { $triggers += New-ScheduledTaskTrigger -AtLogOn }
$triggers += New-ScheduledTaskTrigger -Daily -At $Time

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $triggers `
    -Description "Regenerate the directory-tree folder index for $Root" -Force | Out-Null

Write-Host "Registered scheduled task '$TaskName'." -ForegroundColor Green
Write-Host "  Index : $Output"
Write-Host "  When  : daily at $Time$(if ($AtLogon) { ' + at logon' })"
Write-Host "Remove with: Unregister-ScheduledTask -TaskName '$TaskName' -Confirm:`$false"
