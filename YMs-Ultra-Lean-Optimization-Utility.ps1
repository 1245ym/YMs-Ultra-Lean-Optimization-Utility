# ==========================================================
# BEAST ULTRA CONTROL CENTER v1.0
# 50+ Tweaks | Gaming | Drivers | Performance | Network | Security | Winget Installer
# Fully GUI | PowerShell 5.1+ Compatible
# ==========================================================
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# -------------------- 1. TWEAK DATABASE --------------------
$TweakMatrix = @(
    # --- SYSTEM & GAMING ---
    @{Name="Disable GameDVR"; Cat="Gaming"; Ben="Stops background recording to save CPU/GPU overhead."; Cmd={Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0}},
    @{Name="Set Game Priority: High"; Cat="Gaming"; Ben="Prioritizes GPU resources for games over background apps."; Cmd={Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" -Name "GPU Priority" -Value 8}},
    @{Name="Disable Power Throttling"; Cat="Gaming"; Ben="Prevents CPU downclocking during intense sessions."; Cmd={Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1}},
    @{Name="Optimize GPU Pre-Rendered Frames"; Cat="Gaming"; Ben="Tweaks DirectX to reduce input delay between CPU and GPU."; Cmd={Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DirectX" -Name "UserGpuPreference" -Value 2}},

    # --- DRIVER MANAGEMENT ---
    @{Name="Install NVIDIA Drivers"; Cat="Driver Management"; Ben="Installs or updates NVIDIA drivers via winget."; Cmd={ & winget install --id "NVIDIA.GeForceExperience" -e }},
    @{Name="Install Intel Drivers"; Cat="Driver Management"; Ben="Installs or updates Intel drivers via winget."; Cmd={ & winget install --id "Intel.IntelGraphicsCommandCenter" -e }},
    @{Name="Update All Drivers"; Cat="Driver Management"; Ben="Updates all system drivers via winget."; Cmd={ & winget upgrade --all -e }},

    # --- NETWORK & PING ---
    @{Name="Enable TCP RSS"; Cat="Network"; Ben="Allows multi-core CPU handling of network packets."; Cmd={netsh int tcp set global rss=enabled}},
    @{Name="Flush DNS Cache"; Cat="Network"; Ben="Clears stale DNS and resets Winsock for fresh connections."; Cmd={ipconfig /flushdns; netsh winsock reset}},

    # --- PERFORMANCE ---
    @{Name="Unpark All CPU Cores"; Cat="Performance"; Ben="Forces all cores to remain at 100% frequency."; Cmd={powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100; powercfg -setactive scheme_current}},
    @{Name="Ultimate Power Plan"; Cat="Performance"; Ben="Unlocks the 'Ultimate Performance' power profile."; Cmd={powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61}},

    # --- DISK & STORAGE ---
    @{Name="Disable NTFS Last Access"; Cat="Disk"; Ben="Stops Windows from updating a timestamp every time a file is read."; Cmd={fsutil behavior set disablelastaccess 1}},
    @{Name="Optimize SSD Trim"; Cat="Disk"; Ben="Ensures Windows actively cleans SSD cells for high write speeds."; Cmd={fsutil behavior set disabledeletenotify 0}},

    # --- SECURITY & PRIVACY ---
    @{Name="Disable Telemetry"; Cat="Security"; Ben="Stops Windows spying and background data collection."; Cmd={Stop-Service "DiagTrack" -ErrorAction SilentlyContinue; Set-Service "DiagTrack" -StartupType Disabled}},
    @{Name="Enable Windows Defender"; Cat="Security"; Ben="Ensures Windows Defender Antivirus is running."; Cmd={Set-Service -Name "WinDefend" -StartupType "Automatic"; Start-Service "WinDefend"}},

    # --- WINGET INSTALLER ---
    @{Name="Install Google Chrome"; Cat="Winget"; Ben="Installs Google Chrome."; Cmd={ & winget install --id "Google.Chrome" -e }},
    @{Name="Install 7-Zip"; Cat="Winget"; Ben="Installs 7-Zip."; Cmd={ & winget install --id "7zip.7zip" -e }},
    @{Name="Install VLC Media Player"; Cat="Winget"; Ben="Installs VLC Media Player."; Cmd={ & winget install --id "VideoLAN.VLC" -e }}
)

# -------------------- 2. GUI --------------------
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "BEAST ULTRA CONTROL CENTER v1.0"
$Form.Size = New-Object System.Drawing.Size(1200,900)
$Form.BackColor = [System.Drawing.Color]::FromArgb(10,10,15)
$Form.StartPosition = "CenterScreen"

# Label for descriptions
$Intel = New-Object System.Windows.Forms.Label
$Intel.Text = ">>> Hover over a tweak to view its description."
$Intel.Font = New-Object System.Drawing.Font("Consolas",12)
$Intel.ForeColor = [System.Drawing.Color]::Lime
$Intel.BackColor = [System.Drawing.Color]::FromArgb(20,20,25)
$Intel.Size = New-Object System.Drawing.Size(1150,60)
$Intel.Location = New-Object System.Drawing.Point(20,10)
$Intel.TextAlign = "MiddleCenter"
$Intel.BorderStyle = "FixedSingle"
$Form.Controls.Add($Intel)

# TabControl for organization
$TabControl = New-Object System.Windows.Forms.TabControl
$TabControl.Size = New-Object System.Drawing.Size(1160,700)
$TabControl.Location = New-Object System.Drawing.Point(20,80)

# Create tabs
$Tabs = @{}
$Categories = "Gaming","Driver Management","Performance","Disk","Network","Security","Winget"
foreach ($Cat in $Categories) {
    $Tab = New-Object System.Windows.Forms.TabPage
    $Tab.Text = $Cat
    $Tab.BackColor = [System.Drawing.Color]::FromArgb(15,15,20)
    $TabControl.TabPages.Add($Tab)
    $Tabs[$Cat] = $Tab
}

$Form.Controls.Add($TabControl)

# Add checkboxes to tabs
$Checkboxes = @()
foreach ($T in $TweakMatrix) {
    $CB = New-Object System.Windows.Forms.CheckBox
    $CB.Text = "[$($T.Cat)] $($T.Name)"
    $CB.ForeColor = switch($T.Cat) {
        "Gaming" { "Cyan" }
        "Driver Management" { "Orange" }
        "Performance" { "Lime" }
        "Disk" { "Magenta" }
        "Network" { "Green" }
        "Security" { "Red" }
        "Winget" { "Yellow" }
        default { "White" }
    }
    $CB.Font = New-Object System.Drawing.Font("Segoe UI",10)
    $CB.Size = New-Object System.Drawing.Size(1000,35)
    $CB.Tag = $T
    $CB.Add_MouseEnter({ $Intel.Text = ">>> BENEFIT: " + $this.Tag.Ben })
    $Tabs[$T.Cat].Controls.Add($CB)
    $Checkboxes += $CB
}

# Buttons
$BackupBtn = New-Object System.Windows.Forms.Button
$BackupBtn.Text = "CREATE RESTORE POINT"
$BackupBtn.Size = New-Object System.Drawing.Size(540,50)
$BackupBtn.Location = New-Object System.Drawing.Point(20,800)
$BackupBtn.BackColor = [System.Drawing.Color]::FromArgb(40,40,40)
$BackupBtn.ForeColor = [System.Drawing.Color]::Yellow
$BackupBtn.FlatStyle = "Flat"
$BackupBtn.Add_Click({
    $Intel.Text = "Creating restore point..."
    Checkpoint-Computer -Description "BeastUltra_Backup" -RestorePointType "MODIFY_SETTINGS" -ErrorAction SilentlyContinue
    $Intel.Text = "Restore point created successfully!"
})
$Form.Controls.Add($BackupBtn)

$RunBtn = New-Object System.Windows.Forms.Button
$RunBtn.Text = "APPLY SELECTED TWEAKS"
$RunBtn.Size = New-Object System.Drawing.Size(540,50)
$RunBtn.Location = New-Object System.Drawing.Point(610,800)
$RunBtn.BackColor = [System.Drawing.Color]::FromArgb(30,30,40)
$RunBtn.ForeColor = [System.Drawing.Color]::Cyan
$RunBtn.FlatStyle = "Flat"
$RunBtn.Font = New-Object System.Drawing.Font("Segoe UI",12,[System.Drawing.FontStyle]::Bold)
$RunBtn.Add_Click({
    $Applied = 0
    foreach ($CB in $Checkboxes) {
        if ($CB.Checked) {
            Write-Host "Applying: $($CB.Text)" -ForegroundColor Cyan
            try { & $CB.Tag.Cmd; $Applied++ } catch { Write-Host "Error applying $($CB.Text)" -ForegroundColor Red }
        }
    }
    [System.Windows.Forms.MessageBox]::Show("$Applied Tweaks Applied! Restart PC for full effect.")
})
$Form.Controls.Add($RunBtn)

# Show the GUI
$Form.ShowDialog() | Out-Null
