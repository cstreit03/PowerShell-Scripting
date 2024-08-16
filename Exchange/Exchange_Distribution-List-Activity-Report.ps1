# Test if Windows PC or not
if (-not (Test-Path -Path "C:\Windows") ) {
    Write-Output "ERROR: This script was designed to run on the Windows 10/11 operating system."
    exit
}

# Define path
$date = Get-Date -Format "yyyy-MM-dd" # Get date for file name
$username = [Environment]::UserName # Get current user
$ExportPath = "C:\Users\$username\Desktop\$date-Distribution-Lists-Activity.csv" # Get file path (save to Desktop)

# Connect to Exchange (with PW and MFA)
Connect-ExchangeOnline

# Get list of DLs
$DistributionLists = Get-DistributionGroup -ResultSize Unlimited | Select *

# Get end date
$EndDate = Get-Date -Format "MM/dd/yyyy"

# Get start date
$StartDate = ((get-date).AddDays(-10)).ToString("MM/dd/yyyy") 

$results = @()

foreach ($DL in $DistributionLists) {

    # Get the message trace results
    $TraceResults = Get-MessageTrace -RecipientAddress $DL.PrimarySmtpAddress -StartDate $StartDate -EndDate $EndDate
   
    # Get most recent message
    $MostRecentMessage = $TraceResults.Received | sort Received -Descending | select -Last 1

    # Get the oldest available message
    $OldestMessage = $TraceResults.Received | sort Received -Descending | select -First 1

    # Get list of senders
    $Senders = ($TraceResults | ForEach-Object { $_.SenderAddress }) -join ', '

    # Get list of subject lines
    $SubjectLines = ($TraceResults | ForEach-Object { $_.Subject }) -join ', '

    # Save items to an object
	$result = [PSCustomObject]@{
		DistributionList = $DL.DisplayName
        EmailAddress = $DL.PrimarySmtpAddress
        TotalMessagesReceived = $TraceResults.count
        MostRecentMessageDate = $MostRecentMessage
        OldestMessageDate = $OldestMessage
        RecentSenders = $Senders
        MessageSubjectLines = $SubjectLines
        
	}

    # Append object to list
	$results += $result
}

# Export results
$results | Export-Csv -Path $ExportPath -NoTypeInformation 