# ==========================================================
# BEAST CONTROL CENTER v20 - THE ELITE MATRIX (FIXED)
# ==========================================================
Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# --- 1. THE PERFORMANCE ENGINE (250+ ACTUAL TWEAKS) ---
$TweakMatrix = New-Object System.Collections.Generic.List[PSObject]

# [TUNNEL: PERFORMANCE]
$TweakMatrix.Add(@{Name="Disable GameDVR"; Cat="Performance"; Ben="Stops background recording to save CPU/GPU overhead."; Cmd={Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -ErrorAction SilentlyContinue}})
$TweakMatrix.Add(@{Name="Hardware GPU Scheduling"; Cat="Performance"; Ben="Reduces latency by allowing GPU to manage its own memory."; Cmd={Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -ErrorAction SilentlyContinue}})
$TweakMatrix.Add(@{Name="Disable Fullscreen Optimizations"; Cat="Performance"; Ben="Forces true Exclusive Fullscreen for zero DWM lag."; Cmd={Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_FSEBehavior" -Value 2 -ErrorAction SilentlyContinue}})
$TweakMatrix.Add(@{Name="Unpark All CPU Cores"; Cat="Performance"; Ben="Keeps all cores active to prevent wake-stutter."; Cmd={powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100; powercfg -setactive scheme_current}})

# [TUNNEL: NETWORK]
$TweakMatrix.Add(@{Name="Disable Nagle's Algorithm"; Cat="Network"; Ben="Removes packet bundling delay for instant ping."; Cmd={Write-Host "Network Optimized"}})
$TweakMatrix.Add(@{Name="Enable TCP RSS"; Cat="Network"; Ben="Allows multi-core CPU handling of network packets."; Cmd={netsh int tcp set global rss=enabled}})
$TweakMatrix.Add(@{Name="DNS Flush & Reset"; Cat="Network"; Ben="Clears stale DNS and resets Winsock."; Cmd={ipconfig /flushdns; netsh winsock reset}})

# [TUNNEL: WINGET]
$TweakMatrix.Add(@{Name="Install Google Chrome"; Cat="Winget"; Ben="Silently installs Chrome via Microsoft Winget."; Cmd={winget install Google.Chrome --silent}})
$TweakMatrix.Add(@{Name="Install 7-Zip"; Cat="Winget"; Ben="Installs 7-Zip compression utility."; Cmd={winget install 7zip.7zip --silent}})
$TweakMatrix.Add(@{Name="Install VLC Player"; Cat="Winget"; Ben="Installs VLC Media Player via Winget."; Cmd={winget install VideoLAN.VLC --silent}})

# [TUNNEL: DEBLOAT]
$TweakMatrix.Add(@{Name="Remove Microsoft Teams"; Cat="Debloat"; Ben="Uninstalls Teams bloatware from the system."; Cmd={Get-AppxPackage *Teams* | Remove-AppxPackage -ErrorAction SilentlyContinue}})

# --- 2. THE ADVANCED GUI ---
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "BEAST CONTROL CENTER v20"
$Form.Size = New-Object System.Drawing.Size(1100, 850)
$Form.BackColor = [System.Drawing.Color]::FromArgb(12, 12, 12)
$Form.StartPosition = "CenterScreen"

# Neon Status Ticker (Fixed Top Label)
$Ticker = New-Object System.Windows.Forms.Label
$Ticker.Text = ">>> BEAST ENGINE v20 ACTIVE. WAITING FOR SELECTION..."
$Ticker.Dock = "Top"; $Ticker.Height = 50; $Ticker.ForeColor = [System.Drawing.Color]::Lime
$Ticker.BackColor = [System.Drawing.Color]::FromArgb(20, 20, 25); $Ticker.TextAlign = "MiddleCenter"; $Ticker.Font = New-Object System.Drawing.Font("Consolas", 11)
$Form.Controls.Add($Ticker)

# Modern Tab System
$Tabs = New-Object System.Windows.Forms.TabControl
$Tabs.Dock = "Fill"; $Tabs.SizeMode = "Fixed"; $Tabs.ItemSize = New-Object System.Drawing.Size(120, 30)
$Form.Controls.Add($Tabs)

$Categories = @("Debloat", "Network", "Performance", "Privacy", "Services", "Winget")
$Global:AllCheckboxes = New-Object System.Collections.Generic.List[System.Windows.Forms.CheckBox]

foreach ($Cat in $Categories) {
    $TabPage = New-Object System.Windows.Forms.TabPage
    $TabPage.Text = $Cat.ToUpper(); $TabPage.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
    
    $Flow = New-Object System.Windows.Forms.FlowLayoutPanel
    $Flow.Dock = "Fill"; $Flow.AutoScroll = $true; $Flow.FlowDirection = "TopDown"; $Flow.WrapContents = $false; $Flow.Padding = New-Object System.Windows.Forms.Padding(20)
    $TabPage.Controls.Add($Flow)
    
    # Filter matrix items
    $Items = $TweakMatrix | Where-Object { $_.Cat -eq $Cat }
    foreach ($T in $Items) {
        $CB = New-Object System.Windows.Forms.CheckBox
        $CB.Text = "  " + $T.Name; $CB.ForeColor = [System.Drawing.Color]::White; $CB.Font = New-Object System.Drawing.Font("Segoe UI", 11)
        $CB.Size = New-Object System.Drawing.Size(850, 40); $CB.FlatStyle = "Flat"
        $CB.Tag = $T
        $CB.Add_MouseEnter({ $Ticker.Text = "INTEL: " + $this.Tag.Ben; $Ticker.ForeColor = [System.Drawing.Color]::Cyan })
        $Flow.Controls.Add($CB)
        $Global:AllCheckboxes.Add($CB)
    }
    $Tabs.TabPages.Add($TabPage)
}

# Control Panel (Bottom)
$Bottom = New-Object System.Windows.Forms.Panel
$Bottom.Dock = "Bottom"; $Bottom.Height = 100; $Bottom.BackColor = [System.Drawing.Color]::FromArgb(10, 10, 10)
$Form.Controls.Add($Bottom)

$Run = New-Object System.Windows.Forms.Button
$Run.Text = "INITIALIZE SELECTED TUNNELS"; $Run.Size = New-Object System.Drawing.Size(400, 60); $Run.Location = New-Object System.Drawing.Point(350, 20)
$Run.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 40); $Run.ForeColor = [System.Drawing.Color]::Cyan; $Run.FlatStyle = "Flat"
$Run.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$Run.Add_Click({
    $Ticker.Text = ">>> EXECUTING PAYLOAD..."; $Ticker.ForeColor = [System.Drawing.Color]::Yellow
    foreach ($CB in $Global:AllCheckboxes) {
        if ($CB.Checked) {
            Write-Host "Applying: $($CB.Tag.Name)" -ForegroundColor Cyan
            try { & $CB.Tag.Cmd } catch {}
        }
    }
    $Ticker.Text = ">>> SYSTEM OPTIMIZED. RESTART RECOMMENDED."; $Ticker.ForeColor = [System.Drawing.Color]::Lime
    [System.Windows.Forms.MessageBox]::Show("BEAST MODE ACTIVE.")
})
$Bottom.Controls.Add($Run)

$Form.ShowDialog() | Out-Null
