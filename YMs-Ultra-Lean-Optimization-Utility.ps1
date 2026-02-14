<#
.SYNOPSIS
    Yusuf Mullas WinUtil - Ultra Ultimate Windows Utility
.DESCRIPTION
    Inspired by Chris Titus Tech's WinUtil, but rebuilt:
    - Modern WPF GUI
    - Apps installer (winget)
    - Debloat
    - Tweaks
    - Backup
    - Latency analytics
    - Services manager
    - Tasks manager
    - Profiles (Gaming, Streaming, Work, Performance)
.NOTES
    Author: Yusuf Mullas
    License: MIT (recommended if you publish)
#>

[CmdletBinding()]
param()

# ============================================
#  GLOBAL CONFIG / METADATA
# ============================================
$global:WinUtil = @{
    Name    = "Yusuf Mullas WinUtil"
    Version = "2026.02.14"
    Repo    = "https://github.com/YusufMullas/YMs-Ultra-Lean-Optimization-Utility"
}

# ============================================
#  GLOBAL DESCRIPTIONS
# ============================================

# Apps
$global:AppDescriptions = @{
    "7-Zip" = @"
7-Zip - Lightweight file archiver:
- Adds support for .7z, .zip, .rar and more
- Very fast and open-source
- Great replacement for WinRAR or built-in ZIP
"@

    "Google Chrome" = @"
Google Chrome - Web browser:
- Fast, widely supported browser
- Syncs with Google account
- Good for web apps, streaming, and general use
"@

    "Visual Studio Code" = @"
Visual Studio Code - Code editor:
- Lightweight but powerful editor
- Extensions for any language
- Great for development, scripting, and config editing
"@

    "Discord" = @"
Discord - Voice and text chat:
- Popular for gaming communities
- Voice channels, screen share, and DMs
- Used for gaming, study groups, and communities
"@

    "Steam" = @"
Steam - Game launcher and store:
- Central hub for PC games
- Cloud saves, friends, achievements
- Required for many modern PC titles
"@
}

# Debloat
$global:DebloatDescriptions = @{
    "RemoveBloatware" = @"
Removes common preinstalled Microsoft / OEM apps:
- Xbox apps, 3D Viewer, Office Hub, Solitaire, etc.
- Frees disk space and declutters Start menu
- Recommended for clean, focused systems
Note: Some apps can be reinstalled from Microsoft Store.
"@

    "DisableTelemetry" = @"
Disables basic telemetry and data collection:
- Stops key telemetry services (DiagTrack, dmwappushservice)
- Reduces background data collection
- Slight privacy and performance improvement
"@

    "DisableSuggestions" = @"
Disables Windows suggestions and consumer features:
- Removes Start menu suggestions
- Disables lock screen tips and ads
- Turns off some Microsoft promotional content
Result: Cleaner, less distracting UI.
"@
}

# Tweaks
$global:TweakDescriptions = @{
    "DarkMode" = @"
Forces Windows into full dark mode:
- Dark apps and system UI
- Dark taskbar and settings
Benefits: Less eye strain and a modern look.
"@

    "DisableAnimations" = @"
Disables Windows UI animations:
- Window minimize/maximize animations
- Taskbar and menu fade effects
Benefits: Snappier feel, lower input latency, better on low-end hardware.
"@

    "HighPerfPower" = @"
Enables the High Performance power plan:
- Keeps CPU at higher clocks
- Reduces latency spikes
- Improves gaming and heavy workload performance
Best for desktops and plugged-in laptops.
"@
}

# Latency / Network
$global:LatencyDescriptions = @{
    "Latency" = @"
Latency (ping) - time for a packet to go to the server and back:
- Measured in milliseconds (ms)
- Lower is better
- Under 40 ms: excellent for gaming
- 40-80 ms: good
- 80-120 ms: playable but not ideal
- 120+ ms: noticeable delay
"@

    "Jitter" = @"
Jitter - variation in latency between packets:
- Measures how consistent your connection is
- Low jitter = stable connection
- High jitter = stutter, rubber-banding in games
"@

    "PacketLoss" = @"
Packet loss - percentage of packets that never arrive:
- 0-1%: excellent
- 1-3%: usually okay
- 3-5%: noticeable issues
- 5%+: bad for gaming and voice chat
"@

    "Rating" = @"
Connection rating - summary based on latency, jitter, and packet loss:
- Excellent: great for gaming and streaming
- Good: fine for most games
- Okay: usable, but not ideal for competitive gaming
- Bad: unstable for real-time use
"@
}

# ============================================
#  APPS MAP (DISPLAY NAME -> WINGET ID)
# ============================================
$global:AppMap = @{
    "7-Zip"              = "7zip.7zip"
    "Google Chrome"      = "Google.Chrome"
    "Visual Studio Code" = "Microsoft.VisualStudioCode"
    "Discord"            = "Discord.Discord"
    "Steam"              = "Valve.Steam"
}

# ============================================
#  SERVICES / TASKS DEFINITIONS (Performance Mode)
# ============================================
$global:ServiceItems = @(
    [pscustomobject]@{
        Key         = "XboxServices"
        DisplayName = "Disable Xbox Services"
        Description = @"
Disables Xbox-related services:
- Xbox Accessory Management
- Xbox Live Auth / Game Save
- Xbox Networking
Improves performance on systems that do not use Xbox features.
"@
        Services    = @(
            "XblAuthManager",
            "XblGameSave",
            "XboxGipSvc",
            "XboxNetApiSvc"
        )
    }
    [pscustomobject]@{
        Key         = "DiagTracking"
        DisplayName = "Disable Diagnostics Tracking"
        Description = @"
Disables diagnostics tracking services:
- Connected User Experiences and Telemetry (DiagTrack)
- dmwappushservice
Reduces background telemetry and data collection.
"@
        Services    = @(
            "DiagTrack",
            "dmwappushservice"
        )
    }
    [pscustomobject]@{
        Key         = "PrintSpooler"
        DisplayName = "Disable Print Spooler"
        Description = @"
Disables the Print Spooler service:
- Stops printer management and print jobs
Improves security and performance on systems that never print.
"@
        Services    = @(
            "Spooler"
        )
    }
    [pscustomobject]@{
        Key         = "RetailDemo"
        DisplayName = "Disable Retail Demo Services"
        Description = @"
Disables retail/demo-related services:
- RetailDemo
Useful for non-store, personal systems.
"@
        Services    = @(
            "RetailDemo"
        )
    }
    [pscustomobject]@{
        Key         = "MapsServices"
        DisplayName = "Disable Maps Services"
        Description = @"
Disables offline maps and related services:
- MapsBroker
Reduces background activity for maps/location features.
"@
        Services    = @(
            "MapsBroker"
        )
    }
)

$global:TaskItems = @(
    [pscustomobject]@{
        Key         = "CEIP"
        DisplayName = "Disable CEIP (Customer Experience Improvement Program)"
        Description = @"
Disables Customer Experience Improvement Program tasks:
- Reduces background telemetry and reporting.
"@
        TaskPaths   = @(
            "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
            "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
            "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
        )
    }
    [pscustomobject]@{
        Key         = "AppExperience"
        DisplayName = "Disable Application Experience Tasks"
        Description = @"
Disables Application Experience tasks:
- Reduces background compatibility and telemetry checks.
"@
        TaskPaths   = @(
            "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
            "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
        )
    }
    [pscustomobject]@{
        Key         = "MediaCenter"
        DisplayName = "Disable Media Center Tasks"
        Description = @"
Disables legacy Media Center tasks:
- Safe on modern systems that do not use Media Center.
"@
        TaskPaths   = @(
            "\Microsoft\Windows\Media Center\*"
        )
    }
    [pscustomobject]@{
        Key         = "MapsTasks"
        DisplayName = "Disable Maps Tasks"
        Description = @"
Disables Maps-related scheduled tasks:
- Reduces background map data updates.
"@
        TaskPaths   = @(
            "\Microsoft\Windows\Maps\MapsUpdateTask",
            "\Microsoft\Windows\Maps\MapsToastTask"
        )
    }
)

# ============================================
#  XAML UI (WPF)
# ============================================
Add-Type -AssemblyName PresentationFramework

$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Yusuf Mullas WinUtil"
        Height="650" Width="1100"
        WindowStartupLocation="CenterScreen"
        Background="#1E1E1E" Foreground="#F0F0F0"
        FontFamily="Segoe UI">
    <Window.Resources>
        <Style TargetType="Button">
            <Setter Property="Margin" Value="6"/>
            <Setter Property="Padding" Value="10,5"/>
            <Setter Property="Background" Value="#3A3A3A"/>
            <Setter Property="Foreground" Value="#F0F0F0"/>
            <Setter Property="BorderBrush" Value="#5A5A5A"/>
            <Setter Property="BorderThickness" Value="1"/>
        </Style>
        <Style TargetType="TextBox">
            <Setter Property="Margin" Value="6"/>
            <Setter Property="Background" Value="#2A2A2A"/>
            <Setter Property="Foreground" Value="#F0F0F0"/>
            <Setter Property="BorderBrush" Value="#555555"/>
        </Style>
        <Style TargetType="CheckBox">
            <Setter Property="Margin" Value="4,4,4,4"/>
        </Style>
        <Style TargetType="TabItem">
            <Setter Property="Margin" Value="0,0,4,0"/>
        </Style>
    </Window.Resources>

    <DockPanel>
        <Border DockPanel.Dock="Top" Background="#252526" Height="48">
            <Grid Margin="10,0">
                <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <StackPanel Orientation="Horizontal" VerticalAlignment="Center">
                    <TextBlock Text="Yusuf Mullas WinUtil"
                               FontSize="20"
                               FontWeight="Bold"
                               Margin="4,0,10,0"/>
                    <TextBlock Text="Ultra Ultimate"
                               FontSize="12"
                               Foreground="#AAAAAA"
                               VerticalAlignment="Center"/>
                </StackPanel>
                <TextBlock Grid.Column="1"
                           Text="{Binding VersionText}"
                           VerticalAlignment="Center"
                           Foreground="#AAAAAA"/>
            </Grid>
        </Border>

        <Grid Margin="8">
            <Grid.ColumnDefinitions>
                <ColumnDefinition Width="3*"/>
                <ColumnDefinition Width="2*"/>
            </Grid.ColumnDefinitions>

            <TabControl Grid.Column="0" Margin="0,0,8,0">
                <!-- Apps Tab -->
                <TabItem Header="Apps">
                    <Grid Margin="10">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>

                        <TextBlock Text="App Installer"
                                   FontSize="18"
                                   FontWeight="SemiBold"
                                   Margin="0,0,0,8"/>

                        <ListBox x:Name="AppsList"
                                 Grid.Row="1"
                                 Background="#2A2A2A"
                                 BorderBrush="#444444">
                            <ListBoxItem Content="7-Zip"/>
                            <ListBoxItem Content="Google Chrome"/>
                            <ListBoxItem Content="Visual Studio Code"/>
                            <ListBoxItem Content="Discord"/>
                            <ListBoxItem Content="Steam"/>
                        </ListBox>

                        <StackPanel Grid.Row="2"
                                    Orientation="Horizontal"
                                    HorizontalAlignment="Right"
                                    Margin="0,8,0,0">
                            <Button x:Name="InstallSelectedAppsBtn" Content="Install Selected"/>
                            <Button x:Name="RefreshAppsBtn" Content="Refresh List" Margin="6,0,0,0"/>
                        </StackPanel>
                    </Grid>
                </TabItem>

                <!-- Debloat Tab -->
                <TabItem Header="Debloat">
                    <StackPanel Margin="10">
                        <TextBlock Text="Debloat Options"
                                   FontSize="18"
                                   FontWeight="SemiBold"
                                   Margin="0,0,0,8"/>
                        <TextBlock Text="Select what you want to remove or disable. These focus on clutter, telemetry, and suggestions."
                                   TextWrapping="Wrap"
                                   Foreground="#BBBBBB"
                                   Margin="0,0,0,10"/>

                        <CheckBox x:Name="RemoveBloatwareChk"
                                  Content="Remove common OEM / Microsoft bloatware"/>
                        <CheckBox x:Name="DisableTelemetryChk"
                                  Content="Disable telemetry and data collection"/>
                        <CheckBox x:Name="DisableSuggestionsChk"
                                  Content="Disable Start menu / lock screen suggestions"/>

                        <StackPanel Orientation="Horizontal"
                                    HorizontalAlignment="Right"
                                    Margin="0,20,0,0">
                            <Button x:Name="RunDebloatBtn" Content="Run Debloat"/>
                        </StackPanel>
                    </StackPanel>
                </TabItem>

                <!-- Tweaks Tab -->
                <TabItem Header="Tweaks">
                    <StackPanel Margin="10">
                        <TextBlock Text="System Tweaks"
                                   FontSize="18"
                                   FontWeight="SemiBold"
                                   Margin="0,0,0,8"/>
                        <TextBlock Text="Performance and visual tweaks. These affect how Windows looks and behaves."
                                   TextWrapping="Wrap"
                                   Foreground="#BBBBBB"
                                   Margin="0,0,0,10"/>

                        <CheckBox x:Name="EnableDarkModeChk"
                                  Content="Force Dark Mode"/>
                        <CheckBox x:Name="DisableAnimationsChk"
                                  Content="Disable UI animations for performance"/>
                        <CheckBox x:Name="SetHighPerfPowerChk"
                                  Content="Set High Performance power plan"/>

                        <StackPanel Orientation="Horizontal"
                                    HorizontalAlignment="Right"
                                    Margin="0,20,0,0">
                            <Button x:Name="ApplyTweaksBtn" Content="Apply Tweaks"/>
                        </StackPanel>
                    </StackPanel>
                </TabItem>

                <!-- Backup Tab -->
                <TabItem Header="Backup">
                    <StackPanel Margin="10">
                        <TextBlock Text="Backup &amp; Restore"
                                   FontSize="18"
                                   FontWeight="SemiBold"
                                   Margin="0,0,0,8"/>
                        <TextBlock Text="Save or load a basic configuration snapshot for this utility."
                                   TextWrapping="Wrap"
                                   Foreground="#BBBBBB"
                                   Margin="0,0,0,10"/>

                        <StackPanel Orientation="Horizontal" Margin="0,4,0,0">
                            <Button x:Name="BackupConfigBtn" Content="Backup Config"/>
                            <Button x:Name="RestoreConfigBtn" Content="Restore Config" Margin="6,0,0,0"/>
                        </StackPanel>

                        <TextBlock x:Name="BackupStatusTxt"
                                   Margin="4,10,0,0"
                                   Foreground="#AAAAAA"/>
                    </StackPanel>
                </TabItem>

                <!-- Latency / Network Tab -->
                <TabItem Header="Latency">
                    <Grid Margin="10">
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                        </Grid.RowDefinitions>

                        <TextBlock Text="Latency &amp; Network"
                                   FontSize="18"
                                   FontWeight="SemiBold"
                                   Margin="0,0,0,8"/>

                        <StackPanel Grid.Row="1"
                                    Orientation="Horizontal"
                                    VerticalAlignment="Top"
                                    Margin="0,4,0,0">
                            <TextBlock Text="Target Host:"
                                       VerticalAlignment="Center"
                                       Margin="0,0,6,0"/>
                            <TextBox x:Name="LatencyHostTxt"
                                     Width="220"
                                     Text="8.8.8.8"/>
                            <Button x:Name="TestLatencyBtn"
                                    Content="Test Latency"
                                    Margin="8,0,0,0"/>
                        </StackPanel>

                        <TextBox x:Name="LatencyOutputTxt"
                                 Grid.Row="2"
                                 Margin="0,10,0,0"
                                 IsReadOnly="True"
                                 TextWrapping="Wrap"
                                 VerticalScrollBarVisibility="Auto"
                                 Background="#202020"
                                 BorderBrush="#444444"/>
                    </Grid>
                </TabItem>

                <!-- Services Tab -->
                <TabItem Header="Services">
                    <Grid Margin="10">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="3*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>

                        <TextBlock Text="Services (Performance Mode)"
                                   FontSize="18"
                                   FontWeight="SemiBold"
                                   Margin="0,0,0,8"/>

                        <ListBox x:Name="ServicesList"
                                 Grid.Row="1"
                                 Grid.Column="0"
                                 Background="#2A2A2A"
                                 BorderBrush="#444444"
                                 DisplayMemberPath="DisplayName"
                                 SelectedIndex="0"/>

                        <TextBox x:Name="ServiceDescBox"
                                 Grid.Row="1"
                                 Grid.Column="1"
                                 Margin="8,0,0,0"
                                 IsReadOnly="True"
                                 TextWrapping="Wrap"
                                 VerticalScrollBarVisibility="Auto"
                                 Background="#202020"
                                 BorderBrush="#444444"/>

                        <StackPanel Grid.Row="2"
                                    Grid.ColumnSpan="2"
                                    Orientation="Horizontal"
                                    HorizontalAlignment="Right"
                                    Margin="0,8,0,0">
                            <Button x:Name="ApplyServicesBtn" Content="Apply Selected Service Tweaks"/>
                        </StackPanel>
                    </Grid>
                </TabItem>

                <!-- Tasks Tab -->
                <TabItem Header="Tasks">
                    <Grid Margin="10">
                        <Grid.ColumnDefinitions>
                            <ColumnDefinition Width="2*"/>
                            <ColumnDefinition Width="3*"/>
                        </Grid.ColumnDefinitions>
                        <Grid.RowDefinitions>
                            <RowDefinition Height="Auto"/>
                            <RowDefinition Height="*"/>
                            <RowDefinition Height="Auto"/>
                        </Grid.RowDefinitions>

                        <TextBlock Text="Scheduled Tasks (Performance Mode)"
                                   FontSize="18"
                                   FontWeight="SemiBold"
                                   Margin="0,0,0,8"/>

                        <ListBox x:Name="TasksList"
                                 Grid.Row="1"
                                 Grid.Column="0"
                                 Background="#2A2A2A"
                                 BorderBrush="#444444"
                                 DisplayMemberPath="DisplayName"
                                 SelectedIndex="0"/>

                        <TextBox x:Name="TaskDescBox"
                                 Grid.Row="1"
                                 Grid.Column="1"
                                 Margin="8,0,0,0"
                                 IsReadOnly="True"
                                 TextWrapping="Wrap"
                                 VerticalScrollBarVisibility="Auto"
                                 Background="#202020"
                                 BorderBrush="#444444"/>

                        <StackPanel Grid.Row="2"
                                    Grid.ColumnSpan="2"
                                    Orientation="Horizontal"
                                    HorizontalAlignment="Right"
                                    Margin="0,8,0,0">
                            <Button x:Name="ApplyTasksBtn" Content="Apply Selected Task Tweaks"/>
                        </StackPanel>
                    </Grid>
                </TabItem>

                <!-- Profiles Tab -->
                <TabItem Header="Profiles">
                    <StackPanel Margin="10">
                        <TextBlock Text="Profiles"
                                   FontSize="18"
                                   FontWeight="SemiBold"
                                   Margin="0,0,0,8"/>
                        <TextBlock Text="One-click presets that apply multiple tweaks, debloat options, services, and tasks."
                                   TextWrapping="Wrap"
                                   Foreground="#BBBBBB"
                                   Margin="0,0,0,10"/>

                        <StackPanel Orientation="Vertical" Margin="0,4,0,0">
                            <Button x:Name="GamingProfileBtn" Content="Apply Gaming Mode" Margin="0,0,0,4"/>
                            <Button x:Name="StreamingProfileBtn" Content="Apply Streaming Mode" Margin="0,0,0,4"/>
                            <Button x:Name="WorkProfileBtn" Content="Apply Work Mode" Margin="0,0,0,4"/>
                            <Button x:Name="PerformanceProfileBtn" Content="Apply Performance Mode" Margin="0,10,0,0"/>
                        </StackPanel>
                    </StackPanel>
                </TabItem>
            </TabControl>

            <Border Grid.Column="1"
                    Background="#202020"
                    BorderBrush="#444444"
                    BorderThickness="1"
                    CornerRadius="4"
                    Padding="8">
                <StackPanel>
                    <TextBlock Text="Console / Info"
                               FontSize="16"
                               FontWeight="SemiBold"
                               Margin="0,0,0,6"/>
                    <TextBlock Text="Run this script from PowerShell to see detailed logs and descriptions for every action."
                               TextWrapping="Wrap"
                               Foreground="#BBBBBB"/>
                </StackPanel>
            </Border>
        </Grid>
    </DockPanel>
</Window>
"@

[xml]$xamlXml = $xaml
$reader = New-Object System.Xml.XmlNodeReader $xamlXml
$window = [Windows.Markup.XamlReader]::Load($reader)

$window.DataContext = [pscustomobject]@{
    VersionText = "v$($WinUtil.Version)"
}

# Bind controls
$AppsList            = $window.FindName("AppsList")
$InstallSelectedApps = $window.FindName("InstallSelectedAppsBtn")
$RefreshAppsBtn      = $window.FindName("RefreshAppsBtn")

$RemoveBloatwareChk    = $window.FindName("RemoveBloatwareChk")
$DisableTelemetryChk   = $window.FindName("DisableTelemetryChk")
$DisableSuggestionsChk = $window.FindName("DisableSuggestionsChk")
$RunDebloatBtn         = $window.FindName("RunDebloatBtn")

$EnableDarkModeChk     = $window.FindName("EnableDarkModeChk")
$DisableAnimationsChk  = $window.FindName("DisableAnimationsChk")
$SetHighPerfPowerChk   = $window.FindName("SetHighPerfPowerChk")
$ApplyTweaksBtn        = $window.FindName("ApplyTweaksBtn")

$BackupConfigBtn       = $window.FindName("BackupConfigBtn")
$RestoreConfigBtn      = $window.FindName("RestoreConfigBtn")
$BackupStatusTxt       = $window.FindName("BackupStatusTxt")

$LatencyHostTxt        = $window.FindName("LatencyHostTxt")
$TestLatencyBtn        = $window.FindName("TestLatencyBtn")
$LatencyOutputTxt      = $window.FindName("LatencyOutputTxt")

$ServicesList    = $window.FindName("ServicesList")
$ServiceDescBox  = $window.FindName("ServiceDescBox")
$ApplyServicesBtn = $window.FindName("ApplyServicesBtn")

$TasksList       = $window.FindName("TasksList")
$TaskDescBox     = $window.FindName("TaskDescBox")
$ApplyTasksBtn   = $window.FindName("ApplyTasksBtn")

$GamingProfileBtn      = $window.FindName("GamingProfileBtn")
$StreamingProfileBtn   = $window.FindName("StreamingProfileBtn")
$WorkProfileBtn        = $window.FindName("WorkProfileBtn")
$PerformanceProfileBtn = $window.FindName("PerformanceProfileBtn")
# ============================================
#  CORE LOGIC
# ============================================

# Apps Installer
function Install-SelectedApps {
    param(
        [System.Windows.Controls.ListBox]$ListBox
    )
    $selected = $ListBox.SelectedItems | ForEach-Object { $_.Content }
    if (-not $selected) {
        [System.Windows.MessageBox]::Show("No apps selected.", "Yusuf WinUtil")
        return
    }

    foreach ($app in $selected) {
        $name = [string]$app

        if ($AppDescriptions.ContainsKey($name)) {
            Write-Host ""
            Write-Host "=== $name ===" -ForegroundColor Green
            Write-Host $AppDescriptions[$name]
        }

        if (-not $AppMap.ContainsKey($name)) {
            Write-Host "No winget ID mapped for $name" -ForegroundColor Yellow
            continue
        }

        $id = $AppMap[$name]
        Write-Host "Installing $name ($id) via winget..." -ForegroundColor Cyan
        Start-Process winget -ArgumentList "install --id `"$id`" -e --source winget --accept-source-agreements --accept-package-agreements" -NoNewWindow
    }

    [System.Windows.MessageBox]::Show("Install commands issued. Check console for details and descriptions.", "Yusuf WinUtil")
}

# Debloat
function Remove-CommonBloat {
    Write-Host "Removing common bloatware Appx packages..." -ForegroundColor Yellow

    $bloatList = @(
        "*XboxApp*",
        "*XboxGamingOverlay*",
        "*Microsoft.ZuneMusic*",
        "*Microsoft.ZuneVideo*",
        "*Microsoft.SkypeApp*",
        "*Microsoft.GetHelp*",
        "*Microsoft.Getstarted*",
        "*Microsoft.Microsoft3DViewer*",
        "*Microsoft.MicrosoftOfficeHub*",
        "*Microsoft.MicrosoftSolitaireCollection*",
        "*Microsoft.People*",
        "*Microsoft.MicrosoftStickyNotes*"
    )

    foreach ($pattern in $bloatList) {
        Get-AppxPackage -Name $pattern -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -Like $pattern | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
    }
}

function Disable-Telemetry {
    Write-Host "Disabling telemetry and related services..." -ForegroundColor Yellow

    $services = @(
        "DiagTrack",
        "dmwappushservice"
    )

    foreach ($svc in $services) {
        Get-Service -Name $svc -ErrorAction SilentlyContinue | ForEach-Object {
            Stop-Service $_.Name -Force -ErrorAction SilentlyContinue
            Set-Service $_.Name -StartupType Disabled -ErrorAction SilentlyContinue
        }
    }

    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Force | Out-Null
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -ErrorAction SilentlyContinue
}

function Disable-Suggestions {
    Write-Host "Disabling suggestions and consumer features..." -ForegroundColor Yellow

    $paths = @(
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager",
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    )

    foreach ($p in $paths) {
        New-Item -Path $p -Force | Out-Null
    }

    Set-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" "SystemPaneSuggestionsEnabled" 0 -Type DWord -ErrorAction SilentlyContinue
    Set-ItemProperty "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" "DisableConsumerFeatures" 1 -Type DWord -ErrorAction SilentlyContinue
}

function Run-Debloat {
    param(
        [bool]$RemoveBloatware,
        [bool]$DisableTelemetry,
        [bool]$DisableSuggestions
    )

    if ($RemoveBloatware) {
        Write-Host ""
        Write-Host "[Debloat: Remove Bloatware]" -ForegroundColor Cyan
        Write-Host $DebloatDescriptions["RemoveBloatware"]
        Remove-CommonBloat
    }

    if ($DisableTelemetry) {
        Write-Host ""
        Write-Host "[Debloat: Disable Telemetry]" -ForegroundColor Cyan
        Write-Host $DebloatDescriptions["DisableTelemetry"]
        Disable-Telemetry
    }

    if ($DisableSuggestions) {
        Write-Host ""
        Write-Host "[Debloat: Disable Suggestions]" -ForegroundColor Cyan
        Write-Host $DebloatDescriptions["DisableSuggestions"]
        Disable-Suggestions
    }

    [System.Windows.MessageBox]::Show("Debloat operations completed. A reboot is recommended.", "Yusuf WinUtil")
}

# Tweaks
function Set-DarkMode {
    Write-Host ""
    Write-Host "[Dark Mode] Applying..." -ForegroundColor Cyan
    Write-Host $TweakDescriptions["DarkMode"]

    $path = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
    New-Item -Path $path -Force | Out-Null
    Set-ItemProperty -Path $path -Name "AppsUseLightTheme" -Type DWord -Value 0
    Set-ItemProperty -Path $path -Name "SystemUsesLightTheme" -Type DWord -Value 0
}

function Disable-UIAnimations {
    Write-Host ""
    Write-Host "[Disable Animations] Applying..." -ForegroundColor Cyan
    Write-Host $TweakDescriptions["DisableAnimations"]

    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    New-Item -Path $regPath -Force | Out-Null
    Set-ItemProperty -Path $regPath -Name "VisualFXSetting" -Type DWord -Value 2

    $advPath = "HKCU:\Control Panel\Desktop"
    Set-ItemProperty -Path $advPath -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
}

function Set-HighPerformancePlan {
    Write-Host ""
    Write-Host "[High Performance Power Plan] Applying..." -ForegroundColor Cyan
    Write-Host $TweakDescriptions["HighPerfPower"]

    powercfg -setactive SCHEME_MIN
}

function Apply-Tweaks {
    param(
        [bool]$DarkMode,
        [bool]$DisableAnimations,
        [bool]$HighPerfPower
    )

    if ($DarkMode)         { Set-DarkMode }
    if ($DisableAnimations){ Disable-UIAnimations }
    if ($HighPerfPower)    { Set-HighPerformancePlan }

    [System.Windows.MessageBox]::Show("Tweaks applied. Check console for detailed descriptions.", "Yusuf WinUtil")
}

# Backup / Restore
function Backup-Config {
    param(
        [System.Windows.Controls.TextBlock]$StatusControl
    )

    $path = Join-Path $env:USERPROFILE "yusuf-winutil-backup.json"
    $config = @{
        Timestamp = (Get-Date)
        Version   = $WinUtil.Version
    } | ConvertTo-Json -Depth 5

    $config | Set-Content -Path $path -Encoding UTF8
    $StatusControl.Text = "Backup saved to $path"
}

function Restore-Config {
    param(
        [System.Windows.Controls.TextBlock]$StatusControl
    )

    $path = Join-Path $env:USERPROFILE "yusuf-winutil-backup.json"
    if (-not (Test-Path $path)) {
        $StatusControl.Text = "No backup found at $path"
        return
    }

    $json = Get-Content -Path $path -Raw | ConvertFrom-Json
    $StatusControl.Text = "Backup loaded from $path (apply logic not yet implemented)"
}

# Latency / Network
function Test-Latency {
    param(
        [string]$Host,
        [System.Windows.Controls.TextBox]$OutputControl
    )

    if ([string]::IsNullOrWhiteSpace($Host)) {
        $Host = "8.8.8.8"
    }

    $OutputControl.Clear()
    $OutputControl.AppendText("Pinging $Host ...`r`n`r`n")

    try {
        $count = 10
        $results = Test-Connection -ComputerName $Host -Count $count -ErrorAction Stop

        $rtts = $results | Select-Object -ExpandProperty ResponseTime
        $avg  = ($rtts | Measure-Object -Average).Average
        $min  = ($rtts | Measure-Object -Minimum).Minimum
        $max  = ($rtts | Measure-Object -Maximum).Maximum
        $jitter = $max - $min

        $received = $results.Count
        $loss = (($count - $received) / $count) * 100

        foreach ($r in $results) {
            $OutputControl.AppendText("Reply from {0}: time={1}ms`r`n" -f $r.Address, $r.ResponseTime)
        }

        $OutputControl.AppendText("`r`n--- Stats ---`r`n")
        $OutputControl.AppendText("Packets: Sent = $count, Received = $received, Lost = {0} ({1:N1}% loss)`r`n" -f ($count - $received), $loss)
        $OutputControl.AppendText("Latency: Avg = {0:N1} ms, Min = {1:N1} ms, Max = {2:N1} ms`r`n" -f $avg, $min, $max)
        $OutputControl.AppendText("Jitter: {0:N1} ms`r`n`r`n" -f $jitter)

        $rating = if ($loss -ge 5 -or $avg -ge 120 -or $jitter -ge 40) {
            "Bad for gaming / unstable"
        }
        elseif ($avg -le 40 -and $jitter -le 15 -and $loss -lt 1) {
            "Excellent - great for gaming and streaming"
        }
        elseif ($avg -le 80 -and $jitter -le 25 -and $loss -lt 3) {
            "Good - fine for most online games"
        }
        else {
            "Okay - usable, but not ideal for competitive gaming"
        }

        $OutputControl.AppendText("Rating: $rating`r`n`r`n")

        $OutputControl.AppendText("--- Explanations ---`r`n")
        $OutputControl.AppendText($LatencyDescriptions["Latency"] + "`r`n`r`n")
        $OutputControl.AppendText($LatencyDescriptions["Jitter"] + "`r`n`r`n")
        $OutputControl.AppendText($LatencyDescriptions["PacketLoss"] + "`r`n`r`n")
        $OutputControl.AppendText($LatencyDescriptions["Rating"])
    }
    catch {
        $OutputControl.AppendText("Error testing latency: $($_.Exception.Message)")
    }
}

# Services / Tasks helpers
function Set-ServicesState {
    param(
        [string[]]$ServiceNames,
        [string]$State
    )

    foreach ($svcName in $ServiceNames) {
        $svc = Get-Service -Name $svcName -ErrorAction SilentlyContinue
        if (-not $svc) {
            Write-Host "Service not found: $svcName" -ForegroundColor Yellow
            continue
        }

        if ($State -eq "Disable") {
            Write-Host "Disabling service: $svcName" -ForegroundColor Cyan
            try {
                Stop-Service $svcName -Force -ErrorAction SilentlyContinue
                Set-Service $svcName -StartupType Disabled -ErrorAction SilentlyContinue
            } catch {}
        }
        elseif ($State -eq "Enable") {
            Write-Host "Enabling service: $svcName" -ForegroundColor Cyan
            try {
                Set-Service $svcName -StartupType Automatic -ErrorAction SilentlyContinue
                Start-Service $svcName -ErrorAction SilentlyContinue
            } catch {}
        }
    }
}

function Apply-ServiceItem {
    param(
        [pscustomobject]$Item,
        [string]$State
    )

    Write-Host ""
    Write-Host "[Service Group: $($Item.DisplayName)]" -ForegroundColor Magenta
    Write-Host $Item.Description
    Set-ServicesState -ServiceNames $Item.Services -State $State
}

function Set-TasksState {
    param(
        [string[]]$TaskPaths,
        [string]$State
    )

    foreach ($path in $TaskPaths) {
        try {
            if ($path.EndsWith("*")) {
                $folderPath = Split-Path $path
                $tasks = Get-ScheduledTask -TaskPath $folderPath -ErrorAction SilentlyContinue
                if ($tasks) {
                    $tasks | ForEach-Object {
                        if ($State -eq "Disable") {
                            Write-Host "Disabling task: $($_.TaskName)" -ForegroundColor Cyan
                            Disable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath -ErrorAction SilentlyContinue
                        } else {
                            Write-Host "Enabling task: $($_.TaskName)" -ForegroundColor Cyan
                            Enable-ScheduledTask -TaskName $_.TaskName -TaskPath $_.TaskPath -ErrorAction SilentlyContinue
                        }
                    }
                }
            }
            else {
                $task = Get-ScheduledTask -TaskPath (Split-Path $path) -TaskName (Split-Path $path -Leaf) -ErrorAction SilentlyContinue
                if ($task) {
                    if ($State -eq "Disable") {
                        Write-Host "Disabling task: $path" -ForegroundColor Cyan
                        Disable-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -ErrorAction SilentlyContinue
                    } else {
                        Write-Host "Enabling task: $path" -ForegroundColor Cyan
                        Enable-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -ErrorAction SilentlyContinue
                    }
                } else {
                    Write-Host "Task not found: $path" -ForegroundColor Yellow
                }
            }
        } catch {}
    }
}

function Apply-TaskItem {
    param(
        [pscustomobject]$Item,
        [string]$State
    )

    Write-Host ""
    Write-Host "[Task Group: $($Item.DisplayName)]" -ForegroundColor Magenta
    Write-Host $Item.Description
    Set-TasksState -TaskPaths $Item.TaskPaths -State $State
}
# ============================================
#  PROFILES
# ============================================

function Apply-ProfilePerformance {
    Write-Host ""
    Write-Host "=== Applying PERFORMANCE MODE Profile ===" -ForegroundColor Magenta

    Disable-UIAnimations
    Set-HighPerformancePlan
    Set-DarkMode

    Remove-CommonBloat
    Disable-Suggestions
    Disable-Telemetry

    $perfServices = @(
        "XboxServices",
        "DiagTracking",
        "RetailDemo",
        "MapsServices",
        "PrintSpooler"
    )
    foreach ($svcKey in $perfServices) {
        $item = $ServiceItems | Where-Object { $_.Key -eq $svcKey }
        if ($item) { Apply-ServiceItem -Item $item -State "Disable" }
    }

    $perfTasks = @(
        "CEIP",
        "AppExperience",
        "MediaCenter",
        "MapsTasks"
    )
    foreach ($tskKey in $perfTasks) {
        $item = $TaskItems | Where-Object { $_.Key -eq $tskKey }
        if ($item) { Apply-TaskItem -Item $item -State "Disable" }
    }

    [System.Windows.MessageBox]::Show("Performance Mode applied.", "Yusuf WinUtil")
}

function Apply-ProfileGaming {
    Write-Host ""
    Write-Host "=== Applying GAMING MODE Profile ===" -ForegroundColor Magenta

    Disable-UIAnimations
    Set-HighPerformancePlan
    Set-DarkMode

    Remove-CommonBloat
    Disable-Suggestions
    Disable-Telemetry

    $gamingServices = @(
        "DiagTracking",
        "RetailDemo",
        "MapsServices"
    )
    foreach ($svcKey in $gamingServices) {
        $item = $ServiceItems | Where-Object { $_.Key -eq $svcKey }
        if ($item) { Apply-ServiceItem -Item $item -State "Disable" }
    }

    $gamingTasks = @(
        "CEIP",
        "AppExperience",
        "MapsTasks"
    )
    foreach ($tskKey in $gamingTasks) {
        $item = $TaskItems | Where-Object { $_.Key -eq $tskKey }
        if ($item) { Apply-TaskItem -Item $item -State "Disable" }
    }

    [System.Windows.MessageBox]::Show("Gaming Mode applied.", "Yusuf WinUtil")
}

function Apply-ProfileStreaming {
    Write-Host ""
    Write-Host "=== Applying STREAMING MODE Profile ===" -ForegroundColor Magenta

    Set-HighPerformancePlan
    Set-DarkMode
    Disable-UIAnimations

    Remove-CommonBloat
    Disable-Suggestions
    Disable-Telemetry

    $streamServices = @(
        "DiagTracking",
        "RetailDemo",
        "MapsServices"
    )
    foreach ($svcKey in $streamServices) {
        $item = $ServiceItems | Where-Object { $_.Key -eq $svcKey }
        if ($item) { Apply-ServiceItem -Item $item -State "Disable" }
    }

    $streamTasks = @(
        "CEIP",
        "AppExperience",
        "MapsTasks"
    )
    foreach ($tskKey in $streamTasks) {
        $item = $TaskItems | Where-Object { $_.Key -eq $tskKey }
        if ($item) { Apply-TaskItem -Item $item -State "Disable" }
    }

    [System.Windows.MessageBox]::Show("Streaming Mode applied.", "Yusuf WinUtil")
}

function Apply-ProfileWork {
    Write-Host ""
    Write-Host "=== Applying WORK MODE Profile ===" -ForegroundColor Magenta

    Set-DarkMode
    Set-HighPerformancePlan

    Remove-CommonBloat
    Disable-Suggestions
    Disable-Telemetry

    $workServices = @(
        "DiagTracking",
        "RetailDemo",
        "MapsServices"
    )
    foreach ($svcKey in $workServices) {
        $item = $ServiceItems | Where-Object { $_.Key -eq $svcKey }
        if ($item) { Apply-ServiceItem -Item $item -State "Disable" }
    }

    $workTasks = @(
        "CEIP",
        "AppExperience",
        "MapsTasks"
    )
    foreach ($tskKey in $workTasks) {
        $item = $TaskItems | Where-Object { $_.Key -eq $tskKey }
        if ($item) { Apply-TaskItem -Item $item -State "Disable" }
    }

    [System.Windows.MessageBox]::Show("Work Mode applied.", "Yusuf WinUtil")
}

# ============================================
#  POPULATE LISTS
# ============================================
$ServiceItems | ForEach-Object { [void]$ServicesList.Items.Add($_) }
$TaskItems    | ForEach-Object { [void]$TasksList.Items.Add($_) }

$ServicesList.Add_SelectionChanged({
    $item = $ServicesList.SelectedItem
    if ($item) {
        $ServiceDescBox.Text = $item.Description
    }
})

$TasksList.Add_SelectionChanged({
    $item = $TasksList.SelectedItem
    if ($item) {
        $TaskDescBox.Text = $item.Description
    }
})

if ($ServicesList.Items.Count -gt 0) {
    $ServicesList.SelectedIndex = 0
}
if ($TasksList.Items.Count -gt 0) {
    $TasksList.SelectedIndex = 0
}

# ============================================
#  EVENT WIRING
# ============================================
$InstallSelectedApps.Add_Click({
    Install-SelectedApps -ListBox $AppsList
})

$RefreshAppsBtn.Add_Click({
    [System.Windows.MessageBox]::Show("Static list in this version. Extend AppMap to add more.", "Yusuf WinUtil")
})

$RunDebloatBtn.Add_Click({
    Run-Debloat -RemoveBloatware $RemoveBloatwareChk.IsChecked `
                -DisableTelemetry $DisableTelemetryChk.IsChecked `
                -DisableSuggestions $DisableSuggestionsChk.IsChecked
})

$ApplyTweaksBtn.Add_Click({
    Apply-Tweaks -DarkMode $EnableDarkModeChk.IsChecked `
                 -DisableAnimations $DisableAnimationsChk.IsChecked `
                 -HighPerfPower $SetHighPerfPowerChk.IsChecked
})

$BackupConfigBtn.Add_Click({
    Backup-Config -StatusControl $BackupStatusTxt
})

$RestoreConfigBtn.Add_Click({
    Restore-Config -StatusControl $BackupStatusTxt
})

$TestLatencyBtn.Add_Click({
    Test-Latency -Host $LatencyHostTxt.Text -OutputControl $LatencyOutputTxt
})

$ApplyServicesBtn.Add_Click({
    $item = $ServicesList.SelectedItem
    if ($item) {
        Apply-ServiceItem -Item $item -State "Disable"
        [System.Windows.MessageBox]::Show("Service group applied (disabled). Check console for details.", "Yusuf WinUtil")
    }
})

$ApplyTasksBtn.Add_Click({
    $item = $TasksList.SelectedItem
    if ($item) {
        Apply-TaskItem -Item $item -State "Disable"
        [System.Windows.MessageBox]::Show("Task group applied (disabled). Check console for details.", "Yusuf WinUtil")
    }
})

$GamingProfileBtn.Add_Click({
    Apply-ProfileGaming
})

$StreamingProfileBtn.Add_Click({
    Apply-ProfileStreaming
})

$WorkProfileBtn.Add_Click({
    Apply-ProfileWork
})

$PerformanceProfileBtn.Add_Click({
    Apply-ProfilePerformance
})

# ============================================
#  RUN WINDOW
# ============================================
$window.ShowDialog() | Out-Null
