try
{
    "Logging in to Azure..."
    Connect-AzAccount -Identity
}
catch {
    Write-Error -Message $_.Exception
    throw $_.Exception
}

$TTLminutes = 2
$ExpirationDate = (Get-Date).AddMinutes(-$TTLminutes)


#Get AzResourceGroup


# $rg = Get-AzResource -Tag @{'Environment'='Sandbox'}
# $rg

$resources = Get-AzResource
     Where-Object {
         $_.Tags["Environment"] -eq "Sandbox" -and
         $_.Tags.ContainsKey("CreatedOn")
     }
"$resources"