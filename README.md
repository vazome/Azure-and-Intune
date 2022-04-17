# Azure and 365
## [Remove-AzureADLicenses](https://github.com/vazome/Azure-and-Intune/blob/45b965b2bae73d6788b901a01f1f3b16fd1109bd/License%20Management/Remove-AzureADLicenses.ps1)
### Issue
You can't remove either directly or group assigned licenses from a disabled user in bulk via GUI.

The script does the following:

1. Checks which groups provide licenses for disabled users.
    1. Removes users from the following groups.
2. Just in case, starts license reprocess for disabled users.
3. Checks any direct license assigments.
    1. Removes any direct license assigments for disabled users.
## [EqualizeHybridDomains](https://github.com/vazome/Azure-and-Intune/blob/0b3acfcd3ea5fb958315c7f7275a336c934a4a91/EqualizeHybridDomains.ps1)
### Issue
To prevent duplicate creation by [Azuew AD Connect](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/whatis-azure-ad-connect), this script:

1. Gets all users on-premise AD with specified UPN Suffix (user@**foo.bar.com**)
2. Checks by samAccountName whether these users have proper UPN Suffix set in the Azure AD
3. If instead of specified domain they have @somethinig.onmicrosoft.com it will replace it.

# Intune
## [AnyconnectProfileWIN](https://github.com/vazome/Azure-and-Intune/blob/a41c68d2440fe00b1c6fb8e214b53b88eee6ee82/Intune/User%20Configuration/AnyconnectProfileWIN.ps1)
### Issue
It just deploys proper Cisco Anyconnect profile with your values.

Frees users from headache of deploying Cisco configuration.
## [ShortcutsWindows](https://github.com/vazome/Azure-and-Intune/blob/45b965b2bae73d6788b901a01f1f3b16fd1109bd/Intune/User%20Configuration/ShortcutsWindows.ps1)
### Issue
Example which deploys for Win32 and MS Store applications 
