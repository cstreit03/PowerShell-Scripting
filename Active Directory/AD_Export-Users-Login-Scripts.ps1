# Export list of AD Users and their groups

$date = Get-Date -Format "yyyy-MM-dd" # Get date for file name
$username = [Environment]::UserName # Get current user
$ExportPath = "C:\Users\$username\Desktop\$date-AD_User-Login-Scripts.csv" # Get file path (save to Desktop)

# Single line to export results with 
get-aduser -filter * -Properties ScriptPath |select name, UserPrincipalName, scriptpath | export-csv $ExportPath -nti