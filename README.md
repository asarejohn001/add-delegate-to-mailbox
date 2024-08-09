# add-delegate-to-mailbox
Using the [Add-MailboxPermission](https://learn.microsoft.com/en-us/powershell/module/exchange/add-mailboxpermission?view=exchange-ps) and [Add-RecipientPermission](https://learn.microsoft.com/en-us/powershell/module/exchange/add-recipientpermission?view=exchange-ps) you can grant a delegate to another user's mailbox.
The [Add-MailboxPermission](https://learn.microsoft.com/en-us/powershell/module/exchange/add-mailboxpermission?view=exchange-ps) grants access to the mailbox itself (e.g., "Full Access" allows a delegate to open and read the mailbox). However, it does not allow the delegate to send emails on behalf of the mailbox owner. 

The [Add-RecipientPermission](https://learn.microsoft.com/en-us/powershell/module/exchange/add-recipientpermission?view=exchange-ps) specifically used to grant permissions like "Send As," which allows a delegate to send emails as if they were the mailbox owner.

The add-delegate-to-mailbox.ps1 script will
1. Import the ExchangeOnlineManagement module and connect to your EXO environment. It show open your default browser to the EXO sign-in URl.
2. Set a variable for the users from your CSV file.
> [!IMPORTANT]
> Change the variable and also make sure the heading of your csv file matches the variables in the script.
3. Loop through the CSV file and add users from the DelegateUserID column to mailboxes on the CurrentUserID from the CSV file.