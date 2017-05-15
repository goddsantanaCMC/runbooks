workflow StartPSDCDEMO_2
{
   <#
    .DESCRIPTION
        This workflow runbook Start any VM within the ARM resource group using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Angel Godd-Santana
        LASTEDIT: May 14, 2017

        Parameters:
        String name of the Resource group containing the ARM VM
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

    $ResourceGroupName = 'psctpDCDemoResGP';
   	# $vm = 'PSDCDEMO';


			Write-Output "Starting $('PSDCDEMO')";		
			Start-AzureRmVm -Name 'PSDCDEMO' -ResourceGroupName $ResourceGroupName;

}