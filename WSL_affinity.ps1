param (
    # Parity: even or odd -> Physical cores. all -> All virtual cores with HyperThread or SMT    
    [string]$parity = "all",


    # process name, if different from vmmem    
    [string]$name= "vmmem",
    
    # which chiplet core indexed to 0, if applicable. -1 is all.
    [int]$cc = -1

)
<#
    .SYNOPSIS
        Sets the CPU core affinity for a running WSL2 virtual machine. This effects all running distro's.
        parity: Parity Options (both binary and strings work):
            11/all : Select all cores
            10/even: Select all even virtual cores (effectively disables Hypert-Threading/SMT)
            01/odd : Select all odd virtual cores (effectively disables Hypert-Threading/SMT)
            
        cc: Chiplet Core: Select Ryzen Compute (if Ryzen 9). 
            Affinity parity applies to selected chiplet.
            -1: (default) all chiplets
            0 : cc0
            1 : cc1            
...
#>

$N_proc = $env:NUMBER_OF_PROCESSORS

    # If we are not setting cc0 or cc1 parity may be set on command line using
    # 11, 01 or 10
    $valid_parity = "11", "all", "10", "even", "01", "odd"
    if (-Not $valid_parity.Contains($parity)){
        Write-Host "Parity: " $parity
        Write-Host "Error: Invalid parity. Options are '11', '10' or '01', and 'all', 'even' or 'odd'"
        Break Script
    }

    If ($parity -eq "even"){
        $parity = "10"
        }

    ElseIf ($parity -eq "odd"){
        $parity = "01"
        }

    ElseIf ($parity -eq "all"){
        $parity = "11"
        }
 

# Parity may be defined as a Ryzen compute core, but only if the CPU is a Ryzen 9 with 2.
If ($cc -ge 0){
    $CPU_name = Get-WmiObject -class win32_processor -Property  "Name" | Select-Object -ExpandProperty "Name"
    If ($CPU_name -like '*Ryzen 9*'){

        $p0 = $parity * ($N_proc/4)
        $p1 = "00" * ($N_proc/4)
        $affinity_binary = ($p0 + $p1)*$cc + ($p1 + $p0)*(1-$cc)
    }
    Else{
        Write-Host "Error: Can only select a Chiplet Core (cc) when using Ryzen 9"
        Break Script
    }

}
Else{
    $affinity_binary = $parity*($N_proc/2)
}

# Convert the binary affinity into an integer affinity value
$dec_affval = [convert]::toint64($affinity_binary,2)


$Process = Get-Process $name
$Process.ProcessorAffinity=$dec_affval
