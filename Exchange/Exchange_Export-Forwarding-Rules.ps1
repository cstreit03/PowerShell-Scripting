# Test if Windows PC or not
if (-not (Test-Path -Path "C:\Windows") ) {
    Write-Output "ERROR: This script was designed to run on the Windows 10/11 operating system."
    exit
}

# Connect to Exchange (with PW and MFA)
Connect-ExchangeOnline

$date = Get-Date -Format "yyyy-MM-dd" # Get date for file name
$username = [Environment]::UserName # Get current user
$ExportPath = "C:\Users\$username\Desktop\$date-Exchange-Forward-Rules-Report.csv" # Get file path (save to Desktop)

$rules = Get-Mailbox | select DisplayName,UserPrincipalName,ForwardingSmtpAddress,DeliverToMailboxAndForward

$rules | Export-Csv -Path $ExportPath -NoTypeInformation
