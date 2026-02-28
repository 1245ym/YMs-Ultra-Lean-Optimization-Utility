Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# --- 1. DEFINE SECTIONS AND TWEAKS ---
$Sections = @{}

# --- Gaming Performance (15 real tweaks) ---
$Sections["Gaming Performance"] = @(
    [PSCustomObject]@{ Name="Disable GameDVR"; Cat="Gaming Performance"; Ben="Stops Xbox Game Bar recording to save CPU/GPU."; Cmd={ Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 } },
    [PSCustomObject]@{ Name="Enable HAGS"; Cat="Gaming Performance"; Ben="Hardware-accelerated GPU scheduling."; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Type DWord -Value 2 } },
    [PSCustomObject]@{ Name="Disable Fullscreen Optimizations"; Cat="Gaming Performance"; Ben="Prevents Windows auto-optimizing fullscreen games."; Cmd={ Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehaviorMode" -Value 0 } },
    [PSCustomObject]@{ Name="Set GPU Priority High"; Cat="Gaming Performance"; Ben="Prioritize GPU for games over background apps."; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8 } },
    [PSCustomObject]@{ Name="Disable Power Throttling"; Cat="Gaming Performance"; Ben="Prevents CPU downclocking during intense sessions."; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1 } },
    [PSCustomObject]@{ Name="Disable Nagle Algorithm"; Cat="Gaming Performance"; Ben="Reduces network latency for online gaming."; Cmd={ New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpAckFrequency" -PropertyType DWord -Value 1 -Force } },
    [PSCustomObject]@{ Name="Increase Network Packet Priority"; Cat="Gaming Performance"; Ben="Boosts gaming packets priority."; Cmd={ New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -PropertyType DWord -Value 0 -Force } },
    [PSCustomObject]@{ Name="Disable Mouse Acceleration"; Cat="Gaming Performance"; Ben="Prevents input lag due to pointer acceleration."; Cmd={ Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0; Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0; Set-ItemProperty -Path "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0 } },
    [PSCustomObject]@{ Name="Enable High Precision Timer"; Cat="Gaming Performance"; Ben="Improves game frame timing."; Cmd={ New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel" -Name "PerfCountFrequency" -PropertyType DWord -Value 1 -Force } },
    [PSCustomObject]@{ Name="Disable Xbox Services"; Cat="Gaming Performance"; Ben="Removes unnecessary Xbox background services."; Cmd={ Stop-Service "XblGameSave" -ErrorAction SilentlyContinue; Set-Service "XblGameSave" -StartupType Disabled } },
    [PSCustomObject]@{ Name="Set Game Priority to High"; Cat="Gaming Performance"; Ben="Automatically prioritizes game processes in Task Manager."; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "Priority" -Value 6 } },
    [PSCustomObject]@{ Name="Disable Fullscreen AutoMinimize"; Cat="Gaming Performance"; Ben="Prevents Windows from minimizing games automatically when Alt+Tabbing."; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableAutoMinimize" -Value 1 } },
    [PSCustomObject]@{ Name="Disable GPU Background Throttling"; Cat="Gaming Performance"; Ben="Prevents GPU from downclocking when idle."; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "TdrLevel" -Value 0 } },
    [PSCustomObject]@{ Name="Disable V-Sync"; Cat="Gaming Performance"; Ben="Reduces input lag in games."; Cmd={ Set-ItemProperty -Path "HKCU:\Software\NVIDIA Corporation\Global\NvCplApi\Policies" -Name "SyncToVBlank" -Value 0 -Force } },
    [PSCustomObject]@{ Name="Disable Windows Game Recording Overlay"; Cat="Gaming Performance"; Ben="Removes overlay that can reduce FPS."; Cmd={ Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 } }
)

# --- Network & Internet (15 real tweaks) ---
$Sections["Network & Internet"] = @(
    [PSCustomObject]@{ Name="Enable TCP RSS"; Cat="Network & Internet"; Ben="Allows multi-core CPU handling of network packets."; Cmd={ netsh int tcp set global rss=enabled } },
    [PSCustomObject]@{ Name="Flush DNS Cache"; Cat="Network & Internet"; Ben="Clears stale DNS and resets Winsock."; Cmd={ ipconfig /flushdns; netsh winsock reset } },
    [PSCustomObject]@{ Name="Enable TCP Fast Open"; Cat="Network & Internet"; Ben="Speeds up TCP handshake."; Cmd={ netsh int tcp set global fastopen=enabled } },
    [PSCustomObject]@{ Name="Increase Max User Ports"; Cat="Network & Internet"; Ben="Allows more simultaneous connections."; Cmd={ netsh int ipv4 set dynamicport tcp start=1025 num=65535 } },
    [PSCustomObject]@{ Name="Disable NetBIOS over TCP"; Cat="Network & Internet"; Ben="Improves network security."; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\NetBT\Parameters" -Name "EnableNetbios" -Value 0 } },
    [PSCustomObject]@{ Name="Increase TCP Window Size"; Cat="Network & Internet"; Ben="Boosts download speeds on high-latency networks."; Cmd={ New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "TcpWindowSize" -PropertyType DWord -Value 131400 -Force } },
    [PSCustomObject]@{ Name="Disable IPv6 (if unused)"; Cat="Network & Internet"; Ben="Avoids network issues if IPv6 is not used."; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\TCPIP6\Parameters" -Name "DisabledComponents" -Value 0xFF -Force } },
    [PSCustomObject]@{ Name="Set DNS to Google"; Cat="Network & Internet"; Ben="Faster, reliable DNS resolution."; Cmd={ Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses "8.8.8.8","8.8.4.4" } },
    [PSCustomObject]@{ Name="Enable Jumbo Frames"; Cat="Network & Internet"; Ben="Reduces network overhead for large transfers."; Cmd={ Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Jumbo Packet" -DisplayValue "9014 Bytes" } },
    [PSCustomObject]@{ Name="Disable Windows Auto-Tuning"; Cat="Network & Internet"; Ben="Reduces latency in some network scenarios."; Cmd={ netsh interface tcp set global autotuninglevel=disabled } },
    [PSCustomObject]@{ Name="Disable SMBv1"; Cat="Network & Internet"; Ben="Improves security by disabling outdated SMBv1 protocol."; Cmd={ Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name "SMB1" -Value 0 } },
    [PSCustomObject]@{ Name="Enable TCP Chimney Offload"; Cat="Network & Internet"; Ben="Allows network offloading to reduce CPU load."; Cmd={ netsh int tcp set global chimney=enabled } },
    [PSCustomObject]@{ Name="Set Network Profile to Private"; Cat="Network & Internet"; Ben="Secures PC on local networks."; Cmd={ Set-NetConnectionProfile -InterfaceAlias "Ethernet" -NetworkCategory Private } },
    [PSCustomObject]@{ Name="Disable Large Send Offload"; Cat="Network & Internet"; Ben="Reduces packet segmentation latency."; Cmd={ Set-NetAdapterAdvancedProperty -Name "*" -DisplayName "Large Send Offload" -DisplayValue "Disabled" } },
    [PSCustomObject]@{ Name="Disable Windows Peer-to-Peer Updates"; Cat="Network & Internet"; Ben="Prevents using your PC to upload updates."; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" -Name "DODownloadMode" -Value 0 } }
)

# --- Privacy & Security (15 real tweaks) ---
$Sections["Privacy & Security"] = @(
    [PSCustomObject]@{ Name="Disable Telemetry"; Cat="Privacy & Security"; Ben="Stops Windows telemetry and data collection."; Cmd={ Stop-Service 'DiagTrack' -ErrorAction SilentlyContinue; Set-Service 'DiagTrack' -StartupType Disabled } },
    [PSCustomObject]@{ Name="Disable Advertising ID"; Cat="Privacy & Security"; Ben="Stops personalized ads."; Cmd={ Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0 } },
    [PSCustomObject]@{ Name="Disable Feedback Requests"; Cat="Privacy & Security"; Ben="Stops Windows asking for feedback."; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Siuf\Rules" -Name "NumberOfSIUFInPeriod" -Value 0 -Force } },
    [PSCustomObject]@{ Name="Disable Cortana"; Cat="Privacy & Security"; Ben="Prevents Cortana background activity."; Cmd={ Stop-Service "WSearch" -ErrorAction SilentlyContinue; Set-Service "WSearch" -StartupType Disabled } },
    [PSCustomObject]@{ Name="Disable Location Tracking"; Cat="Privacy & Security"; Ben="Stops Windows from tracking your location."; Cmd={ Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny" } },
    [PSCustomObject]@{ Name="Disable OneDrive"; Cat="Privacy & Security"; Ben="Stops OneDrive syncing."; Cmd={ Stop-Service "OneSyncSvc" -ErrorAction SilentlyContinue; Set-Service "OneSyncSvc" -StartupType Disabled } },
    [PSCustomObject]@{ Name="Disable Windows Error Reporting"; Cat="Privacy & Security"; Ben="Prevents error reporting pop-ups."; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 1 } },
    [PSCustomObject]@{ Name="Disable App Suggestions"; Cat="Privacy & Security"; Ben="Prevents Windows from suggesting apps."; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0 } },
    [PSCustomObject]@{ Name="Disable Background Apps"; Cat="Privacy & Security"; Ben="Stops unnecessary apps running in background."; Cmd={ Get-Process | Where-Object {$_.Name -in @("MicrosoftEdge","OneDrive") } | Stop-Process -Force } },
    [PSCustomObject]@{ Name="Disable Windows Spotlight"; Cat="Privacy & Security"; Ben="Prevents Spotlight background downloads."; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenEnabled" -Value 0 } },
    [PSCustomObject]@{ Name="Disable Diagnostic Tracking"; Cat="Privacy & Security"; Ben="Reduces telemetry and diagnostics."; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0 } },
    [PSCustomObject]@{ Name="Disable Connected User Experience"; Cat="Privacy & Security"; Ben="Prevents background data uploads."; Cmd={ Stop-Service "DiagTrack" -ErrorAction SilentlyContinue } },
    [PSCustomObject]@{ Name="Disable SmartScreen"; Cat="Privacy & Security"; Ben="Reduces SmartScreen filtering (not recommended for security)."; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Value "Off" } },
    [PSCustomObject]@{ Name="Disable Wi-Fi Sense"; Cat="Privacy & Security"; Ben="Prevents automatic Wi-Fi sharing."; Cmd={ Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "AutoConnectAllowedOEM" -Value 0 } },
    [PSCustomObject]@{ Name="Disable Cortana Cloud Search"; Cat="Privacy & Security"; Ben="Prevents Cortana from sending search queries online."; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Value 0 } }
)

# --- Winget Apps (15 apps) ---
$Sections["Winget Apps"] = @(
    [PSCustomObject]@{ Name="Install Google Chrome"; Cat="Winget Apps"; Ben="Installs Google Chrome via winget."; Cmd={ & winget install --id "Google.Chrome" -e } },
    [PSCustomObject]@{ Name="Install 7-Zip"; Cat="Winget Apps"; Ben="Installs 7-Zip via winget."; Cmd={ & winget install --id "7zip.7zip" -e } },
    [PSCustomObject]@{ Name="Install VLC"; Cat="Winget Apps"; Ben="Installs VLC Media Player."; Cmd={ & winget install --id "VideoLAN.VLC" -e } },
    [PSCustomObject]@{ Name="Install Firefox"; Cat="Winget Apps"; Ben="Installs Mozilla Firefox."; Cmd={ & winget install --id "Mozilla.Firefox" -e } },
    [PSCustomObject]@{ Name="Install Discord"; Cat="Winget Apps"; Ben="Installs Discord client."; Cmd={ & winget install --id "Discord.Discord" -e } },
    [PSCustomObject]@{ Name="Install Notepad++"; Cat="Winget Apps"; Ben="Installs Notepad++ editor."; Cmd={ & winget install --id "Notepad++.Notepad++" -e } },
    [PSCustomObject]@{ Name="Install Spotify"; Cat="Winget Apps"; Ben="Installs Spotify music app."; Cmd={ & winget install --id "Spotify.Spotify" -e } },
    [PSCustomObject]@{ Name="Install Steam"; Cat="Winget Apps"; Ben="Installs Steam client."; Cmd={ & winget install --id "Valve.Steam" -e } },
    [PSCustomObject]@{ Name="Install OBS Studio"; Cat="Winget Apps"; Ben="Installs OBS Studio."; Cmd={ & winget install --id "OBSProject.OBSStudio" -e } },
    [PSCustomObject]@{ Name="Install Zoom"; Cat="Winget Apps"; Ben="Installs Zoom client."; Cmd={ & winget install --id "Zoom.Zoom" -e } },
    [PSCustomObject]@{ Name="Install Microsoft Edge"; Cat="Winget Apps"; Ben="Installs Edge browser."; Cmd={ & winget install --id "Microsoft.Edge" -e } },
    [PSCustomObject]@{ Name="Install Paint.NET"; Cat="Winget Apps"; Ben="Installs Paint.NET editor."; Cmd={ & winget install --id "dotPDN.Paint.NET" -e } },
    [PSCustomObject]@{ Name="Install FileZilla"; Cat="Winget Apps"; Ben="Installs FileZilla FTP client."; Cmd={ & winget install --id "FileZilla.FileZilla" -e } },
    [PSCustomObject]@{ Name="Install Git"; Cat="Winget Apps"; Ben="Installs Git for version control."; Cmd={ & winget install --id "Git.Git" -e } },
    [PSCustomObject]@{ Name="Install VS Code"; Cat="Winget Apps"; Ben="Installs Visual Studio Code."; Cmd={ & winget install --id "Microsoft.VisualStudioCode" -e } }
)

# --- GUI and Buttons ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Ultra Lean Optimization Utility - Full Control Center"
$Form.Size = New-Object System.Drawing.Size(1200, 900)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = [System.Drawing.Color]::FromArgb(10,10,15)

$Intel = New-Object System.Windows.Forms.Label
$Intel.Text = ">>> Hover over a tweak to see its benefit."
$Intel.Font = New-Object System.Drawing.Font("Consolas",12,[System.Drawing.FontStyle]::Bold)
$Intel.ForeColor = [System.Drawing.Color]::Lime
$Intel.BackColor = [System.Drawing.Color]::FromArgb(20,20,25)
$Intel.Size = New-Object System.Drawing.Size(1150,50)
$Intel.Location = New-Object System.Drawing.Point(20,10)
$Intel.TextAlign = "MiddleCenter"
$Intel.BorderStyle = "FixedSingle"
$Form.Controls.Add($Intel)

$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Size = New-
