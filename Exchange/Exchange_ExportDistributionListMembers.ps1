# Test if Windows PC or not
if (-not (Test-Path -Path "C:\Windows") ) {
    Write-Output "ERROR: This script was designed to run on the Windows 10/11 operating system."
    exit
}

# Connect to Exchange (with PW and MFA)
Connect-ExchangeOnline

$DistributionLists = Get-DistributionGroup -ResultSize Unlimited | Select *

$date = Get-Date -Format "yyyy-MM-dd" # Get date for file name
$username = [Environment]::UserName # Get current user
$ExportPath = "C:\Users\$username\Desktop\$date-Distribution-List-Members.csv" # Get file path (save to Desktop)
        
$results = @()

foreach ($DL in $DistributionLists) {
    
    $Members = Get-DistributionGroupMember $DL.ExchangeObjectId | Select *

	$result = [PSCustomObject]@{
		DistributionList = $DL.DisplayName
        EmailAddress = $DL.PrimarySmtpAddress
        Members = ($Members | ForEach-Object { $_.PrimarySmtpAddress }) -join ', '        
        
	}
	$results += $result
}

$results | Export-Csv -Path $ExportPath -NoTypeInformation 
