workflow ShutdownStartARM_MachinesInParallel
{
    		Param(
		[Parameter(Mandatory=$true)]
        [String]
		$ResourceGroupName,
		[Parameter(Mandatory=$true)]
        [Boolean]
		$Shutdown
	)
	
<#
    .DESCRIPTION
        This workflow runbook Shutdown or Start any VM within the ARM resource group in paralell using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Angel Godd-Santana
        LASTEDIT: April 9, 2017

        Parameters:
        String name of the Resource group containing the ARM VM
        Boolean for specifying to shtdown or start VM(s)
#>

$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}


    # Get the VMs within the specified resource group
	$vms = Get-AzureRmVM -ResourceGroupName $ResourceGroupName;
	
	Foreach -Parallel ($vm in $vms){
		
		if($Shutdown){
			Write-Output "Stopping $($vm.Name)";		
			Stop-AzureRmVm -Name $vm.Name -ResourceGroupName $ResourceGroupName -Force;
		}
		else{
			Write-Output "Starting $($vm.Name)";		
			Start-AzureRmVm -Name $vm.Name -ResourceGroupName $ResourceGroupName;
		}
	}
}