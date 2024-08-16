# Test if Windows PC or not
if (-not (Test-Path -Path "C:\Windows") ) {
    Write-Output "ERROR: This script was designed to run on the Windows 10/11 operating system."
    exit
}

# Specify  the user's email
$email = 'ENTER EMAIL HERE'

# Connect to Exchange (with PW and MFA)
Connect-ExchangeOnline

# Create loop to automatically start process every 15 minutes
while($true) {

    # Start the Managed Folder Assistant 
    # Reference: https://learn.microsoft.com/en-us/powershell/module/exchange/start-managedfolderassistant
    Start-ManagedFolderAssistant -Identity $email
    
    # Get the date for output and write output for logs
    $date = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$date // Managed Folder Assistant started for $email"

    # Wait 10 minutes before running again
    Start-Sleep -Seconds 600

}