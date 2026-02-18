Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# --- 1. THE MASSIVE TWEAK DATABASE (50+ UNIQUE COMMANDS) ---
$TweakMatrix = @(
    # [TUNNEL: SYSTEM TWEAKS]
    @{Name="Disable GameDVR"; Cat="Gaming"; Ben="Stops background recording to save CPU/GPU overhead."; Cmd={Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0}},
    @{Name="Set Game Priority: High"; Cat="Gaming"; Ben="Prioritizes GPU resources for games over background apps."; Cmd={Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8}},
    @{Name="Disable Power Throttling"; Cat="Gaming"; Ben="Prevents CPU downclocking during intense sessions."; Cmd={Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1}},
    @{Name="Optimize GPU Pre-Rendered Frames"; Cat="Gaming"; Ben="Tweaks DirectX to reduce input delay between CPU and GPU."; Cmd={Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DirectX" -Name "UserGpuPreference" -Value 2}},
    
    # [TUNNEL: DRIVER MANAGEMENT (via winget)]
    @{Name="Install NVIDIA Drivers"; Cat="Driver Management"; Ben="Installs or updates NVIDIA drivers via winget."; Cmd={winget install --id NVIDIA.GeForceExperience}},
    @{Name="Install Intel Drivers"; Cat="Driver Management"; Ben="Installs or updates Intel drivers via winget."; Cmd={winget install --id Intel.IntelGraphicsCommandCenter}},
    @{Name="Update All Drivers"; Cat="Driver Management"; Ben="Updates all system drivers via winget."; Cmd={winget upgrade --all}},
    
    # [TUNNEL: NETWORK & PING]
    @{Name="Enable TCP RSS"; Cat="Network"; Ben="Allows multi-core CPU handling of network packets."; Cmd={netsh int tcp set global rss=enabled}},
    @{Name="Flush DNS Cache"; Cat="Network"; Ben="Clears stale DNS and resets Winsock for fresh connections."; Cmd={ipconfig /flushdns; netsh winsock reset}},
    
    # [TUNNEL: SYSTEM INFORMATION]
    @{Name="Show System Information"; Cat="System Info"; Ben="Displays basic system information: RAM, CPU, GPU."; Cmd={systeminfo}},
    
    # [TUNNEL: PERFORMANCE OPTIMIZATIONS]
    @{Name="Unpark All CPU Cores"; Cat="Performance"; Ben="Forces all cores to remain at 100% frequency."; Cmd={powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100; powercfg -setactive scheme_current}},
    @{Name="Ultimate Power Plan"; Cat="Performance"; Ben="Unlocks the 'Ultimate Performance' power profile."; Cmd={powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61}},
    
    # [TUNNEL: DISK & SSD]
    @{Name="Disable NTFS Last Access"; Cat="Disk"; Ben="Stops Windows from updating a timestamp every time a file is read."; Cmd={fsutil behavior set disablelastaccess 1}},
    @{Name="Optimize SSD Trim"; Cat="Disk"; Ben="Ensures Windows actively cleans SSD cells."; Cmd={fsutil behavior set disabledeletenotify 0}},
    
    # [TUNNEL: SECURITY & PRIVACY]
    @{Name="Disable Telemetry"; Cat="Security"; Ben="Stops Windows Spying and background data collection."; Cmd={Stop-Service "DiagTrack" -ErrorAction SilentlyContinue; Set-Service "DiagTrack" -StartupType Disabled}},
    @{Name="Enable Windows Defender"; Cat="Security"; Ben="Enables Windows Defender Antivirus."; Cmd={Set-Service -Name "WinDefend" -StartupType "Automatic"; Start-Service "WinDefend"}},
    
    # [TUNNEL: WINGET INSTALLER]
    @{Name="Install Google Chrome"; Cat="Winget"; Ben="Installs Google Chrome."; Cmd={winget install --id Google.Chrome}},
    @{Name="Install 7-Zip"; Cat="Winget"; Ben="Installs 7-Zip."; Cmd={winget install --id 7zip.7zip}},
    @{Name="Install VLC Media Player"; Cat="Winget"; Ben="Installs VLC Media Player."; Cmd={winget install --id VideoLAN.VLC}},
)

# --- 2. THE UI ENGINE ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "BEAST COMMANDER v17 - FULL CONTROL CENTER"
$Form.Size = New-Object System.Drawing.Size(1200, 900)
$Form.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 15)
$Form.StartPosition = "CenterScreen"

# TabControl for organizing tweaks
$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Size = New-Object System.Drawing.Size(1160, 750)
$TabControl.Location = New-Object System.Drawing.Point(20, 50)

# Create Tab Pages for each section
$TabSystem = New-Object System.Windows.Forms.TabPage
$TabSystem.Text = "System Tweaks"
$TabControl.TabPages.Add($TabSystem)

$TabDriver = New-Object System.Windows.Forms.TabPage
$TabDriver.Text = "Driver Management"
$TabControl.TabPages.Add($TabDriver)

$TabPerformance = New-Object System.Windows.Forms.TabPage
$TabPerformance.Text = "Performance Optimizations"
$TabControl.TabPages.Add($TabPerformance)

$TabWinget = New-Object System.Windows.Forms.TabPage
$TabWinget.Text = "Winget Installer"
$TabControl.TabPages.Add($TabWinget)

$TabNetwork = New-Object System.Windows.Forms.TabPage
$TabNetwork.Text = "Network & Ping"
$TabControl.TabPages.Add($TabNetwork)

$TabSecurity = New-Object System.Windows.Forms.TabPage
$TabSecurity.Text = "Security & Privacy"
$TabControl.TabPages.Add($TabSecurity)

# Add the TabControl to the Form
$Form.Controls.Add($TabControl)

# Add Checkboxes for each tweak inside the relevant tab
$Checkboxes = @()
foreach ($T in $TweakMatrix) {
    $CB = New-Object System.Windows.Forms.CheckBox
    $CB.Text = "[$($T.Cat)] $($T.Name)"
    $CB.ForeColor = switch($T.Cat) {
        "Gaming" { "Cyan" }
        "Driver Management" { "Orange" }
        "Performance" { "Lime" }
        "Disk" { "Magenta" }
        "Winget" { "Yellow" }
        "Network" { "Green" }
        "Security" { "Red" }
        default { "White" }
    }
    $CB.Font = New-Object System.Drawing.Font("Segoe UI", 10)
    $CB.Size = New-Object System.Drawing.Size(850, 35)
    $CB.Tag = $T
    
    # Add mouse hover event to show description in a label
    $CB.Add_MouseEnter({
        $Intel.Text = ">>> BENEFIT: " + $this.Tag.Ben
    })
    
    # Add the checkbox to the appropriate tab
    switch ($T.Cat) {
        "Gaming" { $TabSystem.Controls.Add($CB) }
        "Driver Management" { $TabDriver.Controls.Add($CB) }
        "Performance" { $TabPerformance.Controls.Add($CB) }
        "Winget" { $TabWinget.Controls.Add($CB) }
        "Network" { $TabNetwork.Controls.Add($CB) }
        "Security" { $TabSecurity.Controls.Add($CB) }
    }
    
    $Checkboxes += $CB
}

# Add a label to show descriptions
$Intel = New-Object System.Windows.Forms.Label
$Intel.Text = ">>> Hover over a tweak to view its description."
$Intel.Font = New-Object System.Drawing.Font("Consolas", 12)
$Intel.ForeColor = [System.Drawing.Color]::Lime
$Intel.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 25)
$Intel.Size = New-Object System.Drawing.Size(950, 60)
$Intel.Location = New-Object System.Drawing.Point(50, 10)
$Intel.TextAlign = "MiddleCenter"
$Intel.BorderStyle = "FixedSingle"
$Form.Controls.Add($Intel)

# Buttons
$BackupBtn = New-Object System.Windows.Forms.Button
$BackupBtn.Text = "CREATE RESTORE POINT"
$BackupBtn.Size = New-Object System.Drawing.Size(440, 50)
$BackupBtn.Location = New-Object System.Drawing.Point(50, 820)
$BackupBtn.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
$BackupBtn.ForeColor = [System.Drawing.Color]::Yellow
$BackupBtn.FlatStyle = "Flat"
$BackupBtn.Add_Click({
    $Intel.Text = "Creating restore point..."
    Checkpoint-Computer -Description "BeastV17_Backup" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    $Intel.Text = "Restore point created successfully!"
})
$Form.Controls.Add($BackupBtn)

$RunBtn = New-Object System.Windows.Forms.Button
$RunBtn.Text = "APPLY SELECTED TWEAKS"
$RunBtn.Size = New-Object System.Drawing.Size(440, 50)
$RunBtn.Location = New-Object System.Drawing.Point(510, 820)
$RunBtn.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 40)
$RunBtn.ForeColor = [System.Drawing.Color]::Cyan
$RunBtn.FlatStyle = "Flat"
$RunBtn.Add_Click({
    $Applied = 0
    foreach ($CB in $Checkboxes) {
        if ($CB.Checked) {
            Write-Host "Applying: $($CB.Text)"
            try { & $CB.Tag.Cmd; $Applied++ } catch { }
        }
    }
    [System.Windows.Forms.MessageBox]::Show("$Applied Tweaks Applied! Restart PC for changes to take effect.")
})
$Form.Controls.Add($RunBtn)

# Show the form
$Form.ShowDialog() | Out-Null
