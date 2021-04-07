# W10_affinity_control
Set the CPU core affinity for WSL2.  This effects all running distro's.
Requires: admin privilege . 

Parameters:
parity: Parity Options (both binary and strings work):
    11/all : (default) Select all cores
    10/even: Select all even virtual cores (effectively disables Hypert-Threading/SMT)
    01/odd : Select all odd virtual cores (effectively disables Hypert-Threading/SMT)
    
cc: Chiplet Core: Select Ryzen Compute (if Ryzen 9). 
    Affinity parity applies to selected chiplet.
    -1: (default) 
    0 : cc0
    1 : cc1
