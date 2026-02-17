Modern GUI with Advanced Features
#Requires -RunAsAdministrator #Requires -Version 5.1

#region GLOBAL INITIALIZATION #===============================================

CORE GLOBAL VARIABLES AND CONFIGURATION
#===============================================

$Global:ScriptVersion = "5.0.0-MASSIVE" $Global:BuildDate = "2026-02-17" $Global:TotalOptimizations = 0 $Global:AppliedOptimizations = 0 $Global:FailedOptimizations = 0 $Global:IsDryRun = $false $Global:VerboseLogging = $true $Global:CreateSystemRestorePoint = $true $Global:BackupRegistry = $true $Global:LogLevel = "INFO" $Global:ProgressInterval = 100 $Global:MaxRetries = 3 $Global:RetryDelay = 1000

Paths and Directories
$Global:ScriptPath = $PSScriptRoot $Global:LogPath = "$env:USERPROFILE\YMsInsaneWinUtil.log" $Global:BackupPath = "$env:USERPROFILE\YMsWinUtil_Backup" $Global:ConfigPath = "$env:USERPROFILE\YMsWinUtil_Config" $Global:TempPath = "$env:TEMP\YMsWinUtil" $Global:ReportsPath = "$env:USERPROFILE\YMsWinUtil_Reports" $Global:ProfilesPath = "$env:USERPROFILE\YMsWinUtil_Profiles"

GUI Variables
$Global:MainWindow = $null $Global:CurrentCategory = $null $Global:SelectedOptimizations = @() $Global:SearchResults = @() $Global:CurrentProfile = "Default" $Global:Theme = "Dark" $Global:FontSize = 12 $Global:WindowWidth = 1400 $Global:WindowHeight = 900

Performance Monitoring
$Global:PerformanceCounters = @{} $Global:BaselineMetrics = @{} $Global:OptimizationMetrics = @{}

Optimization Categories
$Global:Categories = @( "Latency & Response", "Network & Internet", "Power Management", "Gaming Performance", "System Maintenance", "Privacy & Security", "Visual & UI", "Audio & Multimedia", "Advanced System", "Storage & Disk", "CPU & Memory", "Startup & Boot" )

Registry Paths for Backup
$Global:RegistryPaths = @( "HKLM\SOFTWARE", "HKLM\SYSTEM\CurrentControlSet", "HKCU\SOFTWARE", "HKCU\Control Panel", "HKCU\Microsoft\Windows", "HKLM\SOFTWARE\Policies", "HKCU\SOFTWARE\Policies" )

Initialize Directories
foreach ($Dir in @($Global:BackupPath, $Global:ConfigPath, $Global:TempPath, $Global:ReportsPath, $Global:ProfilesPath)) { if (!(Test-Path $Dir)) { New-Item -ItemType Directory -Path $Dir -Force | Out-Null } }

#endregion

#region LOGGING SYSTEM #===============================================

COMPREHENSIVE LOGGING FUNCTIONALITY
#===============================================

function Write-Log { [CmdletBinding()] param( [Parameter(Mandatory=$true)][string]$Message, [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "SUCCESS", "CRITICAL")][string]$Level = "INFO", [string]$Category = "General", [string]$SubCategory = "", [int]$OptimizationID = 0, [string]$Details = "", [switch]$NoConsole )

$Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss.fff" $ProcessID = $PID $ThreadID = [System.Threading.Thread]::CurrentThread.ManagedThreadId

$LogEntry = "[$Timestamp] [$Level] [PID:$ProcessID] [TID:$ThreadID] [$Category"
if ($SubCategory) { $LogEntry += ">$SubCategory" }
if ($OptimizationID -gt 0) { $LogEntry += "][ID:$OptimizationID" }
$LogEntry += "] $Message"
 
if ($Details) {
    $LogEntry += "`nDETAILS: $Details"
}
 
# Console Output
if (!$NoConsole) {
    $Color = switch ($Level) {
        "DEBUG" { "Gray" }
        "INFO" { "White" }
        "WARN" { "Yellow" }
        "ERROR" { "Red" }
        "SUCCESS" { "Green" }
        "CRITICAL" { "Magenta" }
        default { "White" }
    }
    Write-Host $LogEntry -ForegroundColor $Color
}
 
# File Output
try {
    Add-Content -Path $Global:LogPath -Value $LogEntry -ErrorAction Stop
} catch {
    Write-Host "FAILED TO WRITE LOG: $($_.Exception.Message)" -ForegroundColor Red
}
 
# Event Log (for critical errors)
if ($Level -eq "CRITICAL") {
    try {
        Write-EventLog -LogName Application -Source "YMsWinUtil" -EventId 1001 -EntryType Error -Message $Message -ErrorAction SilentlyContinue
    } catch {
        Write-Log "Failed to write to Event Log: $($_.Exception.Message)" "WARN"
    }
}
}

function Initialize-Logging { Write-Log "=== YMs INSANE Ultimate Windows Control Center v$Global:ScriptVersion ===" "INFO" Write-Log "Build Date: $Global:BuildDate" "INFO" Write-Log "PowerShell Version: $($PSVersionTable.PSVersion)" "INFO" Write-Log "System: $((Get-CimInstance Win32_OperatingSystem).Caption)" "INFO" Write-Log "Architecture: $((Get-CimInstance Win32_OperatingSystem).OSArchitecture)" "INFO" Write-Log "Log Path: $Global:LogPath" "INFO" Write-Log "Backup Path: $Global:BackupPath" "INFO" Write-Log "Initializing comprehensive logging system..." "INFO" }

function Rotate-Logs { try { $MaxLogSize = 50MB $MaxLogFiles = 10

if ((Get-Item $Global:LogPath -ErrorAction SilentlyContinue).Length -gt $MaxLogSize) { for ($i = $MaxLogFiles - 1; $i -ge 1; $i--) { $OldLog = "$Global:LogPath.$i" $NewLog = "$Global:LogPath.$($i + 1)" if (Test-Path $OldLog) { Move-Item $OldLog $NewLog -Force } } Move-Item $Global:LogPath "$Global:LogPath.1" -Force Write-Log "Log rotated successfully" "INFO" } } catch { Write-Log "Log rotation failed: $($_.Exception.Message)" "WARN" }

}

#endregion

#region BACKUP AND RESTORE SYSTEM #===============================================

COMPREHENSIVE BACKUP AND RESTORE FUNCTIONALITY
#===============================================

function Create-SystemRestorePoint { param([string]$Description = "YMsWinUtil Optimization")

if (!$Global:CreateSystemRestorePoint) { Write-Log "System restore point creation disabled" "INFO" return }

try {
    Check-AdminPrivileges
    Enable-ComputerRestore -Drive "$env:SystemDrive"
    $RestorePoint = Checkpoint-Computer -Description $Description -RestorePointType "MODIFY_SETTINGS"
    Write-Log "System restore point created: $Description" "SUCCESS"
    return $true
} catch {
    Write-Log "Failed to create system restore point: $($_.Exception.Message)" "ERROR"
    return $false
}
}

function Backup-RegistryKey { param( [Parameter(Mandatory=$true)][string]$KeyPath, [string]$BackupName = "", [switch]$Recursive )

try { if (!$BackupName) { $BackupName = "Registry_$(Get-Date -Format 'yyyyMMdd_HHmmss')_$(Split-Path $KeyPath -Leaf)" }

    $BackupFile = "$Global:BackupPath\$BackupName.reg"
    
    if (!(Test-Path $Global:BackupPath)) {
        New-Item -ItemType Directory -Path $Global:BackupPath -Force | Out-Null
    }
    
    $Arguments = @('export', $KeyPath, $BackupFile, '/y')
    if ($Recursive) {
        $Arguments += '/f'
    }
    
    $Process = Start-Process -FilePath "reg.exe" -ArgumentList $Arguments -Wait -PassThru -WindowStyle Hidden
    
    if ($Process.ExitCode -eq 0) {
        Write-Log "Registry backup created: $BackupFile" "SUCCESS"
        
        # Create metadata file
        $Metadata = @{
            OriginalPath = $KeyPath
            BackupDate = Get-Date
            BackupFile = $BackupFile
            Recursive = $Recursive
            ScriptVersion = $Global:ScriptVersion
        }
        $Metadata | ConvertTo-Json | Out-File "$BackupFile.meta.json"
        
        return $BackupFile
    } else {
        Write-Log "Registry backup failed with exit code: $($Process.ExitCode)" "ERROR"
        return $null
    }
} catch {
    Write-Log "Registry backup exception: $($_.Exception.Message)" "ERROR"
    return $null
}
}

function Backup-SystemConfiguration { Write-Log "Starting comprehensive system configuration backup..." "INFO"

$BackupDate = Get-Date -Format "yyyyMMdd_HHmmss" $BackupDir = "$Global:BackupPath\FullBackup_$BackupDate" New-Item -ItemType Directory -Path $BackupDir -Force | Out-Null

$BackupItems = @()
 
# Backup Registry Keys
foreach ($RegPath in $Global:RegistryPaths) {
    Write-Log "Backing up registry: $RegPath" "INFO"
    $BackupFile = Backup-RegistryKey -KeyPath $RegPath -BackupName "Backup_$($RegPath.Replace('\', '_'))_$BackupDate"
    if ($BackupFile) {
        $BackupItems += @{
            Type = "Registry"
            Path = $RegPath
            BackupFile = $BackupFile
        }
    }
}
 
# Backup Group Policy
try {
    $GPOBackup = "$BackupDir\GroupPolicy"
    Copy-Item "$env:windir\System32\GroupPolicy" $GPOBackup -Recurse -Force -ErrorAction SilentlyContinue
    Copy-Item "$env:windir\System32\GroupPolicyUsers" $GPOBackup -Recurse -Force -ErrorAction SilentlyContinue
    $BackupItems += @{ Type = "GroupPolicy"; Path = $GPOBackup }
    Write-Log "Group Policy backed up" "SUCCESS"
} catch {
    Write-Log "Group Policy backup failed: $($_.Exception.Message)" "WARN"
}
 
# Backup System Settings
try {
    $SettingsBackup = "$BackupDir\SystemSettings"
    New-Item -ItemType Directory -Path $SettingsBackup -Force | Out-Null
    
    # Power settings
    powercfg /export "$SettingsBackup\PowerSettings.pow" scheme_current
    
    # Network settings
    netsh interface export persistent "$SettingsBackup\NetworkSettings.txt"
    
    # Services list
    Get-Service | Select-Object Name, Status, StartType | Export-Csv "$SettingsBackup\Services.csv" -NoTypeInformation
    
    # Installed programs
    Get-WmiObject Win32_Product | Select-Object Name, Version, Vendor | Export-Csv "$SettingsBackup\Programs.csv" -NoTypeInformation
    
    $BackupItems += @{ Type = "SystemSettings"; Path = $SettingsBackup }
    Write-Log "System settings backed up" "SUCCESS"
} catch {
    Write-Log "System settings backup failed: $($_.Exception.Message)" "WARN"
}
 
# Create backup manifest
$Manifest = @{
    BackupDate = Get-Date
    ScriptVersion = $Global:ScriptVersion
    BackupItems = $BackupItems
    SystemInfo = Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, SystemDirectory
}
$Manifest | ConvertTo-Json -Depth 10 | Out-File "$BackupDir\BackupManifest.json"
 
Write-Log "Comprehensive backup completed: $BackupDir" "SUCCESS"
return $BackupDir
}

function Restore-FromBackup { param([string]$BackupPath)

if (!(Test-Path $BackupPath)) { Write-Log "Backup path not found: $BackupPath" "ERROR" return $false }

try {
    Write-Log "Starting restore from backup: $BackupPath" "INFO"
    
    # Load manifest
    $ManifestPath = "$BackupPath\BackupManifest.json"
    if (Test-Path $ManifestPath) {
        $Manifest = Get-Content $ManifestPath | ConvertFrom-Json
        Write-Log "Backup created on: $($Manifest.BackupDate)" "INFO"
        Write-Log "Script version: $($Manifest.ScriptVersion)" "INFO"
    }
    
    # Restore Registry backups
    $RegFiles = Get-ChildItem $BackupPath -Filter "*.reg"
    foreach ($RegFile in $RegFiles) {
        Write-Log "Restoring registry from: $($RegFile.Name)" "INFO"
        $Process = Start-Process -FilePath "reg.exe" -ArgumentList @('import', $RegFile.FullName) -Wait -PassThru -WindowStyle Hidden
        if ($Process.ExitCode -eq 0) {
            Write-Log "Registry restored: $($RegFile.Name)" "SUCCESS"
        } else {
            Write-Log "Registry restore failed: $($RegFile.Name)" "ERROR"
        }
    }
    
    Write-Log "Restore completed. System restart may be required." "SUCCESS"
    return $true
} catch {
    Write-Log "Restore failed: $($_.Exception.Message)" "ERROR"
    return $false
}
}

#endregion

#region SYSTEM VALIDATION #===============================================

SYSTEM REQUIREMENTS AND PRIVILEGE CHECKS
#===============================================

function Check-AdminPrivileges { $CurrentUser = [Security.Principal.WindowsIdentity]::GetCurrent() $Principal = New-Object Security.Principal.WindowsPrincipal($CurrentUser)

if (!$Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { Write-Log "Administrator privileges required. Restarting with elevated privileges..." "WARN"

    $StartInfo = New-Object System.Diagnostics.ProcessStartInfo
    $StartInfo.FileName = "powershell.exe"
    $StartInfo.Arguments = "-NoProfile -ExecutionPolicy Bypass -File "$PSCommandPath""
    $StartInfo.Verb = "runas"
    $StartInfo.WindowStyle = "Normal"
    
    try {
        [System.Diagnostics.Process]::Start($StartInfo) | Out-Null
        exit
    } catch {
        Write-Log "Failed to elevate privileges: $($_.Exception.Message)" "CRITICAL"
        exit 1
    }
}
 
Write-Log "Administrator privileges confirmed" "SUCCESS"
return $true
}

function Test-SystemCompatibility { Write-Log "Testing system compatibility..." "INFO"

$OS = Get-CimInstance Win32_OperatingSystem $PSVersion = $PSVersionTable.PSVersion

# Check Windows Version
if ([version]$OS.Version -lt [version]"10.0") {
    Write-Log "Windows 10 or later required. Current: $($OS.Caption)" "ERROR"
    return $false
}
 
# Check PowerShell Version
if ($PSVersion.Major -lt 5) {
    Write-Log "PowerShell 5.1 or later required. Current: $PSVersion" "ERROR"
    return $false
}
 
# Check .NET Framework
$DotNetVersion = Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse |
    Get-ItemProperty -Name Version -EA 0 |
    Where-Object { $_.PSChildName -match '^(?!S)\p{L}'} |
    Sort-Object Version -Descending | Select-Object -First 1
 
if (!$DotNetVersion -or [version]$DotNetVersion.Version -lt [version]"4.7") {
    Write-Log ".NET Framework 4.7 or later recommended" "WARN"
}
 
# Check Available Memory
$Memory = Get-CimInstance Win32_ComputerSystem
$MemoryGB = [math]::Round($Memory.TotalPhysicalMemory / 1GB, 2)
if ($MemoryGB -lt 4) {
    Write-Log "Low memory detected: ${MemoryGB}GB. 8GB+ recommended" "WARN"
}
 
# Check Disk Space
$SystemDrive = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'"
$FreeSpaceGB = [math]::Round($SystemDrive.FreeSpace / 1GB, 2)
if ($FreeSpaceGB -lt 10) {
    Write-Log "Low disk space: ${FreeSpaceGB}GB free. 20GB+ recommended" "WARN"
}
 
Write-Log "System compatibility check completed" "SUCCESS"
return $true
}

#endregion

#region PERFORMANCE MONITORING #===============================================

REAL-TIME PERFORMANCE METRICS AND MONITORING
#===============================================

function Initialize-PerformanceMonitoring { Write-Log "Initializing performance monitoring..." "INFO"

try { # CPU Counters $Global:PerformanceCounters.CPU = @{ Usage = (Get-Counter "\Processor(_Total)% Processor Time" -ErrorAction SilentlyContinue) Frequency = (Get-Counter "\Processor(_Total)% Processor Frequency" -ErrorAction SilentlyContinue) Interrupts = (Get-Counter "\Processor(_Total)\Interrupts/sec" -ErrorAction SilentlyContinue) }

    # Memory Counters
    $Global:PerformanceCounters.Memory = @{
        Available = (Get-Counter "\Memory\Available MBytes" -ErrorAction SilentlyContinue)
        Committed = (Get-Counter "\Memory\Committed Bytes" -ErrorAction SilentlyContinue)
        Cache = (Get-Counter "\Memory\Cache Bytes" -ErrorAction SilentlyContinue)
    }
    
    # Disk Counters
    $Global:PerformanceCounters.Disk = @{
        ReadTime = (Get-Counter "\PhysicalDisk(_Total)\% Disk Read Time" -ErrorAction SilentlyContinue)
        WriteTime = (Get-Counter "\PhysicalDisk(_Total)\% Disk Write Time" -ErrorAction SilentlyContinue)
        QueueLength = (Get-Counter "\PhysicalDisk(_Total)\Current Disk Queue Length" -ErrorAction SilentlyContinue)
    }
    
    # Network Counters
    $Global:PerformanceCounters.Network = @{
        BytesReceived = (Get-Counter "\Network Interface(*)\Bytes Received/sec" -ErrorAction SilentlyContinue)
        BytesSent = (Get-Counter "\Network Interface(*)\Bytes Sent/sec" -ErrorAction SilentlyContinue)
        PacketsReceived = (Get-Counter "\Network Interface(*)\Packets Received/sec" -ErrorAction SilentlyContinue)
        PacketsSent = (Get-Counter "\Network Interface(*)\Packets Sent/sec" -ErrorAction SilentlyContinue)
    }
    
    # Capture baseline metrics
    $Global:BaselineMetrics = Get-CurrentMetrics
    
    Write-Log "Performance monitoring initialized" "SUCCESS"
} catch {
    Write-Log "Performance monitoring initialization failed: $($_.Exception.Message)" "WARN"
}
}

function Get-CurrentMetrics { $Metrics = @{}

try { # CPU Metrics $CPUUsage = (Get-Counter "\Processor(_Total)% Processor Time" -ErrorAction SilentlyContinue).CounterSamples.CookedValue $Metrics.CPUUsage = [math]::Round($CPUUsage, 2)

    # Memory Metrics
    $Memory = Get-CimInstance Win32_OperatingSystem
    $Metrics.TotalMemoryGB = [math]::Round($Memory.TotalVisibleMemorySize / 1MB, 2)
    $Metrics.FreeMemoryGB = [math]::Round($Memory.FreePhysicalMemory / 1MB, 2)
    $Metrics.MemoryUsagePercent = [math]::Round((($Memory.TotalVisibleMemorySize - $Memory.FreePhysicalMemory) / $Memory.TotalVisibleMemorySize) * 100, 2)
    
    # Disk Metrics
    $Disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='$env:SystemDrive'"
    $Metrics.DiskUsagePercent = [math]::Round((($Disk.Size - $Disk.FreeSpace) / $Disk.Size) * 100, 2)
    $Metrics.FreeDiskSpaceGB = [math]::Round($Disk.FreeSpace / 1GB, 2)
    
    # Network Metrics
    $NetworkAdapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled -eq $true }
    $Metrics.ActiveNetworkAdapters = $NetworkAdapters.Count
    
    # System Metrics
    $Processes = Get-CimInstance Win32_Process
    $Metrics.RunningProcesses = $Processes.Count
    $Metrics.SystemUptime = (Get-Date) - $Convert.ToDateTime($Convert.ToDateTime($ManagementObjectSearcher.Get().Properties["LastBootUpTime"].Value))
    
} catch {
    Write-Log "Failed to collect metrics: $($_.Exception.Message)" "WARN"
}
 
return $Metrics
}

function Compare-PerformanceMetrics { param([hashtable]$Before, [hashtable]$After)

$Comparison = @{}

foreach ($Key in $Before.Keys) {
    if ($After.ContainsKey($Key)) {
        $BeforeValue = $Before[$Key]
        $AfterValue = $After[$Key]
        
        if ($BeforeValue -is [double] -and $AfterValue -is [double]) {
            $Change = $AfterValue - $BeforeValue
            $ChangePercent = if ($BeforeValue -ne 0) { [math]::Round(($Change / $BeforeValue) * 100, 2) } else { 0 }
            
            $Comparison[$Key] = @{
                Before = $BeforeValue
                After = $AfterValue
                Change = $Change
                ChangePercent = $ChangePercent
                Improved = $false
            }
            
            # Determine improvement based on metric type
            switch ($Key) {
                "CPUUsage" { $Comparison[$Key].Improved = $Change -lt 0 }
                "MemoryUsagePercent" { $Comparison[$Key].Improved = $Change -lt 0 }
                "DiskUsagePercent" { $Comparison[$Key].Improved = $Change -lt 0 }
                "FreeMemoryGB" { $Comparison[$Key].Improved = $Change -gt 0 }
                "FreeDiskSpaceGB" { $Comparison[$Key].Improved = $Change -gt 0 }
                default { $Comparison[$Key].Improved = $false }
            }
        }
    }
}
 
return $Comparison
}

#endregion

#region OPTIMIZATION ENGINE #===============================================

CORE OPTIMIZATION PROCESSING ENGINE
#===============================================

class Optimization { [string]$Name [string]$Description [string]$Category [string]$SubCategory [int]$Priority [scriptblock]$Action [scriptblock]$Validation [scriptblock]$Rollback [string[]]$Dependencies [string[]]$Conflicts [bool]$RequiresReboot [bool]$IsSafe [string]$RiskLevel [hashtable]$Metrics [string]$ID

Optimization( [string]$Name, [string]$Description, [string]$Category, [scriptblock]$Action ) { $this.Name = $Name $this.Description = $Description $this.Category = $Category $this.Action = $Action $this.Priority = 5 $this.RequiresReboot = $false $this.IsSafe = $true $this.RiskLevel = "Low" $this.Dependencies = @() $this.Conflicts = @() $this.Metrics = @{} $this.ID = "OPT-" + (Get-Random -Maximum 99999).ToString("00000") }

}

function New-Optimization { param( [Parameter(Mandatory=$true)][string]$Name, [Parameter(Mandatory=$true)][string]$Description, [Parameter(Mandatory=$true)][string]$Category, [Parameter(Mandatory=$true)][scriptblock]$Action, [string]$SubCategory = "", [int]$Priority = 5, [scriptblock]$Validation = $null, [scriptblock]$Rollback = $null, [string[]]$Dependencies = @(), [string[]]$Conflicts = @(), [bool]$RequiresReboot = $false, [bool]$IsSafe = $true, [string]$RiskLevel = "Low" )

$Opt = [Optimization]::new($Name, $Description, $Category, $Action) $Opt.SubCategory = $SubCategory $Opt.Priority = $Priority $Opt.Validation = $Validation $Opt.Rollback = $Rollback $Opt.Dependencies = $Dependencies $Opt.Conflicts = $Conflicts $Opt.RequiresReboot = $RequiresReboot $Opt.IsSafe = $IsSafe $Opt.RiskLevel = $RiskLevel

return $Opt
}

function Invoke-Optimization { param([Optimization]$Optimization)

$Global:TotalOptimizations++ $StartTime = Get-Date

Write-Log "Applying optimization: $($Optimization.Name)" "INFO" $Optimization.Category $Optimization.SubCategory $Optimization.ID
 
try {
    # Pre-validation
    if ($Optimization.Validation) {
        $ValidationResult = & $Optimization.Validation
        if (!$ValidationResult) {
            Write-Log "Optimization validation failed: $($Optimization.Name)" "WARN" $Optimization.Category $Optimization.SubCategory $Optimization.ID
            return $false
        }
    }
    
    # Check dependencies
    foreach ($Dep in $Optimization.Dependencies) {
        if (!(Test-OptimizationApplied $Dep)) {
            Write-Log "Dependency not met: $Dep for $($Optimization.Name)" "WARN" $Optimization.Category $Optimization.SubCategory $Optimization.ID
            return $false
        }
    }
    
    # Check conflicts
    foreach ($Conflict in $Optimization.Conflicts) {
        if (Test-OptimizationApplied $Conflict) {
            Write-Log "Conflict detected: $Conflict with $($Optimization.Name)" "WARN" $Optimization.Category $Optimization.SubCategory $Optimization.ID
            return $false
        }
    }
    
    # Execute optimization
    if (!$Global:IsDryRun) {
        & $Optimization.Action
        $Global:AppliedOptimizations++
        
        # Record optimization
        Add-AppliedOptimization -Optimization $Optimization
        
        Write-Log "Successfully applied: $($Optimization.Name)" "SUCCESS" $Optimization.Category $Optimization.SubCategory $Optimization.ID
    } else {
        Write-Log "DRY RUN: $($Optimization.Name)" "INFO" $Optimization.Category $Optimization.SubCategory $Optimization.ID
    }
    
    $Duration = (Get-Date) - $StartTime
    $Optimization.Metrics.ExecutionTime = $Duration.TotalMilliseconds
    
    return $true
} catch {
    $Global:FailedOptimizations++
    Write-Log "Failed to apply optimization: $($Optimization.Name) - $($_.Exception.Message)" "ERROR" $Optimization.Category $Optimization.SubCategory $Optimization.ID
    
    # Attempt rollback if available
    if ($Optimization.Rollback) {
        try {
            Write-Log "Attempting rollback for: $($Optimization.Name)" "WARN" $Optimization.Category $Optimization.SubCategory $Optimization.ID
            & $Optimization.Rollback
            Write-Log "Rollback completed: $($Optimization.Name)" "SUCCESS" $Optimization.Category $Optimization.SubCategory $Optimization.ID
        } catch {
            Write-Log "Rollback failed: $($Optimization.Name) - $($_.Exception.Message)" "ERROR" $Optimization.Category $Optimization.SubCategory $Optimization.ID
        }
    }
    
    return $false
}
}

function Add-AppliedOptimization { param([Optimization]$Optimization)

$AppliedFile = "$Global:ConfigPath\AppliedOptimizations.json"

try {
    $AppliedList = @()
    if (Test-Path $AppliedFile) {
        $AppliedList = Get-Content $AppliedFile | ConvertFrom-Json
    }
    
    $AppliedEntry = @{
        ID = $Optimization.ID
        Name = $Optimization.Name
        Category = $Optimization.Category
        SubCategory = $Optimization.SubCategory
        AppliedDate = Get-Date
        ScriptVersion = $Global:ScriptVersion
        RequiresReboot = $Optimization.RequiresReboot
    }
    
    $AppliedList += $AppliedEntry
    $AppliedList | ConvertTo-Json -Depth 5 | Out-File $AppliedFile
    
} catch {
    Write-Log "Failed to record applied optimization: $($_.Exception.Message)" "WARN"
}
}

function Test-OptimizationApplied { param([string]$OptimizationID)

try { $AppliedFile = "$Global:ConfigPath\AppliedOptimizations.json" if (Test-Path $AppliedFile) { $AppliedList = Get-Content $AppliedFile | ConvertFrom-Json return $AppliedList.ID -contains $OptimizationID } } catch { Write-Log "Failed to check applied optimization: $($_.Exception.Message)" "WARN" }

return $false
}

#endregion

Write-Log "YMs INSANE Ultimate Windows Control Center - Core Framework Loaded" "SUCCESS"</arg_value> <arg_key>EmptyFile</arg_key> <arg_value>false</arg_value> </tool_call>
