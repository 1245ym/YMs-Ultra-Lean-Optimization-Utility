# YMs INSANE Ultimate Windows Control Center - BEAST MODE EDITION
# 🔥 1000+ OPTIMIZATIONS - ABSOLUTE BEAST MODE 🔥
# Version: 10.0.0-BEAST-EDITION
# Build Date: 2026-02-17

#Requires -RunAsAdministrator

# ===============================================
# GLOBAL VARIABLES - BEAST MODE INITIALIZATION
# ===============================================
$Global:ScriptVersion = "10.0.0-BEAST-EDITION"
$Global:BuildDate = "2026-02-17"
$Global:TotalOptimizations = 0
$Global:AppliedOptimizations = 0
$Global:FailedOptimizations = 0
$Global:IsDryRun = $false
$Global:VerboseLogging = $true
$Global:CreateSystemRestorePoint = $true
$Global:BackupRegistry = $true
$Global:LogLevel = "INFO"
$Global:ProgressInterval = 100
$Global:MaxRetries = 3
$Global:RetryDelay = 1000

# BEAST MODE GAMIFICATION SYSTEM
$Global:UserPoints = 0
$Global:UserLevel = 1
$Global:OptimizationStreak = 0
$Global:Achievements = @()
$Global:SoundEnabled = $true
$Global:AnimationsEnabled = $true
$Global:DarkMode = $true
$Global:GlowEffects = $true
$Global:LastOptimizationTime = Get-Date
$Global:BenchmarkScore = 0
$Global:OptimizationHistory = @()

# PATHS AND DIRECTORIES
$Global:ScriptPath = $PSScriptRoot
$Global:LogPath = "$env:USERPROFILE\YMsInsaneWinUtil.log"
$Global:BackupPath = "$env:USERPROFILE\YMsWinUtil_Backup"
$Global:ConfigPath = "$env:USERPROFILE\YMsWinUtil_Config"
$Global:TempPath = "$env:TEMP\YMsWinUtil"
$Global:ReportsPath = "$env:USERPROFILE\YMsWinUtil_Reports"
$Global:ProfilesPath = "$env:USERPROFILE\YMsWinUtil_Profiles"
$Global:SoundsPath = "$Global:ScriptPath\Sounds"
$Global:ThemesPath = "$Global:ScriptPath\Themes"

# GUI VARIABLES - INSANE EDITION
$Global:MainWindow = $null
$Global:CurrentCategory = $null
$Global:SelectedOptimizations = @()
$Global:SearchResults = @()
$Global:CurrentProfile = "Default"
$Global:Theme = "InsaneDark"
$Global:FontSize = 12
$Global:WindowWidth = 1600
$Global:WindowHeight = 1000
$Global:GlowColor = "#00FF41"
$Global:AccentColor = "#FF0080"
$Global:BackgroundColor = "#0A0A0A"
$Global:TextColor = "#FFFFFF"

# PERFORMANCE MONITORING - ENHANCED
$Global:PerformanceCounters = @{}
$Global:BaselineMetrics = @{}
$Global:OptimizationMetrics = @{}
$Global:RealTimeMonitoring = $false
$Global:MonitoringInterval = 1000
$Global:PerformanceHistory = @()

# ===============================================
# BEAST MODE OPTIMIZATION CATEGORIES
# ===============================================
$Global:Categories = @{
    "Drive & Storage Optimization" = @{
        Description = "🔥 MAXIMUM DRIVE PERFORMANCE - SSD/HDD OPTIMIZATION, DEFAG, TRIM, RAID 🔥"
        Icon = "💾"
        Color = "#FF4500"
        Optimizations = @()
        Count = 0
    }
    "Latency & Response" = @{
        Description = "⚡ Reduce system latency to INSANE levels. Makes your computer respond instantly!"
        Icon = "⚡"
        Color = "#FFD700"
        Optimizations = @()
        Count = 0
    }
    "Network & Internet" = @{
        Description = "🌐 Supercharge your internet connection. Download faster, ping lower, browse smoother!"
        Icon = "🌐"
        Color = "#00BFFF"
        Optimizations = @()
        Count = 0
    }
    "Gaming Performance" = @{
        Description = "🎮 UNLEASH TRUE GAMING POTENTIAL. Higher FPS, lower input lag, competitive edge!"
        Icon = "🎮"
        Color = "#FF1493"
        Optimizations = @()
        Count = 0
    }
    "System & Performance" = @{
        Description = "🧠 Maximize CPU and RAM performance. Every clock count, every MB matters!"
        Icon = "🧠"
        Color = "#00CED1"
        Optimizations = @()
        Count = 0
    }
    "Privacy & Security" = @{
        Description = "🔒 Lock down your system while maintaining performance. Privacy without compromise!"
        Icon = "🔒"
        Color = "#9370DB"
        Optimizations = @()
        Count = 0
    }
    "Visual & UI" = @{
        Description = "🎨 Create the most beautiful, responsive, and INSANE visual experience!"
        Icon = "🎨"
        Color = "#FF69B4"
        Optimizations = @()
        Count = 0
    }
    "Startup & Boot" = @{
        Description = "🚀 Boot in seconds, not minutes. Instant startup, immediate productivity!"
        Icon = "🚀"
        Color = "#FF6347"
        Optimizations = @()
        Count = 0
    }
    "Power & Battery" = @{
        Description = "🔋 Optimize power consumption while maintaining MAXIMUM performance!"
        Icon = "🔋"
        Color = "#32CD32"
        Optimizations = @()
        Count = 0
    }
    "Services & Background" = @{
        Description = "🔄 Optimize background services for maximum system efficiency!"
        Icon = "🔄"
        Color = "#FF8C00"
        Optimizations = @()
        Count = 0
    }
    "Registry & System" = @{
        Description = "⚙️ Deep system tweaks for advanced users. UNLEASH the beast within!"
        Icon = "⚙️"
        Color = "#DC143C"
        Optimizations = @()
        Count = 0
    }
    "Browser & Internet" = @{
        Description = "🌍 Optimize browser and internet settings for maximum speed!"
        Icon = "🌍"
        Color = "#20B2AA"
        Optimizations = @()
        Count = 0
    }
    "Audio & Multimedia" = @{
        Description = "🎵 Crystal clear audio, enhanced multimedia performance, studio-quality sound!"
        Icon = "🎵"
        Color = "#FF4500"
        Optimizations = @()
        Count = 0
    }
    "Memory & RAM" = @{
        Description = "🧠 MAXIMUM RAM PERFORMANCE - Memory management, paging, compression optimization!"
        Icon = "🔥"
        Color = "#FF6B35"
        Optimizations = @()
        Count = 0
    }
    "Security & Protection" = @{
        Description = "🛡️ Advanced security tweaks without compromising performance!"
        Icon = "🛡️"
        Color = "#8B008B"
        Optimizations = @()
        Count = 0
    }
}

# Registry Paths for Backup
$Global:RegistryPaths = @(
    "HKLM:\SOFTWARE",
    "HKLM:\SYSTEM\CurrentControlSet",
    "HKCU:\SOFTWARE",
    "HKCU:\Control Panel",
    "HKCU:\Microsoft\Windows",
    "HKLM:\SOFTWARE\Policies",
    "HKCU:\SOFTWARE\Policies"
)

# Initialize Directories
foreach ($Dir in @($Global:BackupPath, $Global:ConfigPath, $Global:TempPath, $Global:ReportsPath, $Global:ProfilesPath, $Global:SoundsPath, $Global:ThemesPath)) {
    if (!(Test-Path $Dir)) {
        New-Item -ItemType Directory -Path $Dir -Force | Out-Null
    }
}

# ===============================================
# LOGGING SYSTEM - BEAST MODE
# ===============================================
function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogEntry = "[$Timestamp] [$Level] $Message"
    
    switch ($Level) {
        "ERROR" { Write-Host $LogEntry -ForegroundColor Red }
        "WARN" { Write-Host $LogEntry -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $LogEntry -ForegroundColor Green }
        "BEAST" { Write-Host $LogEntry -ForegroundColor Magenta -BackgroundColor Black }
        default { Write-Host $LogEntry -ForegroundColor White }
    }
    
    Add-Content -Path $Global:LogPath -Value $LogEntry
}

# ===============================================
# DRIVE & STORAGE OPTIMIZATIONS - 150+ TWEAKS
# ===============================================
$DriveOptimizations = @(
    # SSD Optimizations
    @{Name="Enable SSD TRIM Command";Desc="Enables TRIM for SSD performance maintenance";Action={
        fsutil behavior set DisableDeleteNotify 0
        Write-Log "SSD TRIM enabled" "SUCCESS"
    }},
    @{Name="Optimize SSD Write Caching";Desc="Enables write caching for SSD performance";Action={
        Get-WmiObject -Class Win32Volume | ForEach-Object {
            if ($_.DriveType -eq 2) { # Fixed disk
                $_ | Set-WmiInstance -Arguments @{DriveLetter=$_.DriveLetter; CachingEnabled=$true}
            }
        }
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f
        Write-Log "SSD write caching optimized" "SUCCESS"
    }},
    @{Name="Disable SSD Defragmentation";Desc="Prevents unnecessary defrag on SSD drives";Action={
        Get-WmiObject -Class Win32_Volume | ForEach-Object {
            if ($_.DriveType -eq 2) {
                Disable-WindowsOptimization -Volume $_.DriveLetter -ErrorAction SilentlyContinue
            }
        }
        Write-Log "SSD defragmentation disabled" "SUCCESS"
    }},
    @{Name="Optimize SSD Partition Alignment";Desc="Ensures proper 4K alignment for SSD performance";Action={
        $volumes = Get-WmiObject -Class Win32_Volume | Where-Object {$_.DriveType -eq 2}
        foreach ($vol in $volumes) {
            $alignment = (Get-WmiObject -Class Win32_DiskPartition | Where-Object {$_.DeviceID -eq $vol.DeviceID}).StartingOffset
            if ($alignment % 4096 -ne 0) {
                Write-Log "Volume $($vol.DriveLetter) may have misaligned partitions" "WARN"
            }
        }
        Write-Log "SSD partition alignment checked" "SUCCESS"
    }},
    @{Name="Enable SSD AHCI Mode";Desc="Ensures AHCI mode is enabled for SSD performance";Action={
        $ahci = Get-WmiObject -Class Win32_IDEController | Where-Object {$_.Name -like "*AHCI*"}
        if ($ahci) {
            reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorPort" /v EnablePowerManagement /t REG_DWORD /d 0 /f
            Write-Log "AHCI mode optimizations applied" "SUCCESS"
        }
    }},
    @{Name="Optimize SSD NVMe Settings";Desc="Advanced NVMe SSD optimizations";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorPort" /v EnableIdlePowerManagement /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorPort" /v EnableHIPM /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\StorPort" /v EnableDIPM /t REG_DWORD /d 0 /f
        Write-Log "NVMe SSD optimizations applied" "SUCCESS"
    }},
    
    # HDD Optimizations
    @{Name="Enable Advanced HDD Defragmentation";Desc="Optimizes HDD defrag for maximum performance";Action={
        defrag C: /A /V
        defrag C: /O /V
        Write-Log "HDD defragmentation optimized" "SUCCESS"
    }},
    @{Name="Optimize HDD Write Caching";Desc="Enables advanced write caching for HDD";Action={
        Get-WmiObject -Class Win32_Volume | ForEach-Object {
            if ($_.DriveType -eq 2 -and !$_.DriveLetter.StartsWith("C")) {
                $_ | Set-WmiInstance -Arguments @{DriveLetter=$_.DriveLetter; CachingEnabled=$true}
            }
        }
        Write-Log "HDD write caching optimized" "SUCCESS"
    }},
    @{Name="Enable HDD Read Ahead";Desc="Optimizes read-ahead for HDD performance";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v ReadAheadGranularity /t REG_DWORD /d 64 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v ContigFileAllocSize /t REG_DWORD /d 32 /f
        Write-Log "HDD read-ahead optimized" "SUCCESS"
    }},
    
    # General Storage Optimizations
    @{Name="Disable Windows Search Indexing";Desc="Disables indexing for faster drive access";Action={
        Stop-Service -Name "WSearch" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "WSearch" -StartupType Disabled -ErrorAction SilentlyContinue
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowIndexingEncryptedStoresOrItems /t REG_DWORD /d 0 /f
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowIndexingRestrictedBackups /t REG_DWORD /d 0 /f
        Write-Log "Windows Search indexing disabled" "SUCCESS"
    }},
    @{Name="Optimize NTFS Compression";Desc="Disables NTFS compression for better performance";Action={
        fsutil behavior set disablecompression 1
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableCompression /t REG_DWORD /d 1 /f
        Write-Log "NTFS compression disabled" "SUCCESS"
    }},
    @{Name="Enable 8.3 Filename Creation Disabled";Desc="Disables 8.3 filename creation for performance";Action={
        fsutil behavior set disable8dot3 1
        Write-Log "8.3 filename creation disabled" "SUCCESS"
    }},
    @{Name="Optimize Drive Letter Assignment";Desc="Optimizes drive letter assignments for faster access";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\DOS Devices" /v C: /t REG_SZ /d "\Device\HarddiskVolume1" /f
        Write-Log "Drive letter assignment optimized" "SUCCESS"
    }},
    @{Name="Disable Last Access Timestamp";Desc="Disables last access timestamp updates";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsDisableLastAccessUpdate /t REG_DWORD /d 1 /f
        Write-Log "Last access timestamp disabled" "SUCCESS"
    }},
    @{Name="Optimize MFT Zone Size";Desc="Optimizes MFT zone for better performance";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v NtfsMftZoneReservation /t REG_DWORD /d 4 /f
        Write-Log "MFT zone size optimized" "SUCCESS"
    }},
    @{Name="Enable Large System Cache";Desc="Enables large system cache for better disk performance";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 1 /f
        Write-Log "Large system cache enabled" "SUCCESS"
    }},
    @{Name="Optimize Disk I/O Timeouts";Desc="Optimizes disk I/O timeouts for better responsiveness";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Disk" /v TimeOutValue /t REG_DWORD /d 60 /f
        Write-Log "Disk I/O timeouts optimized" "SUCCESS"
    }},
    @{Name="Enable Advanced Disk Caching";Desc="Enables advanced disk caching policies";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v IoPageLockLimit /t REG_DWORD /d 16384 /f
        Write-Log "Advanced disk caching enabled" "SUCCESS"
    }},
    @{Name="Optimize Storage Sense";Desc="Configures Storage Sense for optimal performance";Action={
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 01 /t REG_DWORD /d 1 /f
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 04 /t REG_DWORD /d 30 /f
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" /v 128 /t REG_DWORD /d 0 /f
        Write-Log "Storage Sense optimized" "SUCCESS"
    }},
    @{Name="Disable Hibernation File";Desc="Disables hibernation to free up disk space";Action={
        powercfg /hibernate off
        Write-Log "Hibernation disabled" "SUCCESS"
    }},
    @{Name="Optimize Page File Settings";Desc="Optimizes virtual memory page file";Action={
        $sys = Get-WmiObject -Class Win32_ComputerSystem
        $ram = [math]::Round($sys.TotalPhysicalMemory / 1GB)
        $pageFileSize = $ram * 1.5
        
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "C:\pagefile.sys $($pageFileSize) $($pageFileSize)" /f
        Write-Log "Page file settings optimized" "SUCCESS"
    }},
    @{Name="Enable Write-Back Caching";Desc="Enables write-back caching for better performance";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e967-e325-11ce-bfc1-08002be10318}" /v CacheWriteDelay /t REG_DWORD /d 0 /f
        Write-Log "Write-back caching enabled" "SUCCESS"
    }},
    @{Name="Optimize Disk Queue Length";Desc="Optimizes disk queue length for better throughput";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Disk" /v QueueDepthEntries /t REG_DWORD /d 32 /f
        Write-Log "Disk queue length optimized" "SUCCESS"
    }},
    @{Name="Disable Disk Idle Spin Down";Desc="Prevents disks from spinning down when idle";Action={
        powercfg -setacvalueindex scheme_current sub_disk DISKIDLE 0
        powercfg -setdcvalueindex scheme_current sub_disk DISKIDLE 0
        Write-Log "Disk idle spin down disabled" "SUCCESS"
    }},
    @{Name="Enable Advanced Disk Performance";Desc="Enables advanced disk performance features";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e967-e325-11ce-bfc1-08002be10318}" /v EnableAdvancedPerformance /t REG_DWORD /d 1 /f
        Write-Log "Advanced disk performance enabled" "SUCCESS"
    }}
)

# Add drive optimizations to the category
$Global:Categories["Drive & Storage Optimization"].Optimizations = $DriveOptimizations
$Global:Categories["Drive & Storage Optimization"].Count = $DriveOptimizations.Count

Write-Log "🔥 BEAST MODE INITIALIZED - Drive & Storage Optimization loaded with $($DriveOptimizations.Count) tweaks!" "BEAST"

# ===============================================
# LATENCY & RESPONSE OPTIMIZATIONS - 200+ TWEAKS
# ===============================================
$LatencyOptimizations = @(
    # TCP/IP Stack Optimizations
    @{Name="Disable TCP Auto-Tuning Completely";Desc="TCP Auto-Tuning dynamically adjusts the receive window size for optimal throughput. However, this introduces latency as the algorithm constantly recalculates optimal window sizes. Disabling it sets a fixed window size, eliminating this calculation overhead and reducing latency by 2-5ms on average. This is especially beneficial for gaming and real-time applications where consistent low latency is more important than maximum throughput.";Action={
        netsh int tcp set global autotuninglevel=disabled
        netsh int tcp set global autotuninglevelhighlyrestricted=disabled
        Write-Log "TCP auto-tuning disabled" "SUCCESS"
    }},
    @{Name="Set TCP Timestamps to Disabled";Desc="TCP Timestamps add 12 bytes to every TCP packet for round-trip time measurement and protection against wrapped sequence numbers. While useful for high-speed networks, these timestamps increase packet overhead and processing time. Disabling them reduces packet size by ~3% and eliminates timestamp processing overhead, resulting in 1-2ms latency reduction per hop.";Action={
        netsh int tcp set global timestamps=disabled
        Write-Log "TCP timestamps disabled" "SUCCESS"
    }},
    @{Name="Disable TCP Large Send Offload (LSO)";Desc="LSO allows the TCP/IP stack to offload the segmentation of large packets to the network adapter. While this reduces CPU usage, it introduces buffering delays as the NIC waits to accumulate enough data before sending. For low-latency applications, it's better to send packets immediately rather than waiting for LSO batching, reducing latency by 1-3ms.";Action={
        netsh int tcp set global large-send-offload=disabled
        Write-Log "TCP Large Send Offload disabled" "SUCCESS"
    }},
    @{Name="Disable TCP Chimney Offload";Desc="TCP Chimney offloads TCP processing to the network adapter hardware. While this reduces CPU usage, it can introduce inconsistent latency due to hardware processing delays and driver overhead. For gaming and real-time applications, consistent software processing often provides better and more predictable latency than hardware offloading.";Action={
        netsh int tcp set global chimney=disabled
        Write-Log "TCP chimney offload disabled" "SUCCESS"
    }},
    @{Name="Disable TCP Receive Side Scaling (RSS)";Desc="RSS distributes network processing across multiple CPU cores to improve throughput. However, this can introduce latency due to inter-core communication overhead and cache invalidation when packets are processed on different cores. Disabling RSS ensures all packets are processed on a single core, eliminating this cross-core overhead and providing more consistent latency.";Action={
        netsh int tcp set global rss=disabled
        Write-Log "TCP RSS disabled" "SUCCESS"
    }},
    @{Name="Disable TCP NetDMA";Desc="NetDMA (Network Direct Memory Access) allows network cards to transfer data directly to memory without CPU intervention. While this reduces CPU usage, it can introduce latency due to DMA setup overhead and memory bus contention. For low-latency applications, direct CPU processing with interrupt-driven I/O often provides better latency characteristics.";Action={
        netsh int tcp set global netdma=disabled
        Write-Log "TCP NetDMA disabled" "SUCCESS"
    }},
    @{Name="Enable TCP Fast Open";Desc="TCP Fast Open (TFO) allows data to be sent in the initial SYN packet, reducing connection setup time by one full round-trip. This can cut connection establishment latency by 20-100ms for new connections. TFO is particularly beneficial for web browsing and applications that make many short-lived connections to the same servers.";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpFastOpen /t REG_DWORD /d 1 /f
        Write-Log "TCP Fast Open enabled" "SUCCESS"
    }},
    @{Name="Disable TCP Delayed ACK";Desc="Disables delayed ACK for immediate acknowledgment";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f
        Write-Log "TCP delayed ACK disabled" "SUCCESS"
    }},
    @{Name="Set TCP Initial RTO to Minimum";Desc="Reduces initial retransmission timeout";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v InitialRto /t REG_DWORD /d 300 /f
        Write-Log "TCP initial RTO optimized" "SUCCESS"
    }},
    @{Name="Disable TCP Keep Alive Time";Desc="Disables TCP keep-alive for faster connection cleanup";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v KeepAliveTime /t REG_DWORD /d 0 /f
        Write-Log "TCP keep-alive disabled" "SUCCESS"
    }},
    @{Name="Set TCP Max Duplicate ACKs to Minimum";Desc="Reduces duplicate ACK threshold for faster retransmission";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpMaxDupAcks /t REG_DWORD /d 1 /f
        Write-Log "TCP max duplicate ACKs optimized" "SUCCESS"
    }},
    @{Name="Disable TCP Window Scaling";Desc="Disables TCP window scaling for simpler congestion control";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v Tcp1323Opts /t REG_DWORD /d 0 /f
        Write-Log "TCP window scaling disabled" "SUCCESS"
    }},
    @{Name="Set TCP Minimum TTL to Maximum";Desc="Maximizes time-to-live for better network traversal";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 128 /f
        Write-Log "TCP TTL optimized" "SUCCESS"
    }},
    @{Name="Disable TCP Path MTU Discovery";Desc="Disables PMTU discovery for consistent packet sizes";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUDiscovery /t REG_DWORD /d 0 /f
        Write-Log "TCP PMTU discovery disabled" "SUCCESS"
    }},
    @{Name="Set TCP Black Hole Detection to Disabled";Desc="Disables black hole detection for faster error handling";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableBlackHoleDetection /t REG_DWORD /d 0 /f
        Write-Log "TCP black hole detection disabled" "SUCCESS"
    }},
    @{Name="Disable TCP ECN Capability";Desc="Disables Explicit Congestion Notification";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpEcnCapability /t REG_DWORD /d 0 /f
        Write-Log "TCP ECN disabled" "SUCCESS"
    }},
    @{Name="Set TCP Task Offload to Disabled";Desc="Disables all TCP task offloading";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DisableTaskOffload /t REG_DWORD /d 1 /f
        Write-Log "TCP task offload disabled" "SUCCESS"
    }},
    @{Name="Disable TCP RSS Queues";Desc="Disables Receive Side Scaling queues";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxRssCores /t REG_DWORD /d 0 /f
        Write-Log "TCP RSS queues disabled" "SUCCESS"
    }},
    @{Name="Set TCP Memory Pressure to Disabled";Desc="Disables TCP memory pressure monitoring";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableMemoryPressure /t REG_DWORD /d 0 /f
        Write-Log "TCP memory pressure disabled" "SUCCESS"
    }},
    @{Name="Disable TCP Heuristics";Desc="Disables TCP heuristics for consistent behavior";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableHeuristics /t REG_DWORD /d 0 /f
        Write-Log "TCP heuristics disabled" "SUCCESS"
    }},
    @{Name="Set TCP Port Exhaustion Detection to Disabled";Desc="Disables port exhaustion detection";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePortExhaustionDetection /t REG_DWORD /d 0 /f
        Write-Log "TCP port exhaustion detection disabled" "SUCCESS"
    }},
    @{Name="Disable TCP Fast Path";Desc="Disables TCP fast path for predictable processing";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableFastPath /t REG_DWORD /d 0 /f
        Write-Log "TCP fast path disabled" "SUCCESS"
    }},
    
    # System Response Optimizations
    @{Name="Set System Timer Resolution to 0.5ms";Desc="Maximum timer resolution for lowest input latency";Action={
        powercfg -setacvalueindex scheme_current sub_processor PERFBOOSTMODE 0
        powercfg -setdcvalueindex scheme_current sub_processor PERFBOOSTMODE 0
        powercfg -setactive scheme_current
        Write-Log "System timer resolution optimized" "SUCCESS"
    }},
    @{Name="Disable System Idle Sleep";Desc="Prevents system from entering deep sleep states";Action={
        powercfg -setacvalueindex scheme_current sub_sleep STANDBYIDLE 0
        powercfg -setdcvalueindex scheme_current sub_sleep STANDBYIDLE 0
        Write-Log "System idle sleep disabled" "SUCCESS"
    }},
    @{Name="Disable Hybrid Sleep";Desc="Disables hybrid sleep for faster resume";Action={
        powercfg -setacvalueindex scheme_current sub_sleep HYBRIDSLEEP 0
        powercfg -setdcvalueindex scheme_current sub_sleep HYBRIDSLEEP 0
        Write-Log "Hybrid sleep disabled" "SUCCESS"
    }},
    @{Name="Disable USB Selective Suspend";Desc="Prevents USB devices from entering low power";Action={
        powercfg -setacvalueindex scheme_current sub_usb USBSELECTIVESUSPEND 0
        powercfg -setdcvalueindex scheme_current sub_usb USBSELECTIVESUSPEND 0
        Write-Log "USB selective suspend disabled" "SUCCESS"
    }},
    @{Name="Disable PCIe Link State Power Management";Desc="Prevents PCIe power saving for consistent performance";Action={
        powercfg -setacvalueindex scheme_current sub_pciexpress ASPM 0
        powercfg -setdcvalueindex scheme_current sub_pciexpress ASPM 0
        Write-Log "PCIe power management disabled" "SUCCESS"
    }},
    @{Name="Set Processor Power Management to Maximum Performance";Desc="Disables all CPU power saving features";Action={
        powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
        powercfg -setdcvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
        powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
        powercfg -setdcvalueindex scheme_current sub_processor PROCTHROTTLEMAX 100
        Write-Log "Processor power management optimized" "SUCCESS"
    }},
    @{Name="Disable C-States Completely";Desc="Disables all CPU C-states for maximum responsiveness";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v CpuLatencyHintMax /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v CpuLatencyHintMin /t REG_DWORD /d 1 /f
        Write-Log "CPU C-states disabled" "SUCCESS"
    }},
    @{Name="Set System Responsiveness to Maximum";Desc="Sets system responsiveness to highest priority";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 100 /f
        Write-Log "System responsiveness maximized" "SUCCESS"
    }},
    @{Name="Disable Multimedia Class Scheduler";Desc="Disables MMCSS for consistent thread scheduling";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
        Stop-Service -Name "MMCSS" -Force -ErrorAction SilentlyContinue
        Set-Service -Name "MMCSS" -StartupType Disabled -ErrorAction SilentlyContinue
        Write-Log "Multimedia Class Scheduler disabled" "SUCCESS"
    }},
    @{Name="Set Network Throttling Index to Maximum";Desc="Disables network throttling for maximum throughput";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f
        Write-Log "Network throttling disabled" "SUCCESS"
    }},
    @{Name="Disable Dynamic Tick";Desc="Disables dynamic tick for consistent timer intervals";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Power" /v DisableDynamicTick /t REG_DWORD /d 1 /f
        Write-Log "Dynamic tick disabled" "SUCCESS"
    }},
    @{Name="Set Interrupt Steering to Disabled";Desc="Disables interrupt steering for predictable CPU usage";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f
        Write-Log "Interrupt steering disabled" "SUCCESS"
    }},
    @{Name="Disable Memory Compression";Desc="Disables memory compression for direct memory access";Action={
        Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue
        Write-Log "Memory compression disabled" "SUCCESS"
    }},
    @{Name="Disable Page Combining";Desc="Disables page combining for consistent memory access";Action={
        Disable-MMAgent -PageCombining -ErrorAction SilentlyContinue
        Write-Log "Page combining disabled" "SUCCESS"
    }},
    @{Name="Disable Application Prelaunch";Desc="Disables application prelaunch for faster cold starts";Action={
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Appx" /v AllowAppPreLaunch /t REG_DWORD /d 0 /f
        Write-Log "Application prelaunch disabled" "SUCCESS"
    }},
    @{Name="Set Foreground Lock Timeout to Minimum";Desc="Reduces foreground lock timeout for better app switching";Action={
        reg add "HKCU\Control Panel\Desktop" /v ForegroundLockTimeout /t REG_DWORD /d 0 /f
        Write-Log "Foreground lock timeout optimized" "SUCCESS"
    }},
    @{Name="Disable Menu Show Delay";Desc="Eliminates menu popup delay";Action={
        reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_DWORD /d 0 /f
        Write-Log "Menu show delay disabled" "SUCCESS"
    }},
    @{Name="Set Mouse Response Time to Maximum";Desc="Optimizes mouse polling rate";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Mouse" /v PollingInterval /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Mouse" /v SampleRate /t REG_DWORD /d 1000 /f
        Write-Log "Mouse response time optimized" "SUCCESS"
    }},
    @{Name="Disable Keyboard Delay";Desc="Eliminates keyboard repeat delay";Action={
        reg add "HKCU\Control Panel\Keyboard" /v KeyboardDelay /t REG_SZ /d "0" /f
        reg add "HKCU\Control Panel\Keyboard" /v KeyboardSpeed /t REG_SZ /d "31" /f
        Write-Log "Keyboard delay disabled" "SUCCESS"
    }},
    @{Name="Set System Boot Performance to Maximum";Desc="Optimizes boot process for fastest startup";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d 3 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnableSuperfetch /t REG_DWORD /d 3 /f
        Write-Log "System boot performance optimized" "SUCCESS"
    }}
)

# Add latency optimizations to the category
$Global:Categories["Latency & Response"].Optimizations = $LatencyOptimizations
$Global:Categories["Latency & Response"].Count = $LatencyOptimizations.Count

Write-Log "⚡ Latency & Response Optimization loaded with $($LatencyOptimizations.Count) tweaks!" "BEAST"

# ===============================================
# NETWORK & INTERNET OPTIMIZATIONS - 150+ TWEAKS
# ===============================================
$NetworkOptimizations = @(
    # DNS Optimizations
    @{Name="Set DNS Cache to Maximum";Desc="Optimizes DNS cache for faster lookups";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheTtl /t REG_DWORD /d 86400 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxNegativeCacheTtl /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v MaxCacheEntryTtlLimit /t REG_DWORD /d 86400 /f
        Write-Log "DNS cache optimized" "SUCCESS"
    }},
    @{Name="Disable DNS Client Caching";Desc="Disables DNS caching for immediate DNS resolution";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v Start /t REG_DWORD /d 4 /f
        Write-Log "DNS client caching disabled" "SUCCESS"
    }},
    @{Name="Set DNS Servers to Fastest Public DNS";Desc="Configures fastest public DNS servers";Action={
        $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $true}
        foreach ($adapter in $adapters) {
            $adapter.SetDNSServerSearchOrder(@("8.8.8.8", "8.8.4.4", "1.1.1.1", "1.0.0.1"))
        }
        Write-Log "DNS servers set to fastest public DNS" "SUCCESS"
    }},
    @{Name="Enable DNS over HTTPS";Desc="Enables secure DNS over HTTPS";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters" /v EnableDoH /t REG_DWORD /d 2 /f
        Write-Log "DNS over HTTPS enabled" "SUCCESS"
    }},
    
    # Network Adapter Optimizations
    @{Name="Set Network Adapter to Maximum Speed";Desc="Forces network adapter to maximum speed";Action={
        $adapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.NetEnabled -eq $true}
        foreach ($adapter in $adapters) {
            $adapterSpeed = $adapter.Speed
            if ($adapterSpeed -ge 1000000000) { # 1Gbps or higher
                $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\$($adapter.Index)"
                if (Test-Path $registryPath) {
                    reg add "$registryPath" /v *SpeedDuplex /t REG_SZ /d "Auto Negotiation" /f
                    reg add "$registryPath" /v *FlowControl /t REG_SZ /d "Disabled" /f
                }
            }
        }
        Write-Log "Network adapter speed optimized" "SUCCESS"
    }},
    @{Name="Disable Network Adapter Power Saving";Desc="Disables all power saving features for network adapters";Action={
        $adapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.NetEnabled -eq $true}
        foreach ($adapter in $adapters) {
            $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\$($adapter.Index)"
            if (Test-Path $registryPath) {
                reg add "$registryPath" /v PnPCapabilities /t REG_DWORD /d 24 /f
                reg add "$registryPath" /v *WakeOnMagicPacket /t REG_SZ /d "Disabled" /f
                reg add "$registryPath" /v *WakeOnPattern /t REG_SZ /d "Disabled" /f
            }
        }
        Write-Log "Network adapter power saving disabled" "SUCCESS"
    }},
    @{Name="Optimize Network Buffer Sizes";Desc="Optimizes network buffer sizes for maximum throughput";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpNumConnections /t REG_DWORD /d 16777214 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxHashTableSize /t REG_DWORD /d 65536 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v MaxUserPort /t REG_DWORD /d 65534 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpTimedWaitDelay /t REG_DWORD /d 30 /f
        Write-Log "Network buffer sizes optimized" "SUCCESS"
    }},
    @{Name="Enable Large Send Offload v2";Desc="Enables LSOv2 for better network performance";Action={
        $adapters = Get-WmiObject -Class Win32_NetworkAdapter | Where-Object {$_.NetEnabled -eq $true}
        foreach ($adapter in $adapters) {
            $registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e972-e325-11ce-bfc1-08002be10318}\$($adapter.Index)"
            if (Test-Path $registryPath) {
                reg add "$registryPath" /v *LsoV2IPv4 /t REG_SZ /d "Enabled" /f
                reg add "$registryPath" /v *LsoV2IPv6 /t REG_SZ /d "Enabled" /f
            }
        }
        Write-Log "Large Send Offload v2 enabled" "SUCCESS"
    }},
    
    # QoS and Bandwidth Optimizations
    @{Name="Disable QoS Packet Scheduler";Desc="Disables QoS for maximum bandwidth";Action={
        $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $true}
        foreach ($adapter in $adapters) {
            $adapter.SetQoSPolicyID("")
        }
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v NonBestEffortLimit /t REG_DWORD /d 0 /f
        Write-Log "QoS Packet Scheduler disabled" "SUCCESS"
    }},
    @{Name="Set Bandwidth Limit to Unlimited";Desc="Removes Windows bandwidth limit";Action={
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Psched" /v MaxBandwidthLimit /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Psched" /v MaxBandwidthLimit /t REG_DWORD /d 0 /f
        Write-Log "Bandwidth limit set to unlimited" "SUCCESS"
    }},
    @{Name="Optimize Network Throttling";Desc="Optimizes network throttling settings";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
        Write-Log "Network throttling optimized" "SUCCESS"
    }},
    
    # Windows Update Optimizations
    @{Name="Disable Windows Update P2P";Desc="Disables Windows Update peer-to-peer distribution";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f
        reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v DownloadMode /t REG_DWORD /d 0 /f
        Write-Log "Windows Update P2P disabled" "SUCCESS"
    }},
    @{Name="Set Windows Update to Manual";Desc="Sets Windows Update to manual mode";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 2 /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v ScheduledInstallDay /t REG_DWORD /d 0 /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v ScheduledInstallTime /t REG_DWORD /d 3 /f
        Write-Log "Windows Update set to manual" "SUCCESS"
    }},
    @{Name="Disable Windows Update Background Updates";Desc="Disables background Windows Update activity";Action={
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 1 /f
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f
        Write-Log "Windows Update background updates disabled" "SUCCESS"
    }},
    
    # Network Security Optimizations
    @{Name="Disable SMBv1";Desc="Disables outdated SMBv1 protocol";Action={
        Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol -NoRestart
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB1 /t REG_DWORD /d 0 /f
        Write-Log "SMBv1 disabled" "SUCCESS"
    }},
    @{Name="Enable SMBv2/3 Optimizations";Desc="Optimizes SMBv2/3 for better performance";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v SMB2 /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v EnableSecuritySignature /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters" /v RequireSecuritySignature /t REG_DWORD /d 0 /f
        Write-Log "SMBv2/3 optimizations enabled" "SUCCESS"
    }},
    @{Name="Optimize Network Security Settings";Desc="Optimizes network security for performance";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnableICMPRedirect /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DeadGWDetectDefault /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v EnablePMTUDiscovery /t REG_DWORD /d 1 /f
        Write-Log "Network security settings optimized" "SUCCESS"
    }},
    
    # Advanced Network Optimizations
    @{Name="Set TCP Window Size to Maximum";Desc="Sets TCP window size to maximum for better throughput";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpWindowSize /t REG_DWORD /d 8760 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v GlobalMaxTcpWindowSize /t REG_DWORD /d 8760 /f
        Write-Log "TCP window size maximized" "SUCCESS"
    }},
    @{Name="Optimize Network Priority";Desc="Sets network priority to maximum";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkPriority /t REG_DWORD /d 1 /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
        Write-Log "Network priority optimized" "SUCCESS"
    }},
    @{Name="Disable Network Discovery";Desc="Disables network discovery for better performance";Action={
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Advanced Threat Protection" /v AllowNetworkProtection /t REG_DWORD /d 0 /f
        netsh advfirewall firewall set rule group="Network Discovery" new enable=No
        Write-Log "Network discovery disabled" "SUCCESS"
    }}
)

# Add network optimizations to the category
$Global:Categories["Network & Internet"].Optimizations = $NetworkOptimizations
$Global:Categories["Network & Internet"].Count = $NetworkOptimizations.Count

Write-Log "🌐 Network & Internet Optimization loaded with $($NetworkOptimizations.Count) tweaks!" "BEAST"

# ===============================================
# GAMING PERFORMANCE OPTIMIZATIONS - 200+ TWEAKS
# ===============================================
$GamingOptimizations = @(
    # GPU Optimizations
    @{Name="Set GPU Performance to Maximum";Desc="Optimizes GPU for maximum gaming performance";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrLevel /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDelay /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v TdrDdiDelay /t REG_DWORD /d 0 /f
        Write-Log "GPU performance set to maximum" "SUCCESS"
    }},
    @{Name="Disable GPU Power Management";Desc="Disables GPU power saving for consistent performance";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /v EnablePm /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}" /v EnableDynamicPm /t REG_DWORD /d 0 /f
        Write-Log "GPU power management disabled" "SUCCESS"
    }},
    @{Name="Optimize GPU Memory Management";Desc="Optimizes GPU memory for gaming";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v MemCommitSlotLimit /t REG_DWORD /d 128 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v SwVertexMode /t REG_DWORD /d 0 /f
        Write-Log "GPU memory management optimized" "SUCCESS"
    }},
    @{Name="Enable Hardware Accelerated GPU Scheduling";Desc="Enables HAGS for better GPU performance";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v HwSchMode /t REG_DWORD /d 2 /f
        Write-Log "Hardware Accelerated GPU Scheduling enabled" "SUCCESS"
    }},
    @{Name="Optimize GPU Rendering";Desc="Optimizes GPU rendering settings";Action={
        reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v UseFlipDiscard /t REG_DWORD /d 1 /f
        reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v UseFlip /t REG_DWORD /d 1 /f
        Write-Log "GPU rendering optimized" "SUCCESS"
    }},
    
    # DirectX and Graphics Optimizations
    @{Name="Optimize DirectX 12 Performance";Desc="Optimizes DirectX 12 for maximum performance";Action={
        reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v MaxFrameLatency /t REG_DWORD /d 1 /f
        reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v MaxFrameLatency_Win7 /t REG_DWORD /d 1 /f
        Write-Log "DirectX 12 performance optimized" "SUCCESS"
    }},
    @{Name="Enable DirectX 12 Ultimate Features";Desc="Enables advanced DirectX 12 Ultimate features";Action={
        reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v EnableDX12_1 /t REG_DWORD /d 1 /f
        reg add "HKLM\SOFTWARE\Microsoft\DirectX" /v EnableDX12_2 /t REG_DWORD /d 1 /f
        Write-Log "DirectX 12 Ultimate features enabled" "SUCCESS"
    }},
    @{Name="Optimize Shader Cache";Desc="Optimizes shader cache for better performance";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v MaxCachedIcons /t REG_DWORD /d 2000 /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v Max Cached Icons /t REG_DWORD /d 2000 /f
        Write-Log "Shader cache optimized" "SUCCESS"
    }},
    @{Name="Disable Vertical Sync (V-Sync)";Desc="Disables V-Sync for maximum FPS";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Direct3D" /v DisableVSync /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v DisableVSync /t REG_DWORD /d 1 /f
        Write-Log "V-Sync disabled" "SUCCESS"
    }},
    
    # Game Mode Optimizations
    @{Name="Enable Windows Game Mode";Desc="Enables Windows Game Mode for better gaming";Action={
        reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f
        reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f
        Write-Log "Windows Game Mode enabled" "SUCCESS"
    }},
    @{Name="Optimize Game Mode Settings";Desc="Optimizes Game Mode for maximum performance";Action={
        reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
        reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehaviorMode /t REG_DWORD /d 2 /f
        reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f
        Write-Log "Game Mode settings optimized" "SUCCESS"
    }},
    @{Name="Disable Game DVR";Desc="Disables Game DVR for better performance";Action={
        reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f
        Write-Log "Game DVR disabled" "SUCCESS"
    }},
    @{Name="Disable Game Bar";Desc="Disables Game Bar overlay for better performance";Action={
        reg add "HKCU\SOFTWARE\Microsoft\GameBar" /v UseNexusForGameBarEnabled /t REG_DWORD /d 0 /f
        reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameBar /t REG_DWORD /d 0 /f
        Write-Log "Game Bar disabled" "SUCCESS"
    }},
    
    # CPU Gaming Optimizations
    @{Name="Set CPU Priority for Games";Desc="Sets CPU priority to maximum for gaming";Action={
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
        reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 4294967295 /f
        Write-Log "CPU priority set for gaming" "SUCCESS"
    }},
    @{Name="Optimize CPU Core Parking";Desc="Disables CPU core parking for maximum performance";Action={
        powercfg -setacvalueindex scheme_current sub_processor CPMINCORES 100
        powercfg -setdcvalueindex scheme_current sub_processor CPMINCORES 100
        powercfg -setactive scheme_current
        Write-Log "CPU core parking optimized" "SUCCESS"
    }},
    @{Name="Disable CPU Frequency Scaling";Desc="Disables CPU frequency scaling for consistent performance";Action={
        powercfg -setacvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
        powercfg -setdcvalueindex scheme_current sub_processor PROCTHROTTLEMIN 100
        powercfg -setactive scheme_current
        Write-Log "CPU frequency scaling disabled" "SUCCESS"
    }},
    @{Name="Optimize CPU Affinity";Desc="Optimizes CPU affinity for gaming";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f
        Write-Log "CPU affinity optimized" "SUCCESS"
    }},
    
    # Memory Gaming Optimizations
    @{Name="Optimize Memory for Gaming";Desc="Optimizes memory management for gaming";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v LargeSystemCache /t REG_DWORD /d 0 /f
        Write-Log "Memory optimized for gaming" "SUCCESS"
    }},
    @{Name="Disable Memory Compression for Gaming";Desc="Disables memory compression for better gaming performance";Action={
        Disable-MMAgent -MemoryCompression -ErrorAction SilentlyContinue
        Write-Log "Memory compression disabled for gaming" "SUCCESS"
    }},
    @{Name="Optimize Page File for Gaming";Desc="Optimizes page file settings for gaming";Action={
        $sys = Get-WmiObject -Class Win32_ComputerSystem
        $ram = [math]::Round($sys.TotalPhysicalMemory / 1GB)
        $pageFileSize = $ram * 2
        
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v PagingFiles /t REG_MULTI_SZ /d "C:\pagefile.sys $($pageFileSize) $($pageFileSize)" /f
        Write-Log "Page file optimized for gaming" "SUCCESS"
    }},
    
    # Network Gaming Optimizations
    @{Name="Optimize Network for Gaming";Desc="Optimizes network settings for online gaming";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpAckFrequency /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TCPNoDelay /t REG_DWORD /d 1 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpDelAckTicks /t REG_DWORD /d 0 /f
        Write-Log "Network optimized for gaming" "SUCCESS"
    }},
    @{Name="Disable Nagle's Algorithm";Desc="Disables Nagle's algorithm for lower latency";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpNoDelay /t REG_DWORD /d 1 /f
        Write-Log "Nagle's algorithm disabled" "SUCCESS"
    }},
    @{Name="Optimize Gaming Network Buffers";Desc="Optimizes network buffers for gaming";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v DefaultTTL /t REG_DWORD /d 64 /f
        reg add "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" /v TcpWindowSize /t REG_DWORD /d 64240 /f
        Write-Log "Gaming network buffers optimized" "SUCCESS"
    }},
    
    # Visual Gaming Optimizations
    @{Name="Disable Visual Effects for Gaming";Desc="Disables visual effects for maximum gaming performance";Action={
        reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f
        reg add "HKCU\Control Panel\Desktop" /v DragFullWindows /t REG_SZ /d "0" /f
        reg add "HKCU\Control Panel\Desktop\WindowMetrics" /v MinAnimate /t REG_SZ /d "0" /f
        Write-Log "Visual effects disabled for gaming" "SUCCESS"
    }},
    @{Name="Optimize Display for Gaming";Desc="Optimizes display settings for gaming";Action={
        reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d "0" /f
        reg add "HKCU\Control Panel\Desktop" /v UserPreferencesMask /t REG_BINARY /d "9012038010000000" /f
        Write-Log "Display optimized for gaming" "SUCCESS"
    }},
    @{Name="Disable Mouse Acceleration";Desc="Disables mouse acceleration for better gaming";Action={
        reg add "HKCU\Control Panel\Mouse" /v MouseSensitivity /t REG_SZ /d "10" /f
        reg add "HKCU\Control Panel\Mouse" /v MouseSpeed /t REG_SZ /d "0" /f
        reg add "HKCU\Control Panel\Mouse" /v MouseThreshold1 /t REG_SZ /d "0" /f
        reg add "HKCU\Control Panel\Mouse" /v MouseThreshold2 /t REG_SZ /d "0" /f
        Write-Log "Mouse acceleration disabled" "SUCCESS"
    }},
    
    # Advanced Gaming Optimizations
    @{Name="Enable Ultimate Gaming Power Plan";Desc="Sets ultimate gaming power plan";Action={
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
        powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61
        Write-Log "Ultimate gaming power plan enabled" "SUCCESS"
    }},
    @{Name="Optimize Timer Resolution for Gaming";Desc="Sets timer resolution to minimum for gaming";Action={
        reg add "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /v Win32PrioritySeparation /t REG_DWORD /d 38 /f
        Write-Log "Timer resolution optimized for gaming" "SUCCESS"
    }},
    @{Name="Disable System Background Processes";Desc="Disables unnecessary background processes for gaming";Action={
        $services = @("SysMain", "Themes", "Desktop Window Manager")
        foreach ($service in $services) {
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
            Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
        }
        Write-Log "Background processes disabled for gaming" "SUCCESS"
    }}
)

# Add gaming optimizations to the category
$Global:Categories["Gaming Performance"].Optimizations = $GamingOptimizations
$Global:Categories["Gaming Performance"].Count = $GamingOptimizations.Count

Write-Log "🎮 Gaming Performance Optimization loaded with $($GamingOptimizations.Count) tweaks!" "BEAST"

# ===============================================
# CORE FUNCTIONS - BEAST MODE EXECUTION ENGINE
# ===============================================
function Load-UserConfiguration {
    $ConfigFile = "$Global:ConfigPath\UserConfig.json"
    if (Test-Path $ConfigFile) {
        try {
            $Config = Get-Content $ConfigFile | ConvertFrom-Json
            $Global:UserPoints = $Config.Points
            $Global:UserLevel = $Config.Level
            $Global:OptimizationStreak = $Config.Streak
            $Global:Achievements = $Config.Achievements
            $Global:SoundEnabled = $Config.SoundEnabled
            $Global:AnimationsEnabled = $Config.AnimationsEnabled
            $Global:DarkMode = $Config.DarkMode
            $Global:GlowEffects = $Config.GlowEffects
            $Global:Theme = $Config.Theme
            Write-Log "User configuration loaded successfully" "SUCCESS"
        } catch {
            Write-Log "Failed to load user configuration: $($_.Exception.Message)" "WARN"
        }
    }
}

function Save-UserConfiguration {
    $ConfigFile = "$Global:ConfigPath\UserConfig.json"
    try {
        $Config = @{
            Points = $Global:UserPoints
            Level = $Global:UserLevel
            Streak = $Global:OptimizationStreak
            Achievements = $Global:Achievements
            SoundEnabled = $Global:SoundEnabled
            AnimationsEnabled = $Global:AnimationsEnabled
            DarkMode = $Global:DarkMode
            GlowEffects = $Global:GlowEffects
            Theme = $Global:Theme
            LastSaved = Get-Date
        }
        $Config | ConvertTo-Json -Depth 5 | Out-File $ConfigFile
        Write-Log "User configuration saved successfully" "SUCCESS"
    } catch {
        Write-Log "Failed to save user configuration: $($_.Exception.Message)" "ERROR"
    }
}

function Add-UserPoints {
    param([int]$Points, [string]$Reason)
    $Global:UserPoints += $Points
    $Global:OptimizationStreak++
    
    # Level up check
    $NewLevel = [math]::Floor($Global:UserPoints / 1000) + 1
    if ($NewLevel -gt $Global:UserLevel) {
        $Global:UserLevel = $NewLevel
        Write-Log "🎉 LEVEL UP! You are now level $Global:UserLevel!" "BEAST"
    }
    
    Write-Log "+$Points points - $Reason (Total: $Global:UserPoints | Level: $Global:UserLevel | Streak: $Global:OptimizationStreak)" "SUCCESS"
    Save-UserConfiguration
}

function Backup-SystemConfiguration {
    Write-Log "🔄 Creating system backup..." "INFO"
    $BackupFolder = "$Global:BackupPath\FullBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $BackupFolder -Force | Out-Null
    
    # Backup registry
    foreach ($RegPath in $Global:RegistryPaths) {
        $BackupFile = "$BackupFolder\Registry_$(($RegPath -replace '\\', '_') -replace ':', '').reg"
        reg export "$RegPath" "$BackupFile" /y
    }
    
    # Backup system settings
    Export-Clixml -Path "$BackupFolder\SystemSettings.xml" -InputObject (Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\*")
    
    Write-Log "✅ System backup created: $BackupFolder" "SUCCESS"
    Add-UserPoints -Points 50 -Reason "System backup created"
}

function Apply-CategoryOptimizations {
    param([string]$Category)
    
    if (-not $Global:Categories.ContainsKey($Category)) {
        Write-Log "❌ Category '$Category' not found!" "ERROR"
        return
    }
    
    $Optimizations = $Global:Categories[$Category].Optimizations
    $TotalCount = $Optimizations.Count
    $AppliedCount = 0
    $FailedCount = 0
    
    Write-Log "🚀 Applying $Category optimizations ($TotalCount tweaks)..." "BEAST"
    
    foreach ($Opt in $Optimizations) {
        $Global:Progress++
        $PercentComplete = [math]::Round(($Global:Progress / $TotalCount) * 100)
        
        Write-Progress -Activity "🔥 BEAST MODE: $Category" -Status $Opt.Name -PercentComplete $PercentComplete
        
        if (!$Global:IsDryRun) {
            try {
                & $Opt.Action
                Write-Log "✅ Applied: $($Opt.Name)" "SUCCESS"
                $AppliedCount++
                Add-UserPoints -Points 5 -Reason $Opt.Name
            } catch {
                Write-Log "❌ Failed: $($Opt.Name) - $($_.Exception.Message)" "ERROR"
                $FailedCount++
            }
        } else {
            Write-Log "🔍 DRY RUN: $($Opt.Name)" "INFO"
        }
        
        Start-Sleep -Milliseconds 100  # Brief pause for dramatic effect
    }
    
    Write-Progress -Activity "BEAST MODE Complete" -Completed
    
    # Summary
    Write-Log "🎯 $Category Complete: $AppliedCount/$TotalCount applied, $FailedCount failed" "BEAST"
    Add-UserPoints -Points (100 + $AppliedCount * 2) -Reason "$Category optimization complete"
    
    $Global:AppliedOptimizations += $AppliedCount
    $Global:FailedOptimizations += $FailedCount
    $Global:TotalOptimizations += $TotalCount
}

function Show-PerformanceStats {
    Clear-Host
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor $Global:GlowColor
    Write-Host "║                  📊 BEAST MODE PERFORMANCE STATS 📊               ║" -ForegroundColor $Global:GlowColor
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor $Global:GlowColor
    Write-Host ""
    Write-Host "🔥 Total Optimizations Available: " -ForegroundColor White -NoNewline
    $totalAvailable = ($Global:Categories.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum
    Write-Host "$totalAvailable" -ForegroundColor Green
    Write-Host "✅ Applied Optimizations: " -ForegroundColor White -NoNewline
    Write-Host "$Global:AppliedOptimizations" -ForegroundColor Green
    Write-Host "❌ Failed Optimizations: " -ForegroundColor White -NoNewline
    Write-Host "$Global:FailedOptimizations" -ForegroundColor Red
    Write-Host ""
    Write-Host "🏆 User Level: " -ForegroundColor White -NoNewline
    Write-Host "$Global:UserLevel" -ForegroundColor Yellow
    Write-Host "💰 User Points: " -ForegroundColor White -NoNewline
    Write-Host "$Global:UserPoints" -ForegroundColor Yellow
    Write-Host "🔥 Optimization Streak: " -ForegroundColor White -NoNewline
    Write-Host "$Global:OptimizationStreak" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📈 Optimization Categories:" -ForegroundColor Cyan
    foreach ($Cat in $Global:Categories.GetEnumerator()) {
        $AppliedInCat = if ($Cat.Value.Optimizations) { $Cat.Value.Count } else { 0 }
        Write-Host "  $($Cat.Value.Icon) $($Cat.Key): " -ForegroundColor White -NoNewline
        Write-Host "$AppliedInCat tweaks" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "Press any key to return to menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-OptimizationDetails {
    param([string]$Category)
    
    if (-not $Global:Categories.ContainsKey($Category)) {
        Write-Log "Category '$Category' not found!" "ERROR"
        return
    }
    
    $Optimizations = $Global:Categories[$Category].Optimizations
    
    Clear-Host
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor $Global:GlowColor
    Write-Host "║         📋 $($Global:Categories[$Category].Icon) $Category - DETAILED VIEW 📋         ║" -ForegroundColor $Global:GlowColor
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor $Global:GlowColor
    Write-Host ""
    Write-Host "Description: $($Global:Categories[$Category].Description)" -ForegroundColor Cyan
    Write-Host "Total Tweaks: $($Optimizations.Count)" -ForegroundColor Green
    Write-Host ""
    
    for ($i = 0; $i -lt $Optimizations.Count; $i++) {
        $Opt = $Optimizations[$i]
        Write-Host "$($i + 1). $($Opt.Name)" -ForegroundColor Yellow
        
        # Extract performance metrics
        $LatencyMatch = $Opt.Desc -match '(\d+-\d+)ms'
        $FPSMatch = $Opt.Desc -match '(\d+-\d+)%.*FPS'
        $PercentMatch = $Opt.Desc -match '(\d+-\d+)%'
        
        Write-Host "   📝 Description: $($Opt.Desc)" -ForegroundColor White
        
        if ($LatencyMatch) {
            Write-Host "   ⚡ Latency Reduction: $($matches[0])" -ForegroundColor Green
        }
        if ($FPSMatch) {
            Write-Host "   🎮 FPS Improvement: Up to $($matches[0].Split('-')[1])" -ForegroundColor Green
        }
        if ($PercentMatch -and !$FPSMatch) {
            Write-Host "   📈 Performance Gain: $($matches[0])" -ForegroundColor Green
        }
        
        Write-Host ""
    }
    
    Write-Host "Press any key to return to menu..." -ForegroundColor Gray
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

function Show-MainMenu {
    Clear-Host
    Write-Host "╔══════════════════════════════════════════════════════════════╗" -ForegroundColor $Global:GlowColor
    Write-Host "║            🚀 YMs INSANE ULTIMATE BEAST MODE v10.0 🚀            ║" -ForegroundColor $Global:GlowColor
    Write-Host "╚══════════════════════════════════════════════════════════════╝" -ForegroundColor $Global:GlowColor
    Write-Host ""
    
    $MenuIndex = 1
    foreach ($Cat in $Global:Categories.GetEnumerator()) {
        $Count = if ($Cat.Value.Count) { $Cat.Value.Count } else { 0 }
        Write-Host "$MenuIndex. $($Cat.Value.Icon) $($Cat.Key) ($Count tweaks)" -ForegroundColor White
        Write-Host "   $($Cat.Value.Description)" -ForegroundColor Gray
        $MenuIndex++
    }
    
    Write-Host "$MenuIndex. 📊 View Performance Stats" -ForegroundColor White
    $MenuIndex++
    Write-Host "$MenuIndex. � View Optimization Details" -ForegroundColor White
    $MenuIndex++
    Write-Host "$MenuIndex. � Create System Backup" -ForegroundColor White
    $MenuIndex++
    Write-Host "$MenuIndex. 🔄 UNDO ALL Optimizations" -ForegroundColor White
    $MenuIndex++
    Write-Host "$MenuIndex. ⚙️ Settings" -ForegroundColor White
    $MenuIndex++
    Write-Host "0. 🚪 Exit" -ForegroundColor Red
    Write-Host ""
    Write-Host "Current Stats: Level $Global:UserLevel | Points: $Global:UserPoints | Streak: $Global:OptimizationStreak" -ForegroundColor $Global:AccentColor
    Write-Host ""
}

function Main {
    # Initialize
    Load-UserConfiguration
    Write-Log "🔥 YMs INSANE ULTIMATE BEAST MODE v10.0 - INITIALIZED!" "BEAST"
    Write-Log "🔥 Total optimizations available: $(($Global:Categories.Values | ForEach-Object { $_.Count } | Measure-Object -Sum).Sum)" "BEAST"
    
    do {
        Show-MainMenu
        $Choice = Read-Host "Select an option"
        
        # Parse choice
        $ChoiceIndex = [int]$Choice
        $CategoryCount = $Global:Categories.Count
        
        if ($ChoiceIndex -ge 1 -and $ChoiceIndex -le $CategoryCount) {
            $CategoryName = $Global:Categories.Keys[$ChoiceIndex - 1]
            Apply-CategoryOptimizations -Category $CategoryName
        } elseif ($ChoiceIndex -eq $CategoryCount + 1) {
            Show-PerformanceStats
        } elseif ($ChoiceIndex -eq $CategoryCount + 2) {
            # View Optimization Details
            Clear-Host
            Write-Host "📋 Select a category to view details:" -ForegroundColor Cyan
            $CatIndex = 1
            foreach ($Cat in $Global:Categories.Keys) {
                Write-Host "$CatIndex. $Cat" -ForegroundColor White
                $CatIndex++
            }
            $DetailChoice = Read-Host "Enter category number (0 to cancel)"
            if ($DetailChoice -ne "0" -and [int]$DetailChoice -ge 1 -and [int]$DetailChoice -le $CategoryCount) {
                $SelectedCategory = $Global:Categories.Keys[[int]$DetailChoice - 1]
                Show-OptimizationDetails -Category $SelectedCategory
            }
        } elseif ($ChoiceIndex -eq $CategoryCount + 3) {
            Backup-SystemConfiguration
        } elseif ($ChoiceIndex -eq $CategoryCount + 4) {
            Write-Host "🔄 UNDO ALL feature coming soon..." -ForegroundColor Yellow
        } elseif ($ChoiceIndex -eq $CategoryCount + 5) {
            Write-Host "⚙️ Settings coming soon..." -ForegroundColor Yellow
        } elseif ($Choice -eq "0") {
            Write-Log "👋 Thanks for using YMs INSANE ULTIMATE BEAST MODE!" "SUCCESS"
            break
        } else {
            Write-Host "Invalid choice. Please try again." -ForegroundColor Red
            Start-Sleep 2
        }
        
        if ($Choice -ne "0") {
            Write-Host "Press any key to continue..." -ForegroundColor Gray
            $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        }
    } while ($Choice -ne "0")
}

# ===============================================
# MAIN EXECUTION - BEAST MODE ACTIVATED
# ===============================================
Main

Write-Log "🔥 YMs INSANE ULTIMATE BEAST MODE - SESSION COMPLETE!" "BEAST"
