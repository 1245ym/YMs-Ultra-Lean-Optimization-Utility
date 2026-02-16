<#
Yusuf Mulla – Ultimate Windows Control Center
White Theme | Fully Modular | No Forced Tweaks
Version: 2026.02.14
#>

#region ================= ADMIN CHECK =================
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
    param([string]$Msg,[string]$Level="INFO")
    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format "HH:mm:ss"),$Level,$Msg
    Add-Content -Path $global:LogPath -Value $line
    Write-Host $Msg
}
#endregion

#region ================= RESTORE POINT =================
function Create-RestorePoint {
    try {
        Checkpoint-Computer `
            -Description "Yusuf WinUtil Changes" `
            -RestorePointType MODIFY_SETTINGS `
            -ErrorAction Stop
        Log "System restore point created"
    } catch {
        Log "Restore point skipped" "WARN"
    }
}
#endregion

#region ================= APP INSTALLER MODEL =================
$Apps = @(
    @{Name="Google Chrome";Id="Google.Chrome";Desc="Fast Chromium-based browser"}
    @{Name="Firefox";Id="Mozilla.Firefox";Desc="Privacy-focused browser"}
    @{Name="Brave";Id="Brave.Brave";Desc="Ad-blocking Chromium browser"}
    @{Name="Visual Studio Code";Id="Microsoft.VisualStudioCode";Desc="Code editor"}
    @{Name="Git";Id="Git.Git";Desc="Version control"}
    @{Name="Python 3";Id="Python.Python.3";Desc="Python runtime"}
    @{Name="Node.js LTS";Id="OpenJS.NodeJS.LTS";Desc="JavaScript runtime"}
    @{Name="7-Zip";Id="7zip.7zip";Desc="File archiver"}
    @{Name="VLC";Id="VideoLAN.VLC";Desc="Media player"}
    @{Name="Discord";Id="Discord.Discord";Desc="Voice & chat"}
) | ForEach-Object {
    [pscustomobject]@{
        Name=$_.Name
        Id=$_.Id
        Description=$_.Desc
        Selected=$false
    }
}
#endregion

#region ================= TWEAK MODEL =================
$Tweaks = @(
    # ===== DEBLOAT =====
    @{Name="Remove Xbox Apps";Desc="Removes Xbox related applications";Action={
        Get-AppxPackage *Xbox* -AllUsers | Remove-AppxPackage
    }}

    @{Name="Remove Groove Music";Desc="Removes Groove / Zune";Action={
        Get-AppxPackage *Zune* -AllUsers | Remove-AppxPackage
    }}

    @{Name="Remove Solitaire";Desc="Removes Microsoft Solitaire";Action={
        Get-AppxPackage *Solitaire* -AllUsers | Remove-AppxPackage
    }}

    # ===== PRIVACY =====
    @{Name="Disable Telemetry";Desc="Stops Windows diagnostic tracking";Action={
        Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" `
            -Name AllowTelemetry -Value 0 -Type DWord -Force
        Stop-Service DiagTrack -Force -ErrorAction SilentlyContinue
    }}

    @{Name="Disable Windows Suggestions";Desc="Disables tips and suggestions";Action={
        Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" `
            -Name SubscribedContent-338388Enabled -Value 0 -Force
    }}

    # ===== PERFORMANCE =====
    @{Name="High Performance Power Plan";Desc="Enables high performance power mode";Action={
        $hp = powercfg -l | Select-String "High performance" |
        ForEach-Object {($_ -split '\s+')[3]}
        if ($hp) { powercfg -setactive $hp }
    }}

    @{Name="Disable Power Throttling";Desc="Prevents Windows background throttling";Action={
        Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" `
            -Name PowerThrottlingOff -Value 1 -Type DWord -Force
    }}

    # ===== NETWORK / LATENCY =====
    @{Name="Disable Network Throttling";Desc="Improves network responsiveness";Action={
        Set-ItemProperty `
        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
        -Name NetworkThrottlingIndex -Value 0xffffffff -Type DWord -Force
    }}

    @{Name="System Responsiveness = 0";Desc="Optimizes multimedia scheduling";Action={
        Set-ItemProperty `
        "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" `
        -Name SystemResponsiveness -Value 0 -Type DWord -Force
    }}

    @{Name="Disable Nagle Algorithm";Desc="Reduces TCP latency for gaming";Action={
        Get-ChildItem "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" |
        ForEach-Object {
            Set-ItemProperty $_.PsPath TcpNoDelay 1 -Type DWord -Force
            Set-ItemProperty $_.PsPath TcpAckFrequency 1 -Type DWord -Force
        }
    }}

    @{Name="Disable Energy Efficient Ethernet";Desc="Prevents NIC power saving";Action={
        Get-NetAdapter | Where-Object Status -eq "Up" |
        ForEach-Object {
            Disable-NetAdapterPowerManagement -Name $_.Name -ErrorAction SilentlyContinue
        }
    }}

    @{Name="Flush DNS Cache";Desc="Clears DNS resolver cache";Action={
        ipconfig /flushdns | Out-Null
    }}

) | ForEach-Object {
    [pscustomobject]@{
        Name=$_.Name
        Description=$_.Desc
        Action=$_.Action
        Selected=$false
    }
}
#endregion

#region ================= WPF GUI =================
Add-Type -AssemblyName PresentationFramework

$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Yusuf Mulla – Ultimate Windows Control Center"
        Height="760" Width="1200"
        Background="White"
        Foreground="Black"
        WindowStartupLocation="CenterScreen">

<Grid Margin="15">
<TabControl>

<TabItem Header="App Installer">
<StackPanel>
<CheckBox x:Name="DryRunChk" Content="Dry Run (Preview Only)" FontWeight="Bold" Margin="0,0,0,10"/>

<ScrollViewer Height="520">
<ItemsControl x:Name="AppsPanel">
<ItemsControl.ItemTemplate>
<DataTemplate>
<Border BorderBrush="#DDD" BorderThickness="1" Padding="8" Margin="4">
<StackPanel>
<CheckBox Content="{Binding Name}" IsChecked="{Binding Selected,Mode=TwoWay}" FontWeight="SemiBold"/>
<TextBlock Text="{Binding Description}" FontSize="12" Foreground="#444" Margin="22,2,0,0"/>
</StackPanel>
</Border>
</DataTemplate>
</ItemsControl.ItemTemplate>
</ItemsControl>
</ScrollViewer>

<Button x:Name="InstallAppsBtn" Content="Install Selected Apps" Height="40"/>
</StackPanel>
</TabItem>

<TabItem Header="Tweaks / Optimization">
<StackPanel>
<ScrollViewer Height="560">
<ItemsControl x:Name="TweaksPanel">
<ItemsControl.ItemTemplate>
<DataTemplate>
<Border BorderBrush="#DDD" BorderThickness="1" Padding="8" Margin="4">
<StackPanel>
<CheckBox Content="{Binding Name}" IsChecked="{Binding Selected,Mode=TwoWay}" FontWeight="SemiBold"/>
<TextBlock Text="{Binding Description}" FontSize="12" Foreground="#444" Margin="22,2,0,0"/>
</StackPanel>
</Border>
</DataTemplate>
</ItemsControl.ItemTemplate>
</ItemsControl>
</ScrollViewer>

<Button x:Name="RunTweaksBtn" Content="Apply Selected Tweaks" Height="40"/>
</StackPanel>
</TabItem>

</TabControl>
</Grid>
</Window>
"@

$reader = [System.Xml.XmlReader]::Create([System.IO.StringReader]$xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)
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
        if ($global:DryRun) { continue }

        winget install --id $app.Id `
            --silent --accept-source-agreements --accept-package-agreements
    }
})

$RunTweaksBtn.Add_Click({
    $global:DryRun = $DryRunChk.IsChecked
    Create-RestorePoint

    foreach ($t in $Tweaks | Where-Object Selected) {
        Log "Applying: $($t.Name)"
        if ($global:DryRun) { continue }
        & $t.Action
    }

    [System.Windows.MessageBox]::Show("Selected tweaks applied. Reboot recommended.")
})
#endregion

#region ================= RUN =================
Log "WinUtil started"
$window.ShowDialog() | Out-Null
Log "WinUtil exited"
#endregion
