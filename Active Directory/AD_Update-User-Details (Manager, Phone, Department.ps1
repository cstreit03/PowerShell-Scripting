$ImportCsv = 'C:\Users.csv'

$Users = Import-Csv -Path $ImportCsv

foreach( $User in $Users ){
    $ADUser = Get-ADUser $User.Username

    if( -not $ADUser ){
        Write-Warning "$($User.Name) not found."
        continue
    }

    # Check for empty manager value and set it conditionally
    if ([string]::IsNullOrEmpty($User.Manager)) {
        Write-Verbose "Manager value is empty for $($User.Name). Skipping Manager property update."
        Set-ADUser -Identity $User.Username -MobilePhone $User.MobilePhone -Title $User.Title -Department $User.Department
    } else {
        Set-ADUser -Identity $User.Username -MobilePhone $User.MobilePhone -Title $User.Title -Manager $User.Manager -Department $User.Department
    }
}