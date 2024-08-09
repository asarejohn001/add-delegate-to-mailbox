<#
Author: John Asare
Date: 8/8/2024

Desc: Add a delegate to a mailbox. Read more from https://github.com/asarejohn001/add-delegate-to-mailbox
#>

# Import the Exchange Online PowerShell module
Import-Module ExchangeOnlineManagement

function Get-Log {
    param (
        [string]$LogFilePath,
        [string]$LogMessage
    )

    # Create the log entry with the current date and time
    $logEntry = "{0} - {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $LogMessage

    # Append the log entry to the log file
    Add-Content -Path $LogFilePath -Value $logEntry
}
$logFilePath = "./log.txt"

# Connect to EXO
try {
    # Attempt to connect to Exchange Online
    Connect-ExchangeOnline -UserPrincipalName "admin@example.com" -ShowProgress $true -ErrorAction Stop
    Get-Log -LogFilePath $logFilePath -LogMessage "Successfully connected to Exchange Online."
    
} catch {
    # Handle the error if connection fails
    Get-Log -LogFilePath $logFilePath -LogMessage "Failed to connect to Exchange Online. Exiting script. Error details: $_"
    Write-Host "Couldn't connect to EXO. Check log file"
    exit
}

# Define the path to your CSV file
$csvFilePath = "enter csv path of the users"

# Import the CSV file
$users = Import-Csv -Path $csvFilePath

# Loop through each pair of CurrentUserID and DelegateUserID in the CSV file
foreach ($user in $users) {
    $currentUserID = $user.CurrentUserID
    $delegateUserID = $user.DelegateUserID
    
    # Display the current processing information
    Write-Host "Script is running..."
    Get-Log -LogFilePath $logFilePath -LogMessage "Adding permissions for delegate: $delegateUserID on mailbox: $currentUserID"

    # Add mailbox permissions (example: Full Access)
    Add-MailboxPermission -Identity $currentUserID -User $delegateUserID -AccessRights FullAccess -InheritanceType All

    # Add 'Send As' permission
    Add-RecipientPermission -Identity $currentUserID -Trustee $delegateUserID -AccessRights SendAs -Confirm:$false

    # Add additional permissions as needed, for example (uncomment below line of code to use them):
    # Add-MailboxPermission -Identity $currentUserID -User $delegateUserID -AccessRights ReadPermission -InheritanceType All

}

# Disconnect from Exchange Online
Disconnect-ExchangeOnline -Confirm:$false

Write-Host "Permissions have been added successfully."
