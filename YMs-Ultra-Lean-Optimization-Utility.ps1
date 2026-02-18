# ================================
# BEAST CONTROL CENTER v18
# FULL CONTROL CENTER EDITION
# ================================

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# ================================
# SAFE WRAPPER FUNCTIONS
# ================================

function Install-App {
    param($Id)
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install --id $Id -e --silent
    }
}

function Remove-App {
    param($Package)
    Get-AppxPackage $Package -AllUsers | Remove-AppxPackage -ErrorAction SilentlyContinue
}

function Log-Message {
    param($Message)
    $LogBox.AppendText("`r`n$Message")
}

# ================================
# TWEAK DATABASE
# ================================

$TweakMatrix = @(

# ================= PERFORMANCE =================
@{Name="Ultimate Power Plan"; Cat="Performance"; Desc="Enables hidden Ultimate Performance power plan."; Cmd={powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61}},
@{Name="Disable Power Throttling"; Cat="Performance"; Desc="Prevents CPU downclocking under load."; Cmd={Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1}},
@{Name="Unpark CPU Cores"; Cat="Performance"; Desc="Forces all CPU cores active at full availability."; Cmd={powercfg -setacvalueindex scheme_current sub_processor CPMAXCORES 100}},

# ================= NETWORK =================
@{Name="Enable TCP RSS"; Cat="Network"; Desc="Allows multi-core packet processing."; Cmd={netsh int tcp set global rss=enabled}},
@{Name="Disable TCP Timestamps"; Cat="Network"; Desc="Reduces packet header size."; Cmd={netsh int tcp set global timestamps=disabled}},
@{Name="Flush DNS"; Cat="Network"; Desc="Clears DNS resolver cache."; Cmd={ipconfig /flushdns}},

# ================= PRIVACY =================
@{Name="Disable Telemetry Service"; Cat="Privacy"; Desc="Stops Windows telemetry tracking service."; Cmd={Stop-Service DiagTrack -ErrorAction SilentlyContinue; Set-Service DiagTrack -StartupType Disabled}},
@{Name="Disable Advertising ID"; Cat="Privacy"; Desc="Turns off Windows advertising identifier."; Cmd={Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name Enabled -Value 0}},

# ================= DEBLOAT =================
@{Name="Remove Xbox App"; Cat="Debloat"; Desc="Removes Xbox app package."; Cmd={Remove-App "Microsoft.XboxApp"}},
@{Name="Remove Cortana"; Cat="Debloat"; Desc="Removes Cortana package."; Cmd={Remove-App "Microsoft.549981C3F5F10"}},

# ================= SERVICES =================
@{Name="Disable SysMain"; Cat="Services"; Desc="Disables Superfetch service."; Cmd={Stop-Service SysMain -ErrorAction SilentlyContinue; Set-Service SysMain -StartupType Disabled}},
@{Name="Disable Windows Search"; Cat="Services"; Desc="Disables indexing service."; Cmd={Stop-Service WSearch -ErrorAction SilentlyContinue; Set-Service WSearch -StartupType Disabled}},

# ================= WINGET APPS =================
@{Name="Install Google Chrome"; Cat="Winget"; Desc="Installs Google Chrome browser."; Cmd={Install-App "Google.Chrome"}},
@{Name="Install 7-Zip"; Cat="Winget"; Desc="Installs 7-Zip archive tool."; Cmd={Install-App "7zip.7zip"}},
@{Name="Install VLC"; Cat="Winget"; Desc="Installs VLC media player."; Cmd={Install-App "VideoLAN.VLC"}}

)

# ================================
# UI BUILD
# ================================

$Form = New-Object System.Windows.Forms.Form
$Form.Text = "BEAST CONTROL CENTER v18"
$Form.Size = New-Object System.Drawing.Size(1300,900)
$Form.StartPosition = "CenterScreen"
$Form.BackColor = [System.Drawing.Color]::FromArgb(20,20,25)

# Info Panel
$InfoLabel = New-Object System.Windows.Forms.Label
$InfoLabel.Text = "Hover over a tweak to see description."
$InfoLabel.ForeColor = "Lime"
$InfoLabel.BackColor = [System.Drawing.Color]::FromArgb(30,30,35)
$InfoLabel.Size = New-Object System.Drawing.Size(1200,50)
$InfoLabel.Location = New-Object System.Drawing.Point(40,10)
$InfoLabel.TextAlign = "MiddleCenter"
$Form.Controls.Add($InfoLabel)

# TabControl
$Tabs = New-Object System.Windows.Forms.TabControl
$Tabs.Size = New-Object System.Drawing.Size(1200,650)
$Tabs.Location = New-Object System.Drawing.Point(40,70)
$Form.Controls.Add($Tabs)

$Categories = $TweakMatrix.Cat | Sort-Object -Unique
$Checkboxes = @{}

foreach ($Cat in $Categories) {

    $TabPage = New-Object System.Windows.Forms.TabPage
    $TabPage.Text = $Cat
    $TabPage.BackColor = [System.Drawing.Color]::FromArgb(25,25,30)

    $Flow = New-Object System.Windows.Forms.FlowLayoutPanel
    $Flow.Dock = "Fill"
    $Flow.AutoScroll = $true

    $Tweaks = $TweakMatrix | Where-Object {$_.Cat -eq $Cat}

    foreach ($Tweak in $Tweaks) {

        $CB = New-Object System.Windows.Forms.CheckBox
        $CB.Text = $Tweak.Name
        $CB.Width = 1100
        $CB.ForeColor = "White"
        $CB.Tag = $Tweak
        $CB.Add_MouseEnter({
            $InfoLabel.Text = $this.Tag.Desc
        })

        $Flow.Controls.Add($CB)
        $Checkboxes += $CB
    }

    $TabPage.Controls.Add($Flow)
    $Tabs.TabPages.Add($TabPage)
}

# ================================
# LOG WINDOW
# ================================

$LogBox = New-Object System.Windows.Forms.TextBox
$LogBox.Multiline = $true
$LogBox.ScrollBars = "Vertical"
$LogBox.Size = New-Object System.Drawing.Size(1200,80)
$LogBox.Location = New-Object System.Drawing.Point(40,730)
$Form.Controls.Add($LogBox)

# ================================
# BUTTONS
# ================================

$RestoreBtn = New-Object System.Windows.Forms.Button
$RestoreBtn.Text = "Create Restore Point"
$RestoreBtn.Size = New-Object System.Drawing.Size(250,40)
$RestoreBtn.Location = New-Object System.Drawing.Point(40,820)
$RestoreBtn.Add_Click({
    Log-Message "Creating restore point..."
    Checkpoint-Computer -Description "BeastBackup" -RestorePointType MODIFY_SETTINGS -ErrorAction SilentlyContinue
    Log-Message "Restore point created."
})
$Form.Controls.Add($RestoreBtn)

$ApplyBtn = New-Object System.Windows.Forms.Button
$ApplyBtn.Text = "Apply Selected Tweaks"
$ApplyBtn.Size = New-Object System.Drawing.Size(250,40)
$ApplyBtn.Location = New-Object System.Drawing.Point(330,820)
$ApplyBtn.Add_Click({

    $Count = 0

    foreach ($Tab in $Tabs.TabPages) {
        foreach ($Control in $Tab.Controls[0].Controls) {
            if ($Control.Checked) {
                try {
                    & $Control.Tag.Cmd
                    Log-Message "Applied: $($Control.Tag.Name)"
                    $Count++
                } catch {
                    Log-Message "Failed: $($Control.Tag.Name)"
                }
            }
        }
    }

    [System.Windows.Forms.MessageBox]::Show("$Count tweaks applied. Restart recommended.")
})
$Form.Controls.Add($ApplyBtn)

# ================================
# SHOW UI
# ================================

$Form.ShowDialog()
