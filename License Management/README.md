# Remove-AzureADLicense

Removing stale user licenses from Microsoft 365/AzureAD is a bit clumsy, both by doing it GUI or pragrammatic way.
This script can vastly ease the pain when set on schedule every day.

## What is a stale user license?
It is a license which is assigned to any **disabled** user.

## What issue this script addresses?
You can't remove either directly or group assigned licenses from a disabled user in bulk via GUI.
Script does the following

1. Checks which groups provide licenses for disabled users.
    1. Removes users from the following groups.
2. Just in case, starts license reprocess for disabled users.
3. Checks any direct license assigments.
    1. Removes any direct license assigments for user.
