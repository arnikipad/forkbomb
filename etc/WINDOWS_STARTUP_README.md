PowerShell Registry Script for Fork Bomb BSOD Startup
=====================================================

This PowerShell script registers the fork bomb to run automatically after Windows startup.

USAGE (Run as Administrator):
----
powershell -ExecutionPolicy Bypass -File install_bsod_startup.ps1

OR add to Group Policy:

1. Open Group Policy Editor (gpsedit.msc)
2. Navigate to: Computer Configuration > Windows Settings > Scripts > Startup
3. Add a new script with the path to forkbomb_windows.exe

REGISTRY PATHS:

HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  - System-wide startup (all users)
  
HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
  - Current user only

STARTUP MODES:

1. Run Key (simplest)
   - Adds executable to Run registry key
   - Executes after user login
   
2. Scheduled Task
   - More reliable for BSOD recovery scenarios
   - Can trigger on system startup event
   
3. WMI Event Subscription
   - Triggers on specific system events
   - Requires elevated privileges

WARNING:
========
This will make your system completely unstable!
Only use in isolated virtual machines for testing/educational purposes.
