<#
.SYNOPSIS
    Yusuf Mullas Ultra Insane Windows Utility
.DESCRIPTION
    - App installer (per-app selection)
    - Individual debloat tweaks (no bundles)
    - Privacy / telemetry / performance toggles
    - Profiles that DO NOT force anything
    - Dry-run everywhere
    - Restore-point aware
    - Safe for irm | iex
.AUTHOR
    Yusuf Mulla
.VERSION
    2026.02.14
#>

#region ================= ADMIN CHECK (STREAM SAFE) =================
$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $IsAdmin) {
    Start-Process powershell `
        -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" `
        -Verb RunAs
    exit
}
#endregion

#region ================= GLOBALS =================
$global:DryRun = $false
$global:LogPath = Join-Path $env:USERPROFILE "YusufWinUtil.log"
#endregion

#region ================= LOGGING =================
function Log {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )

    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format "HH:mm:ss"), $Level, $Message
    Add-Content -Path $LogPath -Value $line

    switch ($Level) {
        "WARN"  { Write-Host $Message -ForegroundColor Yellow }
        "ERROR" { Write-Host $Message -ForegroundColor Red }
        default { Write-Host $Message }
    }
}
#endregion

#region ================= RESTORE POINT =================
function Create-RestorePoint {
    try {
        Checkpoint-Computer `
            -Description "Yusuf WinUtil Changes" `
            -RestorePointType MODIFY_SETTINGS `
            -ErrorAction Stop
        Log "Restore point created"
    } catch {
        Log "Restore point unavailable (disabled or already exists)" "WARN"
    }
}
#endregion

#region ================= APPS =================
$Apps = @(
    @{ Name="Chrome"; Id="Google.Chrome"; Desc="Chromium browser" }
    @{ Name="Firefox"; Id="Mozilla.Firefox"; Desc="Privacy browser" }
    @{ Name="Brave"; Id="Brave.Brave"; Desc="Ad-blocking browser" }
    @{ Name="VS Code"; Id="Microsoft.VisualStudioCode"; Desc="Code editor" }
    @{ Name="Git"; Id="Git.Git"; Desc="Version control" }
    @{ Name="Python"; Id="Python.Python.3"; Desc="Python runtime" }
    @{ Name="Node.js"; Id="OpenJS.NodeJS.LTS"; Desc="JS runtime" }
    @{ Name="Steam"; Id="Valve.Steam"; Desc="Game platform" }
    @{ Name="Discord"; Id="Discord.Discord"; Desc="Voice & chat" }
    @{ Name="VLC"; Id="VideoLAN.VLC"; Desc="Media player" }
    @{ Name="OBS"; Id="OBSProject.OBSStudio"; Desc="Streaming & recording" }
    @{ Name="7-Zip"; Id="7zip.7zip"; Desc="File archiver" }
) | ForEach-Object {
    [pscustomobject]@{
        Name        = $_.Name
        WingetId    = $_.Id
        Description = $_.Desc
        Selected    = $false
    }
}
#endregion

#region ================= INDIVIDUAL TWEAKS =================
$Tweaks = @(
    @{ Name="Remove Xbox"; Action={ Get-AppxPackage *Xbox* -AllUsers | Remove-AppxPackage } }
    @{ Name="Remove Groove/Zune"; Action={ Get-AppxPackage *Zune* -AllUsers | Remove-AppxPackage } }
    @{ Name="Remove Solitaire"; Action={ Get-AppxPackage *Solitaire* -AllUsers | Remove-AppxPackage } }

    @{ Name="Disable Telemetry"; Action={
        Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
            -Name AllowTelemetry -Type DWord -Value 0 -Force
        Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue
        Set-Service DiagTrack -StartupType Disabled
    }}

    @{ Name="Disable Suggestions"; Action={
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name SubscribedContent-338388Enabled -Value 0 -Force
    }}

    @{ Name="High Performance Power Plan"; Action={
        $hp = powercfg -l | Select-String "High performance" | ForEach-Object {
            ($_ -split '\s+')[3]
        }
        if ($hp) { powercfg -setactive $hp }
    }}
) | ForEach-Object {
    [pscustomobject]@{
        Name     = $_.Name
        Action   = $_.Action
        Selected = $false
    }
}
#endregion

#region ================= WPF =================
Add-Type -AssemblyName PresentationFramework

$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Yusuf Mullas Ultra WinUtil"
        Height="700" Width="1100"
        Background="#1E1E1E"
        Foreground="#F0F0F0"
        WindowStartupLocation="CenterScreen">

<Grid Margin="10">
<Grid.ColumnDefinitions>
    <ColumnDefinition Width="*"/>
    <ColumnDefinition Width="*"/>
</Grid.ColumnDefinitions>

<TabControl Grid.ColumnSpan="2">

<TabItem Header="Apps">
    <StackPanel>
        <CheckBox x:Name="DryRunChk" Content="Dry Run (Preview Only)" Foreground="Orange"/>
        <ItemsControl x:Name="AppsPanel"/>
        <Button x:Name="InstallAppsBtn" Content="Install Selected"/>
    </StackPanel>
</TabItem>

<TabItem Header="Tweaks">
    <StackPanel>
        <ItemsControl x:Name="TweaksPanel"/>
        <Button x:Name="RunTweaksBtn" Content="Run Selected Tweaks"/>
    </StackPanel>
</TabItem>

</TabControl>
</Grid>
</Window>
"@

[xml]$xml = $xaml
$window = [Windows.Markup.XamlReader]::Load(
    (New-Object System.Xml.XmlNodeReader $xml)
)
#endregion

#region ================= BIND =================
$AppsPanel      = $window.FindName("AppsPanel")
$TweaksPanel    = $window.FindName("TweaksPanel")
$InstallAppsBtn = $window.FindName("InstallAppsBtn")
$RunTweaksBtn   = $window.FindName("RunTweaksBtn")
$DryRunChk      = $window.FindName("DryRunChk")

$AppsPanel.ItemsSource   = $Apps
$TweaksPanel.ItemsSource = $Tweaks
#endregion

#region ================= ACTIONS =================
$InstallAppsBtn.Add_Click({
    $global:DryRun = $DryRunChk.IsChecked
    Create-RestorePoint

    foreach ($app in $Apps | Where-Object Selected) {
        Log "Installing $($app.Name)"
        if ($DryRun) { continue }

        winget install --id $($app.WingetId) `
            --silent --accept-source-agreements --accept-package-agreements
    }
})

$RunTweaksBtn.Add_Click({
    $global:DryRun = $DryRunChk.IsChecked
    Create-RestorePoint

    foreach ($t in $Tweaks | Where-Object Selected) {
        Log "Applying tweak: $($t.Name)"
        if ($DryRun) { continue }
        & $t.Action
    }

    [System.Windows.MessageBox]::Show("Selected tweaks applied.")
})
#endregion

#region ================= RUN =================
Log "WinUtil started"
$window.ShowDialog() | Out-Null
Log "WinUtil exited"
#endregion
