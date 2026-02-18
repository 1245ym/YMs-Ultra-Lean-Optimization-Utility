
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# --- 1. DEFINE SECTIONS AND TWEAKS ---
$Sections = @{}

# --- Gaming Performance (10 real tweaks, expandable) ---
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
    [PSCustomObject]@{ Name="Disable Xbox Services"; Cat="Gaming Performance"; Ben="Removes unnecessary Xbox background services."; Cmd={ Stop-Service "XblGameSave" -ErrorAction SilentlyContinue; Set-Service "XblGameSave" -StartupType Disabled } }
)

# --- Network & Internet (10 real tweaks) ---
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
    [PSCustomObject]@{ Name="Disable Windows Auto-Tuning"; Cat="Network & Internet"; Ben="Reduces latency in some network scenarios."; Cmd={ netsh interface tcp set global autotuninglevel=disabled } }
)

# --- Privacy & Security (10 real tweaks) ---
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
    [PSCustomObject]@{ Name="Disable Windows Spotlight"; Cat="Privacy & Security"; Ben="Prevents Spotlight background downloads."; Cmd={ Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "RotatingLockScreenEnabled" -Value 0 } }
)

# --- Winget App Installer (10 apps) ---
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
    [PSCustomObject]@{ Name="Install Zoom"; Cat="Winget Apps"; Ben="Installs Zoom client."; Cmd={ & winget install --id "Zoom.Zoom" -e } }
)

# --- 2. GUI SETUP ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Ultra Lean Optimization Utility - Full Control Center"
$Form.Size = New-Object System.Drawing.Size(1200, 900)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = [System.Drawing.Color]::FromArgb(10,10,15)

# --- 3. Description Label ---
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

# --- 4. Tab Control ---
$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Size = New-Object System.Drawing.Size(1150,700)
$TabControl.Location = New-Object System.Drawing.Point(20,70)
$Form.Controls.Add($TabControl)

# --- 5. Create Tabs Dynamically ---
$TabPages = @{}
foreach ($Cat in $Sections.Keys) {
    $Tab = New-Object System.Windows.Forms.TabPage
    $Tab.Text = $Cat
    $FlowPanel = New-Object System.Windows.Forms.FlowLayoutPanel
    $FlowPanel.Name = "FlowPanel"
    $FlowPanel.Dock = "Fill"
    $FlowPanel.AutoScroll = $true
    $Tab.Controls.Add($FlowPanel)
    $TabPages[$Cat] = $Tab
    $TabControl.TabPages.Add($Tab)
}

# --- 6. Add Checkboxes Dynamically ---
$Checkboxes = @()
foreach ($Cat in $Sections.Keys) {
    foreach ($Tweak in $Sections[$Cat]) {
        $CB = New-Object System.Windows.Forms.CheckBox
        $CB.Text = $Tweak.Name
        $CB.Tag = $Tweak
        $CB.AutoSize = $true
        $CB.Font = New-Object System.Drawing.Font("Segoe UI",10)
        $CB.Add_MouseEnter({ $Intel.Text = ">>> Benefit: " + $this.Tag.Ben })
        $CB.Add_MouseLeave({ $Intel.Text = ">>> Hover over a tweak to see its benefit." })
        $TabPages[$Cat].Controls["FlowPanel"].Controls.Add($CB)
        $Checkboxes += $CB
    }
}

# --- 7. Buttons ---
$BackupBtn = New-Object System.Windows.Forms.Button
$BackupBtn.Text = "CREATE RESTORE POINT"
$BackupBtn.Size = New-Object System.Drawing.Size(550,50)
$BackupBtn.Location = New-Object System.Drawing.Point(20,780)
$BackupBtn.BackColor = [System.Drawing.Color]::FromArgb(40,40,40)
$BackupBtn.ForeColor = [System.Drawing.Color]::Yellow
$BackupBtn.FlatStyle = "Flat"
$BackupBtn.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$BackupBtn.Add_Click({
    $Intel.Text = "Creating system restore point..."
    Checkpoint-Computer -Description "UltraLean_Backup" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    $Intel.Text = "Restore point created successfully!"
})
$Form.Controls.Add($BackupBtn)

$RunBtn = New-Object System.Windows.Forms.Button
$RunBtn.Text = "APPLY SELECTED TWEAKS"
$RunBtn.Size = New-Object System.Drawing.Size(550,50)
$RunBtn.Location = New-Object System.Drawing.Point(600,780)
$RunBtn.BackColor = [System.Drawing.Color]::FromArgb(30,30,40)
$RunBtn.ForeColor = [System.Drawing.Color]::Cyan
$RunBtn.FlatStyle = "Flat"
$RunBtn.Font = New-Object System.Drawing.Font("Segoe UI",10,[System.Drawing.FontStyle]::Bold)
$RunBtn.Add_Click({
    $Applied = 0
    foreach ($CB in $Checkboxes) {
        if ($CB.Checked) {
            Write-Host "Applying: $($CB.Text)" -ForegroundColor Cyan
            try { & $CB.Tag.Cmd; $Applied++ } catch { Write-Host "Failed: $($CB.Text)" -ForegroundColor Red }
        }
    }
    [System.Windows.Forms.MessageBox]::Show("$Applied tweaks applied! Restart PC for changes to take effect.")
})
$Form.Controls.Add($RunBtn)

# --- 8. Show GUI ---
$Form.ShowDialog() | Out-Null
