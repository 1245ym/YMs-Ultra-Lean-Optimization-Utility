# ===============================
# YM INSANE GAMING CONTROL CENTER
# ===============================

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

# -------------------------------
# GLOBAL STATE
# -------------------------------
$Global:DryRun = $false
$Global:DangerMode = $false
$Global:Actions = @()

function Add-Action {
    param($Name,$Type,$Details)
    $Global:Actions += [pscustomobject]@{
        Name=$Name; Type=$Type; Details=$Details
    }
}

function Run-Actions {
    foreach ($a in $Global:Actions) {
        if ($Global:DryRun) {
            Write-Host "[DRY-RUN] $($a.Name)" -ForegroundColor Cyan
            continue
        }
        try {
            switch ($a.Type) {
                "Registry" {
                    $p = $a.Details
                    Set-ItemProperty @p -Force
                }
                "Service" {
                    Set-Service -Name $a.Details.Name -StartupType $a.Details.Startup
                    if ($a.Details.State -eq "Stop") { Stop-Service $a.Details.Name -Force }
                }
                "Command" {
                    Invoke-Expression $a.Details.Command
                }
            }
            Write-Host "[OK] $($a.Name)" -ForegroundColor Green
        } catch {
            Write-Warning "[FAIL] $($a.Name)"
        }
    }
    $Global:Actions = @()
}

# -------------------------------
# APP CATALOG (CURATED)
# -------------------------------
$AppCatalog = @(
    @{Name="Xbox Game Bar"; Package="Microsoft.XboxGamingOverlay"; Category="Gaming"; Desc="Xbox overlay, DVR, background capture."; Risk="Safe"},
    @{Name="Xbox Identity Provider"; Package="Microsoft.XboxIdentityProvider"; Category="Gaming"; Desc="Xbox sign-in component."; Risk="Safe"},
    @{Name="OneDrive"; Package="Microsoft.OneDrive"; Category="Essentials"; Desc="Cloud file sync client."; Risk="Advanced"},
    @{Name="Microsoft Teams"; Package="MSTeams"; Category="Bloat"; Desc="Chat and collaboration app."; Risk="Safe"},
    @{Name="Microsoft Edge"; Package="Microsoft.MicrosoftEdge"; Category="System"; Desc="Core Windows browser. Removal NOT recommended."; Risk="System"}
)

# -------------------------------
# XAML (DARK MODE – CARD UI)
# -------------------------------
$XAML = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="YM Insane Gaming Control Center"
        Height="780"
        Width="1200"
        Background="#0F0F0F"
        Foreground="White"
        WindowStartupLocation="CenterScreen">

<Grid Margin="20">
<Grid.RowDefinitions>
<RowDefinition Height="Auto"/>
<RowDefinition Height="*"/>
<RowDefinition Height="Auto"/>
</Grid.RowDefinitions>

<TextBlock Text="🎮 YM Insane Gaming Windows Control Center"
           FontSize="26"
           FontWeight="Bold"
           Margin="0,0,0,15"/>

<Grid Grid.Row="1">
<Grid.ColumnDefinitions>
<ColumnDefinition Width="220"/>
<ColumnDefinition Width="*"/>
</Grid.ColumnDefinitions>

<!-- LEFT PANEL -->
<StackPanel Grid.Column="0">
<TextBlock Text="Gaming Tweaks" FontSize="18" Margin="0,0,0,10"/>

<CheckBox Name="chkGameMode" Content="Enable Game Mode"/>
<TextBlock Text="Prioritize CPU/GPU for games" Foreground="Gray" Margin="20,0,0,8"/>

<CheckBox Name="chkHAGS" Content="Enable HAGS"/>
<TextBlock Text="Hardware Accelerated GPU Scheduling" Foreground="Gray" Margin="20,0,0,8"/>

<CheckBox Name="chkSysMain" Content="Disable SysMain"/>
<TextBlock Text="Reduces stutter on SSD systems" Foreground="Gray" Margin="20,0,0,8"/>

<CheckBox Name="chkTelemetry" Content="Disable Telemetry"/>
<TextBlock Text="Stops diagnostic tracking services" Foreground="Gray" Margin="20,0,0,8"/>

<TextBlock Text="Power Profile" FontSize="16" Margin="0,15,0,5"/>
<ComboBox Name="cmbPower">
<ComboBoxItem Content="Balanced"/>
<ComboBoxItem Content="High Performance"/>
<ComboBoxItem Content="Ultimate Performance"/>
</ComboBox>
</StackPanel>

<!-- APP GRID -->
<ScrollViewer Grid.Column="1">
<ItemsControl Name="AppGrid">
<ItemsControl.ItemsPanel>
<ItemsPanelTemplate>
<WrapPanel/>
</ItemsPanelTemplate>
</ItemsControl.ItemsPanel>

<ItemsControl.ItemTemplate>
<DataTemplate>
<Border Width="320"
        Margin="10"
        Padding="12"
        Background="#1B1B1B"
        BorderBrush="#333"
        BorderThickness="1"
        CornerRadius="10">

<StackPanel>
<CheckBox Content="{Binding Name}" FontSize="14" FontWeight="Bold"/>
<TextBlock Text="{Binding Desc}" Foreground="Gray" TextWrapping="Wrap" Margin="0,6,0,6"/>
<TextBlock Text="{Binding Risk}" FontSize="11" HorizontalAlignment="Right"/>
</StackPanel>

</Border>
</DataTemplate>
</ItemsControl.ItemTemplate>
</ItemsControl>
</ScrollViewer>

</Grid>

<!-- FOOTER -->
<StackPanel Grid.Row="2" Orientation="Horizontal" HorizontalAlignment="Right">
<CheckBox Name="chkDryRun" Content="Dry Run" Margin="0,0,15,0"/>
<CheckBox Name="chkDanger" Content="Danger Mode" Margin="0,0,15,0"/>
<Button Name="btnApply" Content="🔥 APPLY ALL" Width="160" Height="40" Background="#E53935"/>
</StackPanel>

</Grid>
</Window>
"@

# -------------------------------
# LOAD XAML (CORRECT METHOD)
# -------------------------------
$reader = New-Object System.IO.StringReader $XAML
$xmlReader = [System.Xml.XmlReader]::Create($reader)
$Window = [Windows.Markup.XamlReader]::Load($xmlReader)
if (-not $Window) { throw "XAML failed" }

# -------------------------------
# FIND CONTROLS
# -------------------------------
$chkGameMode = $Window.FindName("chkGameMode")
$chkHAGS = $Window.FindName("chkHAGS")
$chkSysMain = $Window.FindName("chkSysMain")
$chkTelemetry = $Window.FindName("chkTelemetry")
$cmbPower = $Window.FindName("cmbPower")
$chkDryRun = $Window.FindName("chkDryRun")
$chkDanger = $Window.FindName("chkDanger")
$btnApply = $Window.FindName("btnApply")
$AppGrid = $Window.FindName("AppGrid")

# -------------------------------
# LOAD APP CARDS
# -------------------------------
$AppObjects = foreach ($a in $AppCatalog) {
    [pscustomobject]@{
        Name=$a.Name; Package=$a.Package
        Category=$a.Category; Desc=$a.Desc; Risk=$a.Risk
    }
}
$AppGrid.ItemsSource = $AppObjects

# -------------------------------
# APPLY BUTTON
# -------------------------------
$btnApply.Add_Click({
    $Global:DryRun = $chkDryRun.IsChecked
    $Global:DangerMode = $chkDanger.IsChecked

    if ($chkGameMode.IsChecked) {
        Add-Action "Enable Game Mode" "Registry" @{
            Path="HKCU:\Software\Microsoft\GameBar"
            Name="AllowAutoGameMode"; Value=1
        }
    }

    if ($chkHAGS.IsChecked) {
        Add-Action "Enable HAGS" "Registry" @{
            Path="HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
            Name="HwSchMode"; Value=2
        }
    }

    if ($chkSysMain.IsChecked) {
        Add-Action "Disable SysMain" "Service" @{
            Name="SysMain"; Startup="Disabled"; State="Stop"
        }
    }

    if ($chkTelemetry.IsChecked) {
        Add-Action "Disable DiagTrack" "Service" @{
            Name="DiagTrack"; Startup="Disabled"; State="Stop"
        }
    }

    switch ($cmbPower.Text) {
        "High Performance" {
            Add-Action "High Performance Power" "Command" @{
                Command="powercfg /setactive SCHEME_MIN"
            }
        }
        "Ultimate Performance" {
            Add-Action "Ultimate Performance Power" "Command" @{
                Command="powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61"
            }
        }
    }

    foreach ($app in $AppGrid.Items) {
        if ($app.Risk -eq "System" -and -not $Global:DangerMode) { continue }
        Add-Action "Remove $($app.Name)" "Command" @{
            Command="Get-AppxPackage -Name $($app.Package) | Remove-AppxPackage"
        }
    }

    Run-Actions
    [System.Windows.MessageBox]::Show("Completed. Reboot recommended.","YM Gaming Utility")
})

# -------------------------------
# SHOW
# -------------------------------
$Window.ShowDialog() | Out-Null

