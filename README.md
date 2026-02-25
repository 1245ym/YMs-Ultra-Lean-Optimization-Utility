<h1 align="center">Ultra Lean Windows Optimization Utility</h1>

<p align="center">
  <img src="https://img.shields.io/badge/PowerShell-5%2B-5391FE?logo=powershell&logoColor=white" />
  <img src="https://img.shields.io/badge/Windows-10%20%7C%2011-0078D6?logo=windows&logoColor=white" />
  <img src="https://img.shields.io/badge/License-MIT-green.svg" />
  <img src="https://img.shields.io/badge/Project-Active-brightgreen" />
  <img src="https://img.shields.io/badge/Tweaks-60%2B-blue" />
  <img src="https://img.shields.io/badge/Interface-GUI%20%2F%20WinForms-orange" />
  <img src="https://img.shields.io/badge/Architecture-PowerShell-lightgrey" />
</p>

<p align="center">
A modern, GUI-based Windows optimization tool designed to improve performance, reduce latency, enhance gaming responsiveness, and give users full control over 60+ real system tweaks — all through a clean, intuitive interface.
</p>

---

## ⚡ Quick Install & Run

Run this command in **PowerShell (Run as Administrator)**:

```powershell
irm https://raw.githubusercontent.com/1245ym/YMs-Ultra-Lean-Optimization-Utility/refs/heads/main/YMs-Ultra-Lean-Optimization-Utility.ps1 | iex
This automatically downloads and launches the full GUI.
🚀 Overview
The Ultra Lean Optimization Utility applies real, measurable system optimizations across four major categories:
Gaming Performance — Reduce latency, improve frame timing, prioritize GPU/CPU resources.
Network & Internet — Optimize TCP stack, DNS, packet handling, and throughput.
Privacy & Security — Disable telemetry, tracking, background services, and unwanted features.
Winget App Installer — Install 15 essential applications with one click.
All tweaks are optional, clearly labeled, and include hover-based benefit descriptions.
🎮 Gaming Performance (15 Tweaks)
Disable GameDVR
Enable Hardware-Accelerated GPU Scheduling
Disable Fullscreen Optimizations
Set GPU Priority to High
Disable Power Throttling
Disable Nagle’s Algorithm
Increase Network Packet Priority
Disable Mouse Acceleration
Enable High Precision Timer
Disable Xbox Services
Set Game Priority to High
Disable Fullscreen Auto-Minimize
Disable GPU Background Throttling
Disable V-Sync (NVIDIA)
Disable Windows Game Recording Overlay
🌐 Network & Internet (15 Tweaks)
Enable TCP RSS
Flush DNS & reset Winsock
Enable TCP Fast Open
Increase max user ports
Disable NetBIOS
Increase TCP window size
Disable IPv6 (optional)
Set DNS to Google
Enable Jumbo Frames
Disable Auto-Tuning
Disable SMBv1
Enable TCP Chimney Offload
Set network profile to Private
Disable Large Send Offload
Disable Windows Peer-to-Peer Updates
🔐 Privacy & Security (15 Tweaks)
Disable Telemetry
Disable Advertising ID
Disable Feedback Requests
Disable Cortana
Disable Location Tracking
Disable OneDrive
Disable Windows Error Reporting
Disable App Suggestions
Disable Background Apps
Disable Windows Spotlight
Disable Diagnostic Tracking
Disable Connected User Experience
Disable SmartScreen
Disable Wi-Fi Sense
Disable Cortana Cloud Search
📦 Winget App Installer (15 Apps)
Install essential apps with one click:
Google Chrome
Mozilla Firefox
7-Zip
VLC
Discord
Steam
OBS Studio
Spotify
Notepad++
Zoom
Microsoft Edge
Paint.NET
FileZilla
Git
Visual Studio Code
🧩 Key Features
60+ real system tweaks
Full GUI built with Windows Forms
Hover tooltips explaining each tweak
Batch apply selected optimizations
Built-in restore point creation
Modular, readable PowerShell code
No background processes, no telemetry, no bloat
🛠️ How It Works
The script dynamically builds a GUI with categorized tabs.
Each tweak includes:
A checkbox
A description
A benefit tooltip
A safe registry/service/network command
When you click Apply Selected Tweaks, only the selected items run.
⚠️ Safety Notes
Creating a restore point is strongly recommended.
Some tweaks disable Windows features you may rely on.
All changes are local and reversible via restore point.
📌 Requirements
Windows 10 or Windows 11
PowerShell 5+
Administrator privileges
⭐ Support the Project
If this utility improved your system, starring the repository helps others discover it and supports future development.
📜 License
MIT License
