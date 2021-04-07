# W10_affinity_control
#### WSL_affinity.ps1: Set the CPU core affinity for WSL2.  This effects all running distro's, and is not persistent upon reboot, or restart of WSL.
* Why: W10/WSL scheduling high threaded workloads some times favors virtual cores to reduce power consumption at the cost of performance. This script allows for easy dynamic modification of the CPU affinity of the WSL2 virtual machine, to force it to use only one-process per CPU core and/or use only one Ryzen CPU chiplet (for Ryzen 9 processors). 

* Requires: admin privilege.  

Please Note: Most systems have scripting disabled. The examples include the command line option to ByPass this restriction

* Parameters:
    * parity: Parity Options (both binary and strings work):  
        * '11' or 'all' : (default) Select all cores  
        * '10' or 'even': Select all even virtual cores (effectively disables Hypert-Threading/SMT)  
        * '01' or 'odd' : Select all odd virtual cores (effectively disables Hypert-Threading/SMT)  
    
    * cc: Chiplet Core: Select Ryzen Compute (if Ryzen 9).   
        * Affinity parity applies to selected chiplet.  
        * -1: (default)   
        * 0 : cc0  
        * 1 : cc1  
  

* Usage Examples from an Admin Prompt (with different abreviations for parameters):
    * Set Affinity parity to even:
        * powershell -ExecutionPolicy ByPass -File WSL_affinity.ps1 -p:even
        * powershell -ExecutionPolicy ByPass -File WSL_affinity.ps1 -parity 10
    * Enable only Chiplet Core 0:
        * powershell -ExecutionPolicy ByPass -File WSL_affinity.ps1 -cc 0
    * Set Affinity parity on Chiplet Core 1 to odd (disables chiplet core 0):
        * powershell -ExecutionPolicy ByPass -File WSL_affinity.ps1 -cc:1 -parity:odd
        * powershell -ExecutionPolicy ByPass -File WSL_affinity.ps1 -cc:1 -p:01
    * Reset (all cores enabled, all threads):
        * powershell -ExecutionPolicy ByPass -File WSL_affinity.ps1
    * Change the Affinity parity of another **WINDOWS** process:
        * powershell -ExecutionPolicy ByPass -File WSL_affinity.ps1 -p:10 -name python3.exe
