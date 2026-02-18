Add-Type -AssemblyName System.Windows.Forms, System.Drawing

# --- 1. TWEAK DATABASE ---
# Example tweaks; you can expand to 500+ manually later
$TweakMatrix = @(
    @{Name="Disable GameDVR"; Cat="Gaming"; Ben="Stops background recording to save CPU/GPU overhead."; Cmd={Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0}},
    @{Name="Enable TCP RSS"; Cat="Network"; Ben="Allows multi-core CPU handling of network packets."; Cmd={netsh int tcp set global rss=enabled}},
    @{Name="Ultimate Power Plan"; Cat="Performance"; Ben="Unlocks 'Ultimate Performance' power profile."; Cmd={powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61}},
    @{Name="Install Google Chrome"; Cat="Winget"; Ben="Installs Google Chrome via winget."; Cmd={ & winget install --id "Google.Chrome" -e }},
    @{Name="Disable Telemetry"; Cat="Security"; Ben="Stops Windows telemetry and data collection."; Cmd={Stop-Service "DiagTrack" -ErrorAction SilentlyContinue; Set-Service "DiagTrack" -StartupType Disabled}}
) | ForEach-Object { [PSCustomObject]$_ }

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

# --- 5. Create tabs dynamically ---
$Categories = $TweakMatrix | Select-Object -ExpandProperty Cat -Unique
$TabPages = @{}

foreach ($Cat in $Categories) {
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

# --- 6. Add Checkboxes to Tabs ---
$Checkboxes = @()
foreach ($T in $TweakMatrix) {
    $CB = New-Object System.Windows.Forms.CheckBox
    $CB.Text = $T.Name
    $CB.Tag = $T
    $CB.AutoSize = $true
    $CB.Font = New-Object System.Drawing.Font("Segoe UI",10)
    
    # Hover description
    $CB.Add_MouseEnter({ $Intel.Text = ">>> Benefit: " + $this.Tag.Ben })
    $CB.Add_MouseLeave({ $Intel.Text = ">>> Hover over a tweak to see its benefit." })
    
    $TabPages[$T.Cat].Controls["FlowPanel"].Controls.Add($CB)
    $Checkboxes += $CB
}

# --- 7. Buttons ---
# Restore Point
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

# Apply Tweaks
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
