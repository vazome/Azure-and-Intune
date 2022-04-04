# This will quickly correspond UPNs between on-premise and cloud Active Directories in Hybryd AD invironment 
# Case scenario: you are implementing Azure AD Connect .. 
# .. All users existing on-premise, particular ones may have Azure AD account too (with identical SamAccountName) ..
# .. You need to make sure, users which have accounts in both directories to have same domain/UPN sufiix, so there wont be any duplicate after sync.
Connect-AzureAD

$Users = Get-ADUser -Filter {UserPrincipalName -like "*@foo.bar.com"} | Select-Object SamAccountName

foreach ($User in $Users){

    $UserName = $User.SamAccountName + "@foo.bar.com"
    $UserNameOld = $User.SamAccountName + "@somedefaultdomain.onmicrosoft.com"

    if (Get-AzureADUser -Filter "userPrincipalName eq '$UserName'") {
        Write-Output -InputObject "$($User.SamAccountName) exists with custom domain"
    }
    elseif (Get-AzureADUser -Filter "userPrincipalName eq '$UserNameOld'"){
        Set-AzureADUser -ObjectId $UserNameOld -UserPrincipalName $UserName
        Write-Output -InputObject "$($User.SamAccountName) fixed with custom domain"
    }
    else {
        Write-Output -InputObject "$($User.SamAccountName) was not found"
    }
    # Also you might use MSOL instead AzureAD, but no recommended
    # Install-Module -Name MSOL
    # Set-MsolUserPrincipalName -UserPrincipalName $UserNameOld -NewUserPrincipalName $UserName
}
