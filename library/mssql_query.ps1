#!powershell

#Requires -Module Ansible.ModuleUtils.Legacy
#AnsibleRequires -OSVersion 6.2
#AnsibleRequires -CSharpUtil Ansible.Basic

$spec = @{
    options = @{
        vmhostname = @{ type = "list" }
    }
}

$module = [Ansible.Basic.AnsibleModule]::Create($args, $spec)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

# Functions
Function Connect-VeeamServer {
    try {
        Add-PSSnapin -PassThru VeeamPSSnapIn -ErrorAction Stop | Out-Null
    }
    catch {
        Fail-Json -obj @{} -message  "Failed to load Veeam SnapIn on the target: $($_.Exception.Message)"  
    }

    try {
        Connect-VBRServer -Server localhost
    }
    catch {
        Fail-Json -obj @{} -message "Failed to connect VBR Server on the target: $($_.Exception.Message)"  
    }
}
Function Disconnect-VeeamServer {
    try {
        Disconnect-VBRServer
    }
    catch {
        Fail-Json -obj @{} -message "Failed to disconnect VBR Server on the target: $($_.Exception.Message)"  
    }
}

# Connect
Connect-VeeamServer

#Quickbackup logic
$result = New-Object PSObject;
Set-Attr $result "changed" $false;

$VMEnts = $module.Params.vmhostname 

$viEntis = @()
Foreach($VMEnt in $VMEnts){

    #Find VMWare entity
    $a = $null
    $a = Find-VBRViEntity -name $VMEnt

    if(!$a){
        Fail-Json -obj @{} -message "Could not find $VMEnt"
    } Else {

        $viEntis += $a

        #Find JObobject
        $JobObject = get-vbrjob | Get-VBRJobObject -Name $VMEnt
        if(!$JobObject){
            Fail-Json -obj @{} -message "$VMEnt NOT in a backupjob, cant make quickbackup"
        }
        
    }


}

$result = Start-VBRQuickBackup -vm $viEntis -wait -ErrorAction Continue

if (!$Result) {
    Fail-Json -obj @{} -message "NO Quickbackup has been created.."
}

Elseif ($Result.Result -eq "Succes" -or $result.Result -eq "Warning") {
    $module.Result.msg = "Succesfully created the quickbackups"
    $module.Result.changed = $true
}

Elseif ($Result.Result -eq "Failed") {
    Fail-Json -obj @{} -message "Quick Backup Failed. See Veeam B&R Console for more details!"
} Else {}

# Disconnect
Disconnect-VeeamServer

# Return result
$module.ExitJson()
