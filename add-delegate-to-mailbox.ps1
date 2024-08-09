<#
Author: John Asare
Date: 8/8/2024

Desc: Add a delegate to a mailbox. Read more from https://github.com/asarejohn001/add-delegate-to-mailbox
#>

# Import the Exchange Online PowerShell module
Import-Module ExchangeOnlineManagement

# Connect to Exchange Online
Connect-ExchangeOnline -UserPrincipalName "admin@example.com" -ShowProgress $true

# Define the path to your CSV file
$csvFilePath = "enter csv path of the users"

# Import the CSV file
$users = Import-Csv -Path $csvFilePath

# Loop through each pair of CurrentUserID and DelegateUserID in the CSV file
foreach ($user in $users) {
    $currentUserID = $user.CurrentUserID
    $delegateUserID = $user.DelegateUserID
    
    # Display the current processing information
    Write-Host "Adding permissions for delegate: $delegateUserID on mailbox: $currentUserID"

    # Add mailbox permissions (example: Full Access)
    Add-MailboxPermission -Identity $currentUserID -User $delegateUserID -AccessRights FullAccess -InheritanceType All -AutoMapping $false

    # Add 'Send As' permission
    Add-RecipientPermission -Identity $currentUserID -Trustee $delegateUserID -AccessRights SendAs -Confirm:$false

    # Add additional permissions as needed, for example (uncomment below line of code to use them):
    # Add-MailboxPermission -Identity $currentUserID -User $delegateUserID -AccessRights ReadPermission -InheritanceType All

}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false

Write-Host "Permissions have been added successfully."
