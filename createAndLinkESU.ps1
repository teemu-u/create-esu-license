# Example CSV File;
#"VirtualMachineName";"LicenseName";"ResourceGroup";"SubscriptionId";"CoreCount";"CoreType";"OS";"LicenseEdition";"Tags"
#"VirtualMachineName";"License1";"test";"f492f182-c3b1-416f-b78e-3c0b77375c31";"12";"vCore";"Windows Server 2012";"Standard";"Datacenter=DC1,City=Helsinki"
#"VirtualMachineName";"License2";"test";"f492f182-c3b1-416f-b78e-3c0b77375c31";"8";"pCore";"Windows Server 2012 R2";"Datacenter";"Datacenter=DC1,City=Helsinki"
#"VirtualMachineName";"License3";"test";"f492f182-c3b1-416f-b78e-3c0b77375c31";"16";"vCore";"Windows Server 2012 R2";"Standard";"Datacenter=DC1,City=Oulu"

# Login to Azure
#Connect-AzAccount
# Get the access token
#$token = (Get-AzAccessToken).Token
$csv = .\example.csv
# Check if CSV file exists
if (-not (Test-Path $csv)) {
    Write-Host "CSV file not found, exiting..."
    Exit
}
# Import data from CSV file
else {
    Write-Host "CSV file found, importing..."
    $csv = Import-Csv -Path $csv -Delimiter ';'
}

# Check if CSV file is empty
if ($null -eq $csv) {
    Write-Host "Mapping file empty, exiting..."
    Exit
}

# Convert tags to hashtable
foreach ($row in $csv) {
    if ($row.Tags -ne '') {
        $tags = @{}
        foreach ($tag in $row.Tags.Split(',')) {
            $keyValue = $tag.Split('=')
            $tags += @{ $keyValue[0] = $keyValue[1] }
        }
        $row.Tags = $tags
    }
    else {
    $row.Tags = @{}
    }
}

# Create & Link ESU licenses for each row in CSV file
foreach ($line in $csv) {
    $Url = 'https://management.azure.com/subscriptions/' + $line.SubscriptionId + '/resourceGroups/' + $line.ResourceGroup + '/providers/Microsoft.HybridCompute/licenses/' + $line.LicenseName + '?api-version=2023-06-20-preview' 
    $Headers = @{ "Authorization" = "Bearer $token" }
    $Body = @{ 
        "location" = "West Europe" 
        "tags" = $line.Tags
        "properties" = @{
            "licenseDetails" = @{ 
                "state" = "Activated"  # Deactivated, Activated
                "target" = $line.OS
                "Edition" = $line.LicenseEdition
                "Type" = $line.CoreType
                "Processors" = $line.CoreCount
            }
        }
    } | ConvertTo-Json
    $result = Invoke-RestMethod -Method Put -Uri $Url -Headers $Headers -Body $Body -ContentType "application/json"
   
    
    $Url = 'https://management.azure.com/subscriptions/' + $line.SubscriptionId + '/resourceGroups/' + $line.ResourceGroup + '/providers/Microsoft.HybridCompute/machines/' + $line.VirtualMachine + '/licenseProfiles/default?api-version=2023-06-20-preview'
    $Headers = @{ "Authorization" = "Bearer $token" }
    $Body = @{ 
        "location" = "West Europe" 
        "properties" = @{
            "esuProfile" = @{
                "assignedLicense" = $result.id
            }
        }
    } | ConvertTo-Json
    Invoke-RestMethod -Method Put -Uri $Url -Headers $Headers -Body $Body -ContentType "application/json"
}
